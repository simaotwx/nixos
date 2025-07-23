{
  config,
  pkgsUnstable,
  mkConfigurableUsersOption,
  ...
}:
{
  options = {
    customization.peripherals = {
      razer.users = mkConfigurableUsersOption {
        description = "Which users to apply razer configuration to. Defaults to all users.";
      };
    };
  };

  config =
    let
      customization = config.customization;
    in
    {
      hardware.openrazer.enable = true;
      hardware.openrazer.users = customization.peripherals.razer.users;
      environment.systemPackages = with pkgsUnstable; [
        openrazer-daemon
        polychromatic
      ];
      nixpkgs.overlays = [
        (final: prev: {
          linuxPackagesFor =
            kernel:
            (prev.linuxPackagesFor kernel).extend (
              lpfinal: lpprev: {
                openrazer = (pkgsUnstable.linuxPackagesFor kernel).openrazer;
              }
            );
        })
      ];
    };
}
