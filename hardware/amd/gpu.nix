{ config, lib, pkgs, pkgsUnstable, ... }: {

  options = {
    customization.graphics = {
      amd.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to set up AMD graphics support";
      };
      amd.overclocking.unlock = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to unlock the graphics card to support OC/UC/OV/UV features";
      };
      amd.latestMesa = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to use the latest Mesa version from nixpkgs-unstable";
      };
    };
  };

  config =
  let
    customization = config.customization;
    amdgpuClocks = pkgs.stdenv.mkDerivation rec {
      name = "amdgpu-clocks";
      src = pkgs.fetchFromGitHub {
        owner = "sibradzic";
        repo = name;
        rev = "504785df769e1d128d16a6f1545d2f425d70a310";
        hash = "sha256-z1CpgIo7XZSNcAH8lACGvYkRwvGXkE0HaZTBJnKOXIg=";
      };
      installPhase = ''
        mkdir -p $out/bin
        install -Dm755 ${name} $out/bin/${name}
      '';
    };
  in
  lib.mkIf customization.graphics.amd.enable {
    boot.kernelParams =
      lib.optionals customization.graphics.amd.overclocking.unlock [ "amdgpu.ppfeaturemask=0xfff7ffff" ] ++
      [];

    environment.systemPackages = []
      ++ (if customization.graphics.amd.overclocking.unlock then [ amdgpuClocks ] else []);

    hardware.amdgpu.amdvlk = {
      enable = false;
      support32Bit.enable = false;
    };
    hardware.amdgpu.initrd.enable = true;
    # Do not set this to true because the code after it already does the same
    hardware.amdgpu.opencl.enable =lib.mkForce false;
    hardware.enableRedistributableFirmware = lib.mkDefault true;
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    } // (if customization.graphics.amd.latestMesa then {
      package = pkgsUnstable.mesa;
      package32 = pkgsUnstable.driversi686Linux.mesa;
      extraPackages = with pkgsUnstable; [
        rocmPackages.clr
        rocmPackages.clr.icd
      ];
    } else {
      extraPackages = with pkgs; [
        rocmPackages.clr
        rocmPackages.clr.icd
      ];
    });

    environment.variables = {
      AMD_VULKAN_ICD = "RADV";
    };
  };
}