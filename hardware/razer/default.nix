{ lib, config, pkgsUnstable, mkConfigurableUsersOption, ... }: {
  options = {
    customization.peripherals = {
      razer.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to set up Razer peripheral support";
      };
      razer.users = mkConfigurableUsersOption {
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
    environment.systemPackages = with pkgsUnstable; [
      openrazer-daemon
      polychromatic
    ];
    nixpkgs.overlays = [
      (final: prev: {
        linuxPackagesFor = kernel:
          (prev.linuxPackagesFor kernel).extend (lpfinal: lpprev: {
            openrazer = (pkgsUnstable.linuxPackagesFor kernel).openrazer;
          });
      })
    ];
  };
}