{ lib, config, ... }: {
  options = {
    customization.peripherals = {
      razer.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to set up Razer peripheral support";
      };
    };
  };

  config =
  let customization = config.customization;
  in
  lib.mkIf customization.peripherals.razer.enable {
    hardware.openrazer.enable = true;
    # TODO: add user hardware.openrazer.users = [
  };
}