{
  inputs,
  flakePath,
  pkgs,
  foundrixModules,
  options,
  lib,
  ...
}:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc
    framework-desktop-amd-ai-max-300-series
    foundrixModules.profiles.desktop-full
    ./filesystems.nix
    foundrixModules.hardware.platform.x86_64
    foundrixModules.hardware.gpu.amd
    foundrixModules.config.oomd
    "${flakePath}/modules/components/networking/network-manager.nix"
    "${flakePath}/modules/components/zsh"
    "${flakePath}/modules/components/docker.nix"
    foundrixModules.config.compat
    foundrixModules.components.ollama
    foundrixModules.components.llama-cpp
    "${flakePath}/modules/components/vllm.nix"
    ./chat-ui-deployment.nix
  ];

  # Customization of modules
  customization = {
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
    nix.buildDirOnTmp = true;
    shells.zsh.lite.enable = true;
    virtualisation.docker.autostart = true;
  };

  boot.tmp.useTmpfs = false;
  systemd.mounts = [
    {
      what = "tmpfs";
      where = "/tmp";
      type = "tmpfs";
      mountConfig.Options = lib.concatStringsSep "," [
        "mode=1755"
        "noatime"
        "rw"
        "nosuid"
        "nodev"
        "size=80%"
        "huge=within_size"
      ];
    }
  ];

  foundrix.general.keymap = "de-latin1";
  foundrix.hardware.gpu.amd.gpuTargets = [
    "gfx1151"
  ];

  networking.hostName = "fwdesktop";

  time.timeZone = "Europe/Berlin";

  services.timesyncd.enable = true;

  i18n.supportedLocales = options.i18n.supportedLocales.default ++ [
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

  nix.settings.build-dir = lib.mkForce "/nix/tmp";

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
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDf1dw5ZW8Bz26VfoBdLeIKyscBV2u1gjCj7J9w3WgsHAfmrTou33esnw8dyhd97jPsaAPlkyIChwJUUPNtGwv3Qb26hvehej1OtSbPJd8uRF6W3oCJFl0/CJ44mB5PDoUHq9xojK5TEQdBvbK4Pf1E7grd3K0jJDRruZ1cA9MMpymPyohNR/eucr4Q6xDlpQvb9+2G81dRB7vlLsofvqf1hOHJ1Klscmk6smqi40gJ35xchG0kxCdE+8Fadin9ywVB0D9UkLWB+tHcWQcEP8fugSHTPnzkUwsA0Qfppcf3GzdLcdXjY4fdQ2psBiQLRujK289m6GxYwjkjSzSOSWGGA+8/zSUOuQd6FZg1AM9YNQdaZ1F02f+zJ4P5GcEqmQI4LL9EcYzhkyzsKiLXHRUpet1aTj/VyAKR24C1RIjyGj1QHzwJBznD5R2110x+sHorOyg4AmxLCqxeO/DKPuwC4Oe0J1FNvO0QMG4yVeDCc4ih7/ULD9RS10HoVFqrq10="
  ];

  system.stateVersion = "25.05";
}
