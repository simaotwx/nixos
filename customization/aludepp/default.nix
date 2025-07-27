{
  inputs,
  flakePath,
  lib,
  pkgs,
  ...
}:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc
    common-pc-ssd
    common-cpu-amd
    common-cpu-amd-pstate
    ./filesystems.nix
    "${flakePath}/machines/x86_64"
    "${flakePath}/modules/hardware/razer/peripherals.nix"
    "${flakePath}/modules/hardware/intel/gpu.nix"
    "${flakePath}/modules/components/alacritty.nix"
    "${flakePath}/modules/components/linux-nitrous.nix"
    "${flakePath}/modules/components/bootloaders/systemd-boot.nix"
    "${flakePath}/modules/components/desktop-environments/hyprland.nix"
    "${flakePath}/modules/components/networking/network-manager.nix"
    "${flakePath}/modules/components/zsh"
    "${flakePath}/modules/components/via.nix"
    "${flakePath}/modules/components/virtd.nix"
    "${flakePath}/modules/components/steam.nix"
    "${flakePath}/modules/components/mdraid.nix"
    "${flakePath}/modules/components/qml.nix"
    "${flakePath}/modules/components/docker.nix"
  ];

  # Customization of modules
  customization = {
    hardware = {
      cpu.cores = 16;
      cpu.vendor = "amd";
      storage.hasNvme = true;
      io.hasOpticalDrive = true;
      graphics.latestMesa = true;
    };
    general = {
      hostName = "aludepp";
      timeZone = "Europe/Berlin";
      defaultLocale = "en_US.UTF-8";
      keymap = "de-latin1";
    };
    compat.enable = true;
    graphics = {
      intel.rgbFix = true;
    };
    kernel = {
      sysrq.enable = true;
    };
    linux-nitrous.processorFamily = "znver3";
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
    shells.zsh.lite.enable = true;
    shell.simaosSuite.enable = true;
    desktop.hyprland =
      let
        getSinkIdByName =
          name:
          "wpctl status -n | grep -E '${name}' | grep -v 'Audio/Sink' | cut -d '.' -f1 | rev | cut -d ' ' -f1 | rev";
        wpctl = lib.getExe' pkgs.wireplumber "wpctl";
        wlCopy = lib.getExe' pkgs.wl-clipboard "wl-copy";
      in
      {
        browser = inputs.zen-browser.packages."${pkgs.system}".beta;
        execOnce = [
          "${lib.getExe pkgs.wpaperd} -d"
          "${lib.getExe pkgs.eww} daemon && ${lib.getExe pkgs.eww} open topbar"
          "${lib.getExe pkgs.gopass} sync"
        ];
        additionalBind = [
          ''$mainMod SHIFT, S, exec, ${wpctl} set-default $(${getSinkIdByName "alsa_output.usb-Yamaha_Corporation_Steinberg_IXO12-00.analog-stereo"}) && hyprctl notify -1 1000 "rgb(1E88E5)" 'Switched to speakers' ''
          ''$mainMod, P, exec, ${lib.getExe pkgs.gopass} list --flat | $menu --dmenu -p "Search passwords…" -M multi-contains -i -O alphabetical | xargs ${lib.getExe pkgs.gopass} show -o -u --nosync | ${wlCopy}''
        ];
        additionalBinde = [
          ''$mainMod SHIFT, right, exec, hyprctl dispatch movecursor $(($(hyprctl cursorpos | cut -d ',' -f1)+10)) $(hyprctl cursorpos | cut -d ',' -f2 | cut -c2-)''
          ''$mainMod SHIFT, left, exec, hyprctl dispatch movecursor $(($(hyprctl cursorpos | cut -d ',' -f1)-10)) $(hyprctl cursorpos | cut -d ',' -f2 | cut -c2-)''
          ''$mainMod SHIFT, down, exec, hyprctl dispatch movecursor $(hyprctl cursorpos | cut -d ',' -f1) $(($(hyprctl cursorpos | cut -d ',' -f2 | cut -c2-)+10))''
          ''$mainMod SHIFT, up, exec, hyprctl dispatch movecursor $(hyprctl cursorpos | cut -d ',' -f1) $(($(hyprctl cursorpos | cut -d ',' -f2 | cut -c2-)-10))''
          ''$mainMod+ALT SHIFT, right, exec, hyprctl dispatch movecursor $(($(hyprctl cursorpos | cut -d ',' -f1)+1)) $(hyprctl cursorpos | cut -d ',' -f2 | cut -c2-)''
          ''$mainMod+ALT SHIFT, left, exec, hyprctl dispatch movecursor $(($(hyprctl cursorpos | cut -d ',' -f1)-1)) $(hyprctl cursorpos | cut -d ',' -f2 | cut -c2-)''
          ''$mainMod+ALT SHIFT, down, exec, hyprctl dispatch movecursor $(hyprctl cursorpos | cut -d ',' -f1) $(($(hyprctl cursorpos | cut -d ',' -f2 | cut -c2-)+1))''
          ''$mainMod+ALT SHIFT, up, exec, hyprctl dispatch movecursor $(hyprctl cursorpos | cut -d ',' -f1) $(($(hyprctl cursorpos | cut -d ',' -f2 | cut -c2-)-1))''
        ];
      };
  };

  hardware.cpu.amd.ryzen-smu.enable = true;

  # Support for Crush 80 wireless
  services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="320f", ATTRS{idProduct}=="5088", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  security.pki.certificateFiles = [
    "${flakePath}/local/certificates/at2.crt"
  ];

  services.timesyncd.enable = true;

  i18n.supportedLocales = [
    "C.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
    "en_GB.UTF-8/UTF-8"
    "de_DE.UTF-8/UTF-8"
  ];

  services.fwupd.enable = true;

  users.users.simao = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    uid = 1000;
    hashedPassword = "$y$j9T$dnI7w6vlAMDavd6yzhEZo/$zG.rUrydeU/An8SRDBs7IEHW9ygTuBL8GNJO.CGLMuB";
    shell = pkgs.zsh;
  };

  users.groups.simao.gid = 1000;

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
    ];

  virtualisation.vmVariant = import ./vm.nix;

  system.stateVersion = "25.05";
}
