{
  inputs,
  pkgs,
  flakePath,
  foundrixModules,
  options,
  ...
}:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc
    common-cpu-amd
    common-cpu-amd-pstate
    common-gpu-amd
    common-pc-ssd
    foundrixModules.profiles.desktop-full
    ./filesystems.nix
    ./tpm.nix
    foundrixModules.hardware.gpu.amd
    foundrixModules.hardware.platform.x86_64
    "${flakePath}/modules/components/networking/network-manager.nix"
    "${flakePath}/modules/components/zsh"
    foundrixModules.config.via
    "${flakePath}/modules/components/desktop-environments/gnome.nix"
    "${flakePath}/modules/components/steam.nix"
    "${flakePath}/modules/components/zram.nix"
    "${flakePath}/modules/components/docker.nix"
    "${flakePath}/modules/components/sound.nix"
    foundrixModules.config.compat
    foundrixModules.config.oomd
    inputs.linux-nitrous.outPath
  ];

  # Customization of modules
  customization = {
    nix.buildDirOnTmp = true;
    hardware = {
      cpu.cores = 16;
      cpu.vendor = "amd";
      storage.hasNvme = true;
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

  linux-nitrous.processorFamily = "znver4";

  i18n.supportedLocales = options.i18n.supportedLocales.default ++ [
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
      nodejs
      openrgb-with-all-plugins
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

  services.bpftune.enable = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  boot.initrd.kernelModules = [ "msr" ];

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

  networking.interfaces.enp10s0.wakeOnLan.enable = true;

  #hardware.cpu.amd.ryzen-smu.enable = true;
  hardware.i2c.enable = true;

  # Support for Carolina Mech Fossil and Lemokey L5 HE 8k
  services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="4069", ATTRS{idProduct}=="0002", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"

    KERNEL=="hidraw*", ATTRS{idVendor}=="362d", ATTRS{idProduct}=="0551", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  foundrix.general.keymap = "de-latin1";

  networking.hostName = "triceratops";

  time.timeZone = "Europe/Berlin";

  services.timesyncd.enable = true;

  virtualisation.vmVariant = import ./vm.nix;

  system.stateVersion = "25.05";
}
