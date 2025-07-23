{
  lib,
  config,
  options,
  ...
}:
{
  options = {
    customization.general = {
      hostName = lib.mkOption {
        type = lib.types.str;
        description = "Hostname to use. Should be the same as in flake.nix";
      };
      timeZone = lib.mkOption {
        type = options.time.timeZone.type;
        description = options.time.timeZone.description;
        default = "Etc/UTC";
      };
      defaultLocale = lib.mkOption {
        type = options.i18n.defaultLocale.type;
        description = options.i18n.defaultLocale.description;
        default = "en_US.UTF-8";
      };
      keymap = lib.mkOption {
        type = lib.types.str;
        description = "Keymap to use like en or de";
        default = "en";
      };
    };
  };

  config =
    let
      customization = config.customization;
    in
    {
      time.timeZone = lib.mkDefault customization.general.timeZone;
      i18n.supportedLocales = [
        "C.UTF-8/UTF-8"
        "en_US.UTF-8/UTF-8"
      ];
      users.mutableUsers = false;
      networking.hostName = customization.general.hostName;
    };
}
