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
  let cfg = config.customization.kodi;
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
          command = "${pkgs.kodi-gbm}/bin/kodi-standalone";
          user = "htpc";
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
    home-manager.users.${cfg.user} = lib.mkIf cfg.widevine {
      home.file.widevine-lib = {
        source = "${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so";
        target = ".kodi/cdm/libwidevinecdm.so";
      };
      home.file.widevine-manifest = {
        source = "${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm/manifest.json";
        target = ".kodi/cdm/manifest.json";
      };
    };
  } {
    home-manager.users.${cfg.user} = {
      home.file =
      let
        kodiData = ".kodi/userdata";
        settings = cfg.settings;
      in {
        "${kodiData}/guisettings.xml" = lib.mkIf (settings.guisettings != null) {
          text = settings.guisettings;
        };
      };
    };
  }];
}