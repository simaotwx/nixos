{ lib, config, ... }:
{
  options = {
    customization = {
      debug.enable = lib.mkEnableOption "debugging";
    };
  };

  config =
    let
      customization = config.customization;
    in
    {
      boot.initrd.verbose = customization.debug.enable;
      boot.kernelParams =
        if customization.debug.enable then
          [
            "rd.systemd-show_status=true"
            "systemd.setenv=SYSTEMD_SULOGIN_FORCE=1"
          ]
        else
          [
            "quiet"
            "loglevel=2"
            "rd.systemd.show_status=false"
            "rd.udev.log_level=3"
            "udev.log_priority=3"
          ];

    };
}
