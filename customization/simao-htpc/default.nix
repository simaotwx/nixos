{
  pkgs,
  inputs,
  config,
  flakePath,
  lib,
  compressorXz,
  maybeImport,
  foundrixModules,
  ...
}:
{
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
    foundrixModules.hardware.gpu.intel
    "${flakePath}/modules/components/kodi.nix"
    "${flakePath}/modules/compressors/xz.nix"
    "${flakePath}/modules/components/bootloaders/systemd-boot.nix"
    "${flakePath}/modules/components/networking/network-manager.nix"
    (maybeImport "${flakePath}/local/simao-htpc-secrets.nix")
    foundrixModules.config.oomd
  ];

  # Customization of modules
  customization = {
    hardware = {
      cpu.cores = 4;
      cpu.vendor = "intel";
      storage.hasNvme = true;
    };
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
        kodi = {
      user = "htpc";
      kodiData = "/kodi";
      settings.webserver.enable = true;
      plugins =
        kodiPkgs: with kodiPkgs; [
          jellycon
          (youtube.overrideAttrs (old: rec {
            name = "youtube-${version}";
            version = "7.3.0+beta.3";
            src = old.src.override {
              owner = "anxdpanic";
              repo = "plugin.video.youtube";
              rev = "v${version}";
              hash = "sha256-aSXG7YxbRcKIEWmES2s1HBcfZnUbzdWBfB6fRCgNv/k=";
            };
          }))
        ];
    };
  };

  # Enable bpftune for performance tuning
  services.bpftune.enable = true;

  nix.enable = false;

  boot.loader.timeout = 0;
  boot.extraModprobeConfig = ''
    options snd slots=snd-hda-intel
  '';
  boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_lqx;

  users.users.htpc = {
    isNormalUser = true;
    extraGroups = [ ];
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
    "nvme"
    "xhci_pci"
    "ahci"
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
  programs.dconf.enable = true;

  security.sudo = {
    enable = true;
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk-sans
      liberation_ttf
      adwaita-fonts
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
      ripgrep
      exfatprogs
    ];
    defaultPackages = [ ];
    variables = {
      EDITOR = "vim";
      VISUAL = "vim";
      PAGER = "less";
    };
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
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
  networking.firewall.allowedTCPPorts = [
    22
    8081
    9090
  ];

  hardware.enableRedistributableFirmware = true;

  system.build.ota.artifacts =
    let
      ukiFile = "${config.system.build.uki}/${config.system.boot.loader.ukiFile}";
      storeFile = "${config.system.build.image}/${config.boot.uki.name}_${config.system.image.version}.store.raw";
      ukiOutName = config.system.boot.loader.ukiFile;
      storeOutName = "store_${config.system.image.version}.img";
    in
    {
      ${ukiOutName} = {
        source = ukiFile;
        compressor = compressorXz;
        compressedExtension = "xz";
      };
      ${storeOutName} = {
        source = storeFile;
        compressor = compressorXz;
        compressedExtension = "xz";
      };
    };

  boot.uki.name = "htos";
  system.nixos.distroId = "htos";
  system.nixos.distroName = "Home Theater OS";
  system.image.version = "31";
  system.image.id = "simao-htpc-htos";

  virtualisation.vmVariant = import ./vm.nix;

  system.stateVersion = "25.05";
}
