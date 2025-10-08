{
  inputs,
  flakePath,
  pkgs,
  foundrixModules,
  ...
}:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc
    framework-desktop-amd-ai-max-300-series
    foundrixModules.profiles.desktop-full
    ./filesystems.nix
    "${flakePath}/machines/x86_64"
    "${flakePath}/modules/hardware/generic/any/ahci.nix"
    "${flakePath}/modules/hardware/generic/any/cdrom.nix"
    "${flakePath}/modules/hardware/amd/gpu.nix"
    "${flakePath}/modules/components/bootloaders/systemd-boot.nix"
    "${flakePath}/modules/components/desktop-environments/gnome.nix"
    "${flakePath}/modules/components/networking/network-manager.nix"
    "${flakePath}/modules/components/zsh"
    "${flakePath}/modules/components/sound.nix"
    foundrixModules.config.compat
    "${flakePath}/modules/components/ollama.nix"
    "${flakePath}/modules/components/shell/utilities/git.nix"
  ];

  # Customization of modules
  customization = {
    hardware = {
      cpu.cores = 16;
      cpu.vendor = "amd";
      storage.hasNvme = true;
    };
    general = {
      hostName = "fwdesktop";
      timeZone = "Europe/Berlin";
      defaultLocale = "en_US.UTF-8";
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
    performance = {
      tuning.enable = true;
      oomd.enable = true;
    };
    nix.buildDirOnTmp = true;
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
    "en_GB.UTF-8/UTF-8"
    "de_DE.UTF-8/UTF-8"
  ];

  services.fwupd.enable = true;

  users.users.fwdesktop = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    uid = 1000;
    password = "framework";
    shell = pkgs.zsh;
  };

  users.groups.fwdesktop.gid = 1000;

  services.gvfs.enable = true;
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
      strace
      wget
      curl
    ];
    defaultPackages = [ ];
    variables = {
      EDITOR = "vim";
      VISUAL = "vim";
      PAGER = "less";
      BROWSER = "firefox";
    };
  };

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
      "crush" # irrecovably becomes free after a while
    ];

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null;
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 5353 22 2222 7236 7250 ];

  users.users."fwdesktop".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICM7/qrzpmP/mK592MQUjYvjyGNcyaUDTOKfnBWWULvE simao@simao-workbook"
  ];

  system.stateVersion = "25.05";
}
