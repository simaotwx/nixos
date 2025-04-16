{ config, ... }:
let
  cfg = config.customization.kodi.addons."plugin.video.youtube".settings;
in
builtins.toJSON {
  keys = {
    developer = {};
    personal = {
      api_key = cfg.apiKey;
      client_id = cfg.apiClientId;
      client_secret = cfg.apiClientSecret;
    };
  };
}