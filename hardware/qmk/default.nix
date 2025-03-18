{ lib, config, ... }: {
  options = {
    customization.peripherals = {
      qmk.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to set up QMK keyboard support";
      };
    };
  };

  config =
  let customization = config.customization;
  in
  lib.mkIf customization.peripherals.qmk.enable {
    hardware.keyboard.qmk.enable = true;
  };
}