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
    hardware.opengl = {
      enable = true;
      extraPackages = [
        pkgs.vpl-gpu-rt
      ];
    };
  };
}