{ pkgs, inputs, config, flakePath, lib, ... }: {
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc
    common-pc-ssd
    hardkernel-odroid-h4
    ./filesystems.nix
    ./partitions.nix
    ./minimal.nix
    ./options.nix
    ./sysupdate.nix
    "${flakePath}/machines/x86_64"
    "${flakePath}/modules/components/kodi.nix"
    "${flakePath}/modules/components/networking/network-manager.nix"
    "${flakePath}/local/simao-htpc-secrets.nix"
  ];

  # Customization of modules
  customization = {
    hardware = {
      cpu.cores = 4;
      cpu.vendor = "intel";
      storage.hasNvme = true;
    };
    graphics = {
      intel.xe.enable = true;
    };
    # Sound will be configured by the Kodi module
    sound.enable = false;
    debug.enable = false;
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
    performance = {
      tuning.enable = true;
      oomd.enable = true;
    };
    kodi = {
      user = "htpc";
      kodiData = "/kodi";
      settings.webserver.enable = true;
      plugins = kodiPkgs: with kodiPkgs; [
        jellycon
        (youtube.overrideAttrs (old: rec {
          name = "youtube-${version}";
          version = "7.2.0.1";
          src = old.src.override {
            owner = "anxdpanic";
            repo = "plugin.video.youtube";
            rev = "v${version}";
            hash = "sha256-6CT/35jV1cmXPlJBKb7Sm8Hkurmybx163864vP20Ijw=";
          };
        }))
        (buildKodiAddon {
          pname = "htos-sysinfo-${config.system.image.version}";
          namespace = "script.htos.sysinfo";
          version = "1.0.${config.system.image.version}";
          src = "${flakePath}/src/kodi-htos-sysinfo";
        })
      ];
    };
  };

  boot.loader.timeout = 0;
  boot.extraModprobeConfig = ''
    options snd slots=snd-hda-intel
  '';
  boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_lqx;

  users.users.htpc = {
    isNormalUser = true;
    extraGroups = [ "cdrom" ];
    password = "htpc";
    uid = 1000;
    shell = pkgs.bash;
  };
  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    password = "admin";
    uid = 1001;
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK3LlSENwLSVob/uIKNoyjtSrffFs4lzNC9AMqxmEHSz simao@aludepp"
    ];
  };
  users.users.root.password = "root";
  nix.settings.trusted-users = [ "admin" ];

  users.groups.htpc.gid = config.users.users.htpc.uid;
  users.groups.admin.gid = config.users.users.admin.uid;
  users.allowNoPasswordLogin = true;
  users.mutableUsers = false;
  services.displayManager.autoLogin.user = config.customization.kodi.user;
  #services.getty.autologinUser = config.services.displayManager.autoLogin.user;
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
      adwaita-fonts
      material-icons
      material-symbols
      roboto
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Liberation Serif" ];
        sansSerif = [ "Adwaita Sans" "Noto" ];
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

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "spotify"
    "widevine-cdm"
  ];

  systemd.network.wait-online.anyInterface = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = [ "admin" ];
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
  };
  networking.firewall.allowedTCPPorts = [ 22 8081 ];

  hardware.enableRedistributableFirmware = true;

  boot.uki.name = "htos";
  system.nixos.distroId = "htos";
  system.nixos.distroName = "Home Theater OS";
  system.image.version = "22";

  virtualisation.vmVariant = import ./vm.nix;

  system.stateVersion = "25.05";
}