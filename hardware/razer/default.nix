{ lib, config, ... }: {
  options = {
    customization.peripherals = {
      razer.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to set up Razer peripheral support";
      };
      razer.users = lib.mkOption {
        type = with lib.types; listOf str;
        default = config.configurableUsers;
        description = "Which users to apply razer configuration to. Defaults to all users.";
      };
    };
  };

  config =
  let customization = config.customization;
  in
  lib.mkIf customization.peripherals.razer.enable {
    hardware.openrazer.enable = true;
    hardware.openrazer.users = customization.peripherals.razer.users;
  };
}