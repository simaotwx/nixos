{
  config,
  lib,
  pkgs,
  ...
}:
{

  options = {
    customization.graphics = {
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
          rev = "60419dcda0987be3ae7afa37a5345c2399af420d";
          hash = "sha256-Z97jwjRw7/jMembBaZJaAoE2S+xxK3FQ7hAT5dn12rU=";
        };
        installPhase = ''
          mkdir -p $out/bin
          install -Dm755 ${name} $out/bin/${name}
        '';
      };
    in
    {
      customization.hardware.gpu.amdSupport = true;
      customization.hardware.gpu.rocmPackages =
        if customization.hardware.graphics.latestMesa then pkgs.unstable.rocmPackages else pkgs.rocmPackages;

      boot.kernelParams =
        lib.optionals customization.graphics.amd.overclocking.unlock [ "amdgpu.ppfeaturemask=0xfff7ffff" ]
        ++ [ ];

      environment.systemPackages =
        [ ] ++ (if customization.graphics.amd.overclocking.unlock then [ amdgpuClocks ] else [ ]);

      hardware.amdgpu.amdvlk = {
        enable = false;
        support32Bit.enable = false;
      };
      hardware.amdgpu.initrd.enable = true;
      # Do not set this to true because the code after it already does the same
      hardware.amdgpu.opencl.enable = lib.mkForce false;
      hardware.enableRedistributableFirmware = lib.mkDefault true;
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with (if customization.hardware.graphics.latestMesa then pkgs.unstable else pkgs); [
          rocmPackages.clr
          rocmPackages.clr.icd
        ];
      };

      environment.variables = {
        AMD_VULKAN_ICD = "RADV";
      };
    };
}
