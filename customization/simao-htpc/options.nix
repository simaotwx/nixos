{ lib, ... }:
{
  options = {
    customization.kodi = {
      settings = {
        deviceUuid = lib.mkOption {
          description = "UUID of your device. Please generate one or reuse from previous installation.";
          default = "";
          type = lib.types.str;
        };
        webserver = {
          enable = lib.mkEnableOption "Kodi Webserver";
          username = lib.mkOption {
            type = lib.types.str;
            default = "kodi";
          };
          password = lib.mkOption {
            type = lib.types.str;
            default = "";
          };
        };
      };
      addons = {
        "plugin.video.youtube" = {
          settings = {
            apiKey = lib.mkOption {
              type = lib.types.str;
              default = "";
            };
            apiClientId = lib.mkOption {
              type = lib.types.str;
              default = "";
            };
            apiClientSecret = lib.mkOption {
              type = lib.types.str;
              default = "";
            };
          };
        };
        "plugin.video.jellycon" = {
          settings = {
            username = lib.mkOption {
              type = lib.types.str;
              default = "";
            };
            serverAddress = lib.mkOption {
              type = lib.types.str;
              default = "";
            };
            users = lib.mkOption {
              type = with lib.types; attrsOf (attrsOf str);
              default = { };
            };
          };
        };
      };
    };
  };
}
