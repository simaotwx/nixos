{ config, lib, pkgs, ... }: {

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
    };
  };

  config =
  let customization = config.customization;
  in
  lib.mkIf customization.graphics.amd.enable {
    boot.kernelParams =
      lib.optionals customization.graphics.amd.overclocking.unlock [ "amdgpu.ppfeaturemask=0xfff7ffff" ] ++
      [];

    hardware.amdgpu.amdvlk = {
      enable = false;
      support32Bit.enable = false;
    };
    hardware.amdgpu.initrd.enable = true;
    hardware.amdgpu.opencl.enable = true;
    hardware.enableRedistributableFirmware = lib.mkDefault true;
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];
    };

    environment.variables = {
      AMD_VULKAN_ICD = "RADV";
    };
  };
}