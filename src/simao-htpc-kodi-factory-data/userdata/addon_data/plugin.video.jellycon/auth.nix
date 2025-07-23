{ config, ... }:
let
  cfg = config.customization.kodi.addons."plugin.video.jellycon".settings;
in
builtins.toJSON cfg.users
