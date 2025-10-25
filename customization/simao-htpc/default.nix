{
  pkgs,
  inputs,
  config,
  flakePath,
  lib,
  compressorXz,
  maybeImport,
  foundrixModules,
  options,
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
    foundrixModules.hardware.gpu.intel
    foundrixModules.profiles.htpc
    "${flakePath}/modules/compressors/xz.nix"
    (maybeImport "${flakePath}/local/simao-htpc-secrets.nix")
  ];

  # Customization of modules
  customization = {
    hardware = {
      cpu.cores = 4;
      cpu.vendor = "intel";
      storage.hasNvme = true;
    };
    debug.enable = false;
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
    partitions.systemDisk = "/dev/nvme0n1";
    kodi = {
      settings.webserver.enable = true;
    };
  };

  nix.enable = false;

  boot.loader.timeout = 0;
  boot.extraModprobeConfig = ''
    options snd slots=snd-hda-intel
  '';
  boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_lqx;

  users.users.${config.foundrix.config.kodi-gbm.user} = {
    uid = 1000;
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

  users.groups.admin.gid = config.users.users.admin.uid;
  boot.initrd.systemd.emergencyAccess = true;
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
  ];

  foundrix.general.keymap = "us";
  foundrix.config.kodi-gbm = {
    user = "htpc";
    kodiData = "/kodi";
    plugins =
      kodiPkgs: with kodiPkgs; [
        jellycon
        (youtube.overrideAttrs (old: rec {
          name = "youtube-${version}";
          version = "7.3.0+beta.7";
          src = old.src.override {
            owner = "anxdpanic";
            repo = "plugin.video.youtube";
            rev = "v${version}";
            hash = "sha256-wbblWvxM9kq3rf4ptd+3VTDqwOG9dwB03rWbImvKuYA=";
          };
        }))
      ];
  };

  time.timeZone = "Europe/Berlin";

  i18n.supportedLocales = options.i18n.supportedLocales.default ++ [
    "en_GB.UTF-8/UTF-8"
    "de_DE.UTF-8/UTF-8"
  ];

  services.fwupd.enable = true;

  services.gvfs.enable = true;
  programs.dconf.enable = true;

  security.sudo = {
    enable = true;
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

  system.image.version = "33";
  system.image.id = "simao-htpc-htos";

  system.stateVersion = "25.05";
}
