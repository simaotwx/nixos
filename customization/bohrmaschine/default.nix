{
  pkgs,
  inputs,
  flakePath,
  foundrixModules,
  ...
}:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc
    common-cpu-amd
    common-cpu-amd-pstate
    common-gpu-amd
    common-pc-ssd
    framework-16-7040-amd
    foundrixModules.profiles.desktop-full
    ./filesystems.nix
    foundrixModules.hardware.gpu.amd
    foundrixModules.hardware.platform.x86_64
    #"${flakePath}/modules/components/displaylink.nix"
    "${flakePath}/modules/components/bootloaders/systemd-boot.nix"
    "${flakePath}/modules/components/desktop-environments/gnome.nix"
    "${flakePath}/modules/components/networking/network-manager.nix"
    "${flakePath}/modules/components/zsh"
    "${flakePath}/modules/components/virtd.nix"
    "${flakePath}/modules/components/docker.nix"
    "${flakePath}/modules/components/sound.nix"
    foundrixModules.config.compat
    foundrixModules.config.oomd
  ];

  # Customization of modules
  customization = {
    hardware = {
      cpu.cores = 8;
      cpu.vendor = "amd";
      storage.hasNvme = true;
    };
    general = {
      hostName = "bohrmaschine";
      timeZone = "Europe/Berlin";
      defaultLocale = "de_DE.UTF-8";
      keymap = "de-latin1";
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
    desktop = {
      gnome = {
        extensions = with pkgs.gnomeExtensions; [
          vitals
          dash-to-dock
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
    "de_DE.UTF-8/UTF-8"
  ];

  services.bpftune.enable = true;

  services.fwupd.enable = true;

  users.users.kehoeld = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    uid = 1000;
    hashedPassword = "$y$j9T$g7AdW0GW7SrtXue2hfvuf1$EKvHJVhC91jx0ZUi5POJkPjF5SF8OBMIWIu0k.SdHT0";
    shell = pkgs.zsh;
  };

  users.groups.kehoeld.gid = 1000;

  services.gvfs.enable = true;
  programs.adb.enable = true;
  programs.dconf.enable = true;

  security.sudo = {
    enable = true;
  };

  services.fprintd.enable = true;
  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.hasklug
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk-sans
      liberation_ttf
      fira
      adwaita-fonts
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
        sansSerif = [
          "Adwaita Sans"
          "Noto"
        ];
        monospace = [ "Adwaita Mono" ];
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
      vim
      dust
      duperemove
      ripgrep
      exfatprogs
      nix-bundle
      gparted
      usbutils
    ];
    defaultPackages = [ ];
    variables = {
      EDITOR = "vim";
      VISUAL = "vim";
      PAGER = "less";
      BROWSER = "firefox";
    };
  };

  services.udev.packages = with pkgs; [
    android-udev-rules
  ];

  services.clamav = {
    updater.enable = true;
    fangfrisch.enable = true;
    daemon.enable = true;
    updater.interval = "*-*-* 00/4:00:00";
    fangfrisch.interval = "*-*-* 00/4:00:00";
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "spotify"
      "android-studio-stable"
      "idea-ultimate"
      "phpstorm"
      "goland"
      "pycharm-professional"
      "libfprint-2-tod1-goodix"
      "displaylink"
      "citrix-workspace"
      "google-chrome"
    ];

  services.tailscale.enable = true;

  # Support for framework keyboard backlight
  services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0018", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  virtualisation.vmVariant = import ./vm.nix;

  system.stateVersion = "25.05";
}
