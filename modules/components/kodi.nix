{ lib, config, inputs, system, ... }: {
  options = {
    customization.kodi = {
      user = lib.mkOption {
        type = lib.types.str;
        description = "Which user to set up Kodi for";
      };
      plugins = lib.mkOption {
        type = with lib.types; anything;
        description = "Plugins to install (see kodiPackages). Lambda.";
        default = (kodiPkgs: []);
      };
      kodiData = lib.mkOption {
        type = lib.types.str;
        default = "${config.customization.kodi.user}/.kodi";
      };
    };
  };

  config =
  let
    cfg = config.customization.kodi;
    pkgsUnstable = import inputs.nixpkgs-unstable { inherit system; };
    kodiPackage = pkgsUnstable.kodi-gbm.withPackages cfg.plugins;
  in lib.mkMerge [{
    services.xserver.enable = true;
    services.xserver.desktopManager.session = [
      {
        name = "kodi";
        start = ''
          LIRC_SOCKET_PATH=/run/lirc/lircd KODI_DATA='${cfg.kodiData}' \
            ${kodiPackage}/bin/kodi --standalone --audio-backend=alsa &
          waitPID=$!
        '';
      }
    ];
    environment.systemPackages = [ kodiPackage ];
    services.xserver.displayManager.lightdm.greeter.enable = false;
    services.displayManager.autoLogin.user = cfg.user;
    # We want to have ALSA as sound system. Kodi will play well with this
    # and it allows us to do HDMI passthrough.
    #hardware.alsa.enable = true; not available on 24.11, is already enabled
    hardware.alsa.enablePersistence = false;
    services.pipewire.enable = false;
    services.pipewire.socketActivation = false;
  } {
    users.users.${cfg.user} = {
      extraGroups = [ "video" "input" ];
    };
  }];
}