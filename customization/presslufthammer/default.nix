{
  pkgs,
  inputs,
  flakePath,
  ...
}:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc
    common-cpu-intel
    common-pc-ssd
    framework-12th-gen-intel
    ./filesystems.nix
    "${flakePath}/machines/x86_64"
    "${flakePath}/modules/hardware/generic/any/ahci.nix"
    "${flakePath}/modules/hardware/intel/gpu.nix"
    "${flakePath}/modules/components/displaylink.nix"
    #"${flakePath}/modules/components/linux-nitrous.nix"
    "${flakePath}/modules/components/bootloaders/systemd-boot.nix"
    "${flakePath}/modules/components/networking/network-manager.nix"
    "${flakePath}/modules/components/desktop-environments/gnome.nix"
    "${flakePath}/modules/components/zsh"
    "${flakePath}/modules/components/virtd.nix"
    "${flakePath}/modules/components/qml.nix"
    "${flakePath}/modules/components/docker.nix"
    "${flakePath}/modules/components/sound.nix"
    "${flakePath}/modules/components/shell/utilities/git.nix"
  ];

  # Customization of modules
  customization = {
    hardware = {
      cpu.cores = 8;
      cpu.vendor = "intel";
      storage.hasNvme = true;
    };
    general = {
      hostName = "presslufthammer";
      timeZone = "Europe/Berlin";
      defaultLocale = "en_US.UTF-8";
      keymap = "de-latin1";
    };
    compat.enable = true;
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
    performance = {
      tuning.enable = true;
      oomd.enable = true;
    };
    shells.zsh.power10k.enable = true;
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
    "en_GB.UTF-8/UTF-8"
    "de_DE.UTF-8/UTF-8"
  ];

  services.fwupd.enable = true;

  users.users.julian = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    uid = 1000;
    hashedPassword = "$y$j9T$F9ZLmSJrJLk33B1ui9mAf0$Qx5Zq6BzpXPLFWU9HIv0e5Oy6E0cmeucN/gTyuv4Bf7";
    shell = pkgs.zsh;
  };

  users.groups.julian.gid = 1000;

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
      intel-vaapi-driver
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
    ];

  hardware.enableRedistributableFirmware = true;

  services.tailscale.enable = true;

  security.pki.certificateFiles = [
    "${flakePath}/local/certificates/thea_root_ca.crt"
  ];

  virtualisation.vmVariant = import ./vm.nix;

  system.stateVersion = "25.05";
}
