{
  pkgs,
  inputs,
  flakePath,
  lib,
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
    framework-16-7040-amd
    foundrixModules.profiles.desktop-full
    ./filesystems.nix
    foundrixModules.hardware.gpu.amd
    "${flakePath}/modules/components/displaylink.nix"
    "${flakePath}/modules/components/desktop-environments/gnome.nix"
    "${flakePath}/modules/components/zsh"
    "${flakePath}/modules/components/virtd.nix"
    "${flakePath}/modules/components/docker.nix"
    foundrixModules.components.ollama
    foundrixModules.components.llama-cpp
    "${flakePath}/modules/components/crush.nix"
    ../fwdesktop/chat-ui-deployment.nix
  ];

  # Customization of modules
  customization = {
    hardware = {
      cpu.cores = 8;
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

  services.tailscale.enable = true;
  systemd.services.tailscaled.wantedBy = lib.mkForce [ ];

  foundrix.general.keymap = "de-latin1";
  foundrix.hardware.gpu.amd.gpuTargets = [
    "gfx1100"
    "gfx1101"
    "gfx1102"
  ];

  networking.hostName = "simao-workbook";

  time.timeZone = "Europe/Berlin";

  services.timesyncd.enable = true;

  i18n.supportedLocales = options.i18n.supportedLocales.default ++ [
    "en_GB.UTF-8/UTF-8"
    "de_DE.UTF-8/UTF-8"
  ];

  services.fwupd.enable = true;

  users.users.simao = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    uid = 1000;
    hashedPassword = "$y$j9T$GRciktyLKmG/y3X1jnnr6/$iFX.kKnW51yzKToh0AdI0KgKLDftWOivZl35A9MXORD";
    shell = pkgs.zsh;
  };

  users.groups.simao.gid = 1000;

  services.gvfs.enable = true;
  programs.adb.enable = true;
  programs.dconf.enable = true;

  security.sudo = {
    enable = true;
  };

  services.fprintd.enable = true;
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
      pop-wallpapers
      (pkgs.writeShellScriptBin "dhcp-setup" ''
        set -e

        IFACE="$1"
        CIDR="$2"

        if [ -z "$IFACE" ] || [ -z "$CIDR" ]; then
          echo "Usage: $0 <interface> <cidr>"
          exit 1
        fi

        # Parse CIDR to extract network for DHCP range calculation
        NETWORK=$(echo "$CIDR" | cut -d'/' -f1)
        BASE_NETWORK=$(echo "$NETWORK" | cut -d'.' -f1-3)

        # DHCP range: .50 to .150 in the subnet
        DHCP_START="$BASE_NETWORK.50"
        DHCP_END="$BASE_NETWORK.150"

        # Gateway will be .1 in the subnet
        GATEWAY="$BASE_NETWORK.1"

        # Disconnect the interface first
        ${lib.getExe' pkgs.networkmanager "nmcli"} dev disconnect "$IFACE" || :

        # Add IP address to interface
        ${lib.getExe' pkgs.iproute2 "ip"} addr add "$CIDR" dev "$IFACE"

        # Bring interface up
        ${lib.getExe' pkgs.iproute2 "ip"} link set "$IFACE" up

        nixos-firewall-tool open udp 67
        nixos-firewall-tool open udp 68

        # Start dnsmasq with DHCP
        ${lib.getExe pkgs.dnsmasq} -d -i "$IFACE" --bind-interfaces --except-interface=lo --port=0 --listen-address="$GATEWAY" --dhcp-range="$DHCP_START,$DHCP_END,12h"        '')
    ];
    defaultPackages = [ ];
    variables = {
      EDITOR = "vim";
      VISUAL = "vim";
      PAGER = "less";
      BROWSER = "firefox";
    };
    pathsToLink = [
      "/share/backgrounds"
      "/share/gnome-background-properties"
    ];
  };

  services.bpftune.enable = true;

  nixpkgs.overlays = [
    (final: prev: {
      pop-wallpapers = prev.pop-wallpapers.overrideAttrs (
        finalAttrs: prevAttrs: {
          fixupPhase = ''
            sed -i -re 's/\/usr/\/run\/current-system\/sw/g' $out/share/gnome-background-properties/pop-wallpapers.xml
          '';
        }
      );
    })
  ];

  services.udev.packages = with pkgs; [
    android-udev-rules
  ];

  security.pki.certificateFiles =
    builtins.concatMap (filePath: lib.optional (builtins.pathExists filePath) filePath)
      [
        "${flakePath}/local/certificates/thea_root_ca.crt"
        "${flakePath}/local/certificates/ordf_root_ca.crt"
      ];

  boot.tmp.tmpfsSize = "75%";

  services.printing.enable = true;
  hardware.sane.enable = true;
  services.printing.drivers = [
    pkgs.brlaser
    pkgs.mfc9332cdwcupswrapper
  ];
  networking.firewall.allowedTCPPorts = [
    7236
    7250
  ];

  networking.firewall.allowedUDPPorts = [
    7236
    5353
  ];

  services.clamav = {
    updater.enable = true;
    fangfrisch.enable = true;
    daemon.enable = true;
    updater.interval = "*-*-* 00/4:00:00";
    fangfrisch.interval = "*-*-* 00/4:00:00";
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "spotify"
      "android-studio-stable"
      "idea-ultimate"
      "phpstorm"
      "goland"
      "pycharm-professional"
      "libfprint-2-tod1-goodix"
      "displaylink"
      "citrix-workspace"
      "terraform"
      "crush"
      "mongodb"
      "mfc9332cdwlpr"
    ];

  boot.kernelPackages = pkgs.linuxPackages_6_16;

  system.stateVersion = "25.05";
}
