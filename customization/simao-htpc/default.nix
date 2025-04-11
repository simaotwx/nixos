{ pkgs, inputs, config, modulesPath, ... }: {
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc
    common-pc-ssd
    hardkernel-odroid-h4
    ./filesystems.nix
    ./partitions.nix
    ./kodi-config.nix
    ./minimal.nix
    ./sysupdate.nix
    ../../machines/x86_64
    ../../modules/components/kodi.nix
  ];

  # Customization of modules
  customization = {
    hardware = {
      cpu.cores = 4;
      cpu.vendor = "intel";
      storage.hasNvme = true;
    };
    debug.enable = true;
    general = {
      hostName = "htpc";
      timeZone = "Europe/Berlin";
      defaultLocale = "en_US.UTF-8";
      keymap = "us";
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
      networkDiscovery = true;
    };
    partitions.systemDisk = "/dev/nvme0n1";
    kodi = {
      user = "htpc";
      widevine = true;
      plugins = with pkgs.kodiPackages; [
        jellycon youtube
      ];
    };
  };

  users.users.htpc = {
    isNormalUser = true;
    extraGroups = [ "wheel" "cdrom" ];
    password = "htpc";
    uid = 1000;
    shell = pkgs.bash;
  };
  users.users.root.password = "root";
  nix.settings.trusted-users = [ "htpc" ];

  users.groups.htpc.gid = 1000;
  users.allowNoPasswordLogin = true;
  users.mutableUsers = false;
  services.displayManager.autoLogin.user = config.customization.kodi.user;
  services.getty.autologinUser = config.services.displayManager.autoLogin.user;
  boot.initrd.systemd.enable = true;
  boot.tmp.cleanOnBoot = true;
  boot.initrd.systemd.emergencyAccess = true;
  boot.initrd.availableKernelModules = [
    "nvme" "xhci_pci" "ahci"
  ];

  services.timesyncd.enable = true;

  i18n.supportedLocales = [
    "C.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
    "en_GB.UTF-8/UTF-8"
    "de_DE.UTF-8/UTF-8"
  ];

  services.fwupd.enable = true;

  services.gvfs.enable = true;
  services.libinput.enable = true;
  programs.dconf.enable = true;

  security.sudo = {
    enable = true;
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts noto-fonts-emoji noto-fonts-cjk-sans
      liberation_ttf
      fira
      material-icons
      material-symbols
      roboto
      hasklig
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
      ripgrep
      exfatprogs
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

  services.dbus.enable = true;

  security.polkit.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "spotify"
    "widevine-cdm"
  ];

  systemd.network.wait-online.anyInterface = true;

  fonts.fontDir.enable = true;

  gtk.iconCache.enable = true;

  boot.uki.name = "htos";
  system.nixos.distroId = "htos";
  system.nixos.distroName = "Home Theater OS";
  system.image.version = "3";

  virtualisation.vmVariant = import ./vm.nix;
}