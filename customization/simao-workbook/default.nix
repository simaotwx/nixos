{ config, pkgs, lib, inputs, modulesPath, ... }: {
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc
    common-cpu-amd
    common-cpu-amd-pstate
    common-gpu-amd
    common-pc-ssd
    framework-16-7040-amd
    "${modulesPath}/hardware/video/displaylink.nix"
    ./filesystems.nix
    ../../machines/x86_64
    #../../modules/components/linux-nitrous.nix
    ../../modules/components/gnome.nix
    ../../modules/components/zsh.nix
    ../../modules/components/virtd.nix
  ];

  # Customization of modules
  customization = {
    hardware = {
      cpu.cores = 8;
      cpu.vendor = "amd";
      storage.hasNvme = true;
    };
    general = {
      hostName = "simao-workbook";
      timeZone = "Europe/Berlin";
      defaultLocale = "en_US.UTF-8";
      keymap = "de";
    };
    compat.enable = true;
    graphics =  {
      amd.enable = true;
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
    shells.zsh.lite.enable = true;
    shell.simaosSuite.enable = true;
    desktop = {
      gnome = {
        extensions = with pkgs.gnomeExtensions; [
          vitals
          user-themes
          dock-from-dash
          clipboard-indicator
          caffeine
          transparent-top-bar-adjustable-transparency
          window-is-ready-remover
          bluetooth-quick-connect
          removable-drive-menu
          tray-icons-reloaded
        ];
      };
    };
  };

  services.timesyncd.enable = true;

  i18n.supportedLocales = [
    "C.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
    "en_GB.UTF-8/UTF-8"
    "de_DE.UTF-8/UTF-8"
  ];

  services.fwupd.enable = true;

  users.users.simao = {
    isNormalUser = true;
    extraGroups = [ "wheel" "cdrom" ];
    uid = 1000;
    hashedPassword = "$y$j9T$GRciktyLKmG/y3X1jnnr6/$iFX.kKnW51yzKToh0AdI0KgKLDftWOivZl35A9MXORD";
    shell = pkgs.zsh;
  };

  users.groups.simao.gid = 1000;

  services.gvfs.enable = true;
  programs.adb.enable = true;
  services.libinput.enable = true;
  programs.dconf.enable = true;

  security.sudo = {
    enable = true;
  };

  services.fprintd.enable = true;
  boot.extraModulePackages = with config.boot.kernelPackages; [ evdi ];
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
      exfatprogs
      nix-bundle
      displaylink
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

  security.polkit.enable = true;

  services.clamav = {
    updater.enable = true;
    fangfrisch.enable = true;
    daemon.enable = true;
    updater.interval = "*-*-* 00/4:00:00";
    fangfrisch.interval = "*-*-* 00/4:00:00";
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "spotify"
    "android-studio-stable"
    "idea-ultimate"
    "phpstorm"
    "goland"
    "pycharm-professional"
    "libfprint-2-tod1-goodix"
    "displaylink"
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

  nixpkgs.overlays = [
  (final: prev: {
    linuxPackages_latest =
      prev.linuxPackages_latest.extend
        (lpfinal: lpprev: {
          evdi =
            lpprev.evdi.overrideAttrs (efinal: eprev: {
              version = "1.14.9-git";
              src = prev.fetchFromGitHub {
                owner = "DisplayLink";
                repo = "evdi";
                rev = "26e2fc66da169856b92607cb4cc5ff131319a324";
                sha256 = "sha256-Y8ScgMgYp1osK+rWZjZgG359Uc+0GP2ciL4LCnMVJJ8=";
              };
            });
        });
    displaylink = prev.displaylink.override {
      inherit (final.linuxPackages_latest) evdi;
    };
  })];
  services.xserver.videoDrivers = [ "displaylink" "modesetting" ];
  virtualisation.vmVariant = import ./vm.nix;
}
