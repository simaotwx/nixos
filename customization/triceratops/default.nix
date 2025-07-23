{
  inputs,
  pkgs,
  flakePath,
  ...
}:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc
    common-cpu-amd
    common-cpu-amd-pstate
    common-gpu-amd
    common-pc-ssd
    ./filesystems.nix
    ./tpm.nix
    "${flakePath}/machines/x86_64"
    "${flakePath}/modules/hardware/amd/gpu.nix"
    "${flakePath}/modules/components/linux-nitrous.nix"
    "${flakePath}/modules/components/networking/network-manager.nix"
    "${flakePath}/modules/components/zsh"
    "${flakePath}/modules/components/via.nix"
    "${flakePath}/modules/components/desktop-environments/gnome.nix"
    "${flakePath}/modules/components/steam.nix"
    "${flakePath}/modules/components/zram.nix"
    "${flakePath}/modules/components/docker.nix"
  ];

  # Customization of modules
  customization = {
    hardware = {
      cpu.cores = 16;
      cpu.vendor = "amd";
      storage.hasNvme = true;
      graphics.latestMesa = true;
    };
    general = {
      hostName = "triceratops";
      timeZone = "Europe/Berlin";
      defaultLocale = "en_US.UTF-8";
      keymap = "de-latin1";
    };
    compat.enable = true;
    kernel = {
      sysrq.enable = true;
    };
    linux-nitrous.processorFamily = "znver4";
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
    peripherals = {
      via.enable = true;
    };

    shells.zsh.power10k = {
      enable = true;
      colors = {
        osIconBackground = "#34ABB1";
        hostBackground = "#348AB1";
        userBackground = "#296A87";
        dirBackground = "#7D74E9";
        dirAnchorBackground = "#6A62C6";
        osIconForeground = "#0f0f0f";
        hostForeground = "#0f0f0f";
        userForeground = "#0f0f0f";
        dirForeground = "#0f0f0f";
        dirAnchorForeground = "#0f0f0f";
      };
    };

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
    extraGroups = [ "wheel" ];
    uid = 1000;
    hashedPassword = "$y$j9T$MXSMjuO2SULmBg9oXnbNB/$FnU.BdkloQ4eFdBkLdXMT6F7vM6zXN4QWuzcjgH..s1";
    shell = pkgs.zsh;
  };

  users.groups.noah.gid = 1000;

  services.gvfs.enable = true;
  programs.adb.enable = true;
  programs.dconf.enable = true;

  security.sudo = {
    enable = true;
  };

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
    ];
    defaultPackages = [ ];
    variables = {
      EDITOR = "vim";
      VISUAL = "vim";
      PAGER = "less";
      BROWSER = "zen-beta";
    };
  };

  services.udev.packages = with pkgs; [
    android-udev-rules
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "discord"
      "spotify"
      "steam"
      "steam-original"
      "steam-run"
      "steam-unwrapped"
      "makemkv"
      "android-studio-stable"
      "postman"
      "teamviewer"
      "discord-ptb"
    ];

  services.goxlr-utility.enable = true;

  services.tailscale.enable = true;

  services.openssh.enable = true;

  services.teamviewer.enable = true;
  # Use this to prevent teamviewerd from starting on system boot
  #systemd.services.teamviewerd.wantedBy = lib.mkForce [];
  #systemd.services.teamviewerd.serviceConfig.Restart = lib.mkForce "no";

  networking.interfaces.eno2.wakeOnLan.enable = true;

  hardware.cpu.amd.ryzen-smu.enable = true;

  # Support for Carolina Mech Fossil
  services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="4069", ATTRS{idProduct}=="0002", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  services.timesyncd.enable = true;

  virtualisation.vmVariant = import ./vm.nix;

  system.stateVersion = "25.05";
}
