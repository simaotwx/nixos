{ lib, config, pkgs, ... }: {
  options = {
    customization.kodi = {
      user = lib.mkOption {
        type = lib.types.str;
        description = "Which user to set up Kodi for";
      };
      plugins = lib.mkOption {
        type = with lib.types; listOf package;
        description = "Plugins to install (see kodiPackages)";
        default = [];
      };
      kodiData = lib.mkOption {
        type = lib.types.str;
        default = "${config.customization.kodi.user}/.kodi";
      };
      widevine = lib.mkEnableOption "Widevine CDM (unfree)";
      settings = {
        guisettings = lib.mkOption {
          type = with lib.types; nullOr lines;
          description = "XML for GUI settings";
          default = null;
        };
      };
    };
  };

  config =
  let
    cfg = config.customization.kodi;
  in lib.mkMerge [{
    services.xserver.desktopManager.kodi = {
      enable = true;
      package = pkgs.kodi-gbm;
    };
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal";
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          #command = "${pkgs.bash}/bin/bash";
          command = "KODI_DATA='${cfg.kodiData}' ${pkgs.kodi-gbm}/bin/kodi-standalone --audio-backend=alsa";
          user = cfg.user;
        };
        default_session = initial_session;
      };
    };
    services.displayManager.autoLogin.user = cfg.user;
    environment.systemPackages = [
      (pkgs.kodi-gbm.withPackages (kodiPkgs: cfg.plugins))
    ];
    # We want to have ALSA as sound system. Kodi will play well with this
    # and it allows us to do HDMI passthrough.
    #hardware.alsa.enable = true; not available on 24.11, is already enabled I guess
    hardware.alsa.enablePersistence = false;
    services.pipewire.enable = false;
    services.pipewire.socketActivation = false;
  } {
    users.users.${cfg.user} = {
      extraGroups = [ "video" "input" ];
    };
  }];
}