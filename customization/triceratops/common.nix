{ pkgs, lib, ... }: {
  imports = [
    ../../modules/components/zsh.nix
    ../../modules/components/via.nix
    ../../modules/components/gnome.nix
  ];

  customization = {
    desktop = {
      gnome = {
        extensions = with pkgs.gnomeExtensions; [
          vitals
          user-themes
          dock-from-dash
          clipboard-indicator
          caffeine
          transparent-top-bar-adjustable-transparency
          kernel-indicator
          window-is-ready-remover
        ];
      };
    };
  };

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "de_DE.UTF-8/UTF-8"
  ];

  services.fwupd.enable = true;

  users.users.noah = {
    isNormalUser = true;
    extraGroups = [ "wheel" "cdrom" ];
    uid = 1000;
    hashedPassword = "$y$j9T$MXSMjuO2SULmBg9oXnbNB/$FnU.BdkloQ4eFdBkLdXMT6F7vM6zXN4QWuzcjgH..s1";
    shell = pkgs.zsh;
  };

  users.groups.noah.gid = 1000;

  services.gvfs.enable = true;
  programs.adb.enable = true;
  programs.gamemode.enable = true;
  services.libinput.enable = true;
  programs.dconf.enable = true;

  security.sudo = {
    enable = true;

  };

  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" "Hasklig" ]; })
      noto-fonts noto-fonts-emoji noto-fonts-cjk-sans
      liberation_ttf
      fira
      material-icons
      material-symbols
      roboto
      hasklig
      iosevka
      iosevka-comfy.comfy
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Liberation Serif" ];
        sansSerif = [ "Fira Sans" "Noto" ];
        monospace = [ "Hasklug" ];
        emoji = [ "Noto Color Emoji" ];
      };
      hinting = {
        enable = true;
        style = "slight";
      };
      subpixel.rgba = "rgb";
    };
  };

  environment = {
    systemPackages = with pkgs; [
      file
      vim
      dust
      duperemove
      ripgrep
      polkit-kde-agent
      exfatprogs #bcachefs-tools
      nix-bundle
    ];
    defaultPackages = [ ];
    variables = {
      EDITOR = "vim";
      VISUAL = "vim";
      PAGER = "less";
      BROWSER = "zen";
    };
  };

  programs.gnupg.agent = {
     enable = true;
  };

  services.udev.packages = with pkgs; [
    android-udev-rules
  ];

  services.dbus.enable = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  programs.steam = {
    enable = true;
    package = pkgs.steam;
  };

  security.polkit.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "discord"
    "spotify"
    "steam"
    "steam-original"
    "steam-run"
    "steam-unwrapped"
    "makemkv"
    "android-studio-stable"
  ];

  virtualisation.docker.enable = true;
  #virtualisation.docker.rootless = {
  #  enable = true;
  #  setSocketVariable = true;
  #};
  virtualisation.docker.storageDriver = "overlay2";
  systemd.services.docker.wantedBy = lib.mkForce [];
  systemd.services.docker.serviceConfig.Restart = lib.mkForce "no";
  virtualisation.docker.daemon.settings = {
    userland-proxy = false;
    ipv6 = true;
    fixed-cidr-v6 = "fd00::/80";
  };

  virtualisation.containers.enable = true;
#  virtualisation = {
#    podman = {
#      enable = true;
#
#      # Create a `docker` alias for podman, to use it as a drop-in replacement
#      dockerCompat = true;
#
#      # Required for containers under podman-compose to be able to talk to each other.
#      defaultNetwork.settings.dns_enabled = true;
#    };
#  };

  fonts.fontDir.enable = true;

  gtk.iconCache.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.goxlr-utility.enable = true;

  services.tailscale.enable = true;

  programs = {
  gamescope = {
    enable = true;
    capSysNice = true;
  };
  steam = {
    gamescopeSession.enable = true;
  };
};
}
