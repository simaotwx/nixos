{ config, lib, pkgs, ... }: {

  options = {
    customization.graphics = {
      intel.xe.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to set up Intel Xe graphics support";
      };
    };
  };

  config =
  let customization = config.customization;
  in
  lib.mkIf customization.graphics.intel.xe.enable {
    environment.variables = {
      VDPAU_DRIVER = "va_gl";
    };
    environment.systemPackages = with pkgs; [
      intel-gmmlib
    ];
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-vaapi-driver
        intel-media-driver
        libvdpau-va-gl
        intel-compute-runtime
        vpl-gpu-rt
        mesa
      ];
    };
  };
}