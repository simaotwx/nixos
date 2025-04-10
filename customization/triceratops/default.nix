{ inputs, pkgs, lib, ... }: {
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc
    common-cpu-amd
    common-cpu-amd-pstate
    common-gpu-amd
    common-pc-ssd
    ./filesystems.nix
    ../../machines/x86_64
    ../../modules/components/linux-nitrous.nix
    ../../modules/components/zsh.nix
    ../../modules/components/via.nix
    ../../modules/components/gnome.nix
    ../../modules/components/steam.nix
  ];

  # Customization of modules
  customization = {
    hardware = {
      cpu.cores = 16;
      cpu.vendor = "amd";
      storage.hasNvme = true;
    };
    general = {
      hostName = "triceratops";
      timeZone = "Europe/Berlin";
      defaultLocale = "en_US.UTF-8";
      keymap = "de";
    };
    compat.enable = true;
    graphics =  {
      amd.enable = true;
      amd.overclocking.unlock = false;
    };
    kernel = {
      sysrq.enable = true;
    };
    security = {
      network.enable = true;
      hardware.enable = true;
      kernel.enable = true;
      fs.enable = true;
      userspace.enable = true;
    };
    services = {
      printing = true;
      scanning = true;
      networkDiscovery = true;
    };
    sound = {
      lowLatency = false;
    };
    peripherals = {
      via.enable = true;
    };
    shells.zsh.lite.enable = true;
    shell.simaosSuite.enable = true;
    desktop = {
      gnome = {
        extensions = with pkgs.gnomeExtensions; [
          vitals
          user-themes
          dash-to-dock
          clipboard-indicator
          caffeine
          transparent-top-bar-adjustable-transparency
          kernel-indicator
          window-is-ready-remover
          pip-on-top
          spotify-controls
        ];
      };
    };
    software.steam = {
      gamescope.enable = true;
      gamescope.session.enable = true;
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
      BROWSER = "zen-beta";
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
    "postman"
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

  # Support for Carolina Mech Fossil
  services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="4069", ATTRS{idProduct}=="0002", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  services.timesyncd.enable = true;

  virtualisation.vmVariant = import ./vm.nix;
}
