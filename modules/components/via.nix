{ lib, config, pkgs, ... }: {
  options = {
    customization.peripherals = {
      via.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to set up basic VIA support";
      };
      via.software.enable = lib.mkEnableOption "VIA software";
    };
  };

  config =
  let customization = config.customization;
  in
  lib.mkIf customization.peripherals.via.enable {
    hardware.keyboard.qmk.enable = true;
    services.udev = {
      packages = [
        pkgs.via
      ];
    };
  };
}