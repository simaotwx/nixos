{ pkgs, lib, inputs, ... }: {
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc
    common-cpu-amd
    common-cpu-amd-pstate
    common-gpu-amd
    common-pc-ssd
    ./filesystems.nix
    ../../machines/x86_64
    ../../modules/components/linux-nitrous.nix
    ../../modules/components/hyprland.nix
    ../../modules/components/zsh.nix
    ../../modules/components/via.nix
    ../../modules/components/virtd.nix
    ../../modules/components/steam.nix
  ];

  # Customization of modules
  customization = {
    hardware = {
      cpu.cores = 12;
      cpu.vendor = "amd";
      storage.hasNvme = true;
    };
    general = {
      hostName = "aludepp";
      timeZone = "Europe/Berlin";
      defaultLocale = "en_US.UTF-8";
      keymap = "de";
    };
    compat.enable = true;
    graphics =  {
      amd.enable = true;
      amd.overclocking.unlock = true;
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
      lowLatency = true;
    };
    peripherals = {
      via.enable = true;
      # let's wait for 6.14 support to be merged
      # https://github.com/NixOS/nixpkgs/pull/384992
      #razer.enable = true;
    };
    shells.zsh.lite.enable = true;
    shell.simaosSuite.enable = true;
  };

  # Support for Crush 80 wireless
  services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="320f", ATTRS{idProduct}=="5088", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  security.pki.certificateFiles = [
    ../../local/certificates/at2.crt
  ];

  services.timesyncd.enable = true;
  customization = {
    desktop.hyprland.enable = true;
  };

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
    hashedPassword = "$y$j9T$dnI7w6vlAMDavd6yzhEZo/$zG.rUrydeU/An8SRDBs7IEHW9ygTuBL8GNJO.CGLMuB";
    shell = pkgs.zsh;
  };

  users.groups.simao.gid = 1000;

  services.gvfs.enable = true;
  programs.adb.enable = true;
  services.libinput.enable = true;
  programs.dconf.enable = true;

  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [
        {
          command = "/home/simao/gpu-gaming-tune.sh";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/home/simao/gpu-gp-tune.sh";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/home/simao/gpu-train-tune.sh";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/home/simao/gpu-low-tune.sh";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/home/simao/gpu-stock.sh";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/home/simao/gpu-lite-tune.sh";
          options = [ "NOPASSWD" ];
        }
      ];
      users = [ "simao" ];
      runAs = "root:root";
    }];
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
      podman-compose
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

  virtualisation.vmVariant = import ./vm.nix;
}