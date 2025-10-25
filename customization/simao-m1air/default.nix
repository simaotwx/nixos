{
  pkgs,
  lib,
  inputs,
  flakePath,
  foundrixModules,
  options,
  ...
}:
{
  imports = [
    inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
    foundrixModules.profiles.desktop-full
    foundrixModules.hardware.platform.arm64
    ./filesystems.nix
    "${flakePath}/modules/hardware/apple/asahi.nix"
    "${flakePath}/modules/components/desktop-environments/gnome.nix"
    "${flakePath}/modules/components/zsh"
    "${flakePath}/modules/components/virtd.nix"
    "${flakePath}/modules/components/docker.nix"
    foundrixModules.config.lowmem
  ];

  nixpkgs.overlays = [
    inputs.nixos-apple-silicon.overlays.apple-silicon-overlay
  ];

  hardware.asahi =
    let
      asahiFiles = flakePath + "/local/asahi";
    in
    {
      peripheralFirmwareDirectory = lib.mkIf (lib.filesystem.pathIsDirectory asahiFiles) asahiFiles;
    };

  # Customization of modules
  customization = {
    hardware = {
      cpu.cores = 8;
      cpu.vendor = "apple";
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

  # Support for Crush 80 wireless
  services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="320f", ATTRS{idProduct}=="5088", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  foundrix.general.keymap = "us";

  networking.hostName = "simao-m1air";

  time.timeZone = "Europe/Berlin";

  i18n.supportedLocales = options.i18n.supportedLocales.default ++ [
    "en_GB.UTF-8/UTF-8"
    "de_DE.UTF-8/UTF-8"
  ];

  users.users.simao = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    uid = 1000;
    hashedPassword = "$y$j9T$dnI7w6vlAMDavd6yzhEZo/$zG.rUrydeU/An8SRDBs7IEHW9ygTuBL8GNJO.CGLMuB";
    shell = pkgs.zsh;
  };

  users.groups.simao.gid = 1000;

  programs.adb.enable = true;

  services.printing.enable = true;
  hardware.sane.enable = true;

  security.sudo = {
    enable = true;
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.hasklug
      fira
      adwaita-fonts
      material-icons
      material-symbols
      roboto
      hasklig
      iosevka
      iosevka-comfy.comfy
    ];
    fontconfig.defaultFonts = {
      sansSerif = [
        "Adwaita Sans"
        "Noto"
      ];
      monospace = [ "Adwaita Mono" ];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      vim
      dust
      duperemove
      ripgrep
      kdePackages.polkit-kde-agent-1
      exfatprogs
      nix-bundle
      podman-compose
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
      BROWSER = "zen-beta";
    };
  };

  services.udev.packages = with pkgs; [
    android-udev-rules
  ];

  security.pki.certificateFiles = [
    "${flakePath}/local/certificates/at2.crt"
  ];

  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];

  services.logind = {
    extraConfig = "HandlePowerKey=suspend";
    lidSwitch = "suspend";
  };

  services.bpftune.enable = lib.mkForce false;

  console.font = lib.mkForce "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";

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
    ];

  system.stateVersion = "25.05";
}
