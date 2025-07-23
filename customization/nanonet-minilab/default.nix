{ pkgs, inputs, config, flakePath, ... }: {
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
    "${flakePath}/modules/hardware/intel/gpu.nix"
    "${flakePath}/modules/components/networking/systemd-networkd.nix"
    "${flakePath}/modules/components/jellyfin.nix"
    "${flakePath}/local/nanonet-minilab-secrets.nix"
  ];

  # Customization of modules
  customization = {
    hardware = {
      cpu.cores = 4;
      cpu.vendor = "intel";
      storage.hasNvme = true;
    };
    # Sound not needed
    sound.enable = false;
    debug.enable = false;
    general = {
      hostName = "nanonet-minilab";
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
  };

  boot.loader.timeout = 0;
  boot.extraModprobeConfig = ''
    options snd slots=snd-hda-intel
  '';

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
  nix.settings.trusted-users = [ "admin" ];

  users.groups.admin.gid = config.users.users.admin.uid;
  users.allowNoPasswordLogin = true;
  users.mutableUsers = false;
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
  programs.dconf.enable = true;

  security.sudo = {
    enable = true;
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts noto-fonts-emoji noto-fonts-cjk-sans
      liberation_ttf
      adwaita-fonts
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

  systemd.network.wait-online.anyInterface = true;

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
  networking.firewall.allowedTCPPorts = [ 22 ];

  hardware.enableRedistributableFirmware = true;

  systemd.network.networks."10-wan" = {
    matchConfig.Type = "ether";
    networkConfig = {
      DHCP = "ipv4";
      IPv6AcceptRA = true;
    };
    linkConfig.RequiredForOnline = "routable";
  };

  services.caddy = rec {
    enable = true;
    globalConfig = ''
      email ${config.customization.nanonet-minilab.acmeEmail or ""}
    '';
    extraConfig = ''
      (common_tls) {
        tls {
          dns cloudflare "${config.customization.nanonet-minilab.cfApiToken or ""}"
        }
      }
    '';
    virtualHosts = {
      "jelly.nanonet.rx7.link" = {
        extraConfig = ''
          import common_tls
          reverse_proxy localhost:8096
        '';
      };
      "jelly-ts.nanonet.rx7.link, jelly-ts-ipv4.nanonet.nanonet.rx7.link" =
        virtualHosts."jelly.nanonet.rx7.link";
    };
  };

  boot.uki.name = "nnmos";
  system.nixos.distroId = "nnmos";
  system.nixos.distroName = "nanonet minilab OS";
  system.image.version = "1";
  system.image.id = "nanonet-minilab-os";

  virtualisation.vmVariant = import ./vm.nix;

  system.stateVersion = "25.05";
}