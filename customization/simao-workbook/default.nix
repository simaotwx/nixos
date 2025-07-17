{ pkgs, inputs, flakePath, lib, ... }: {
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc
    common-cpu-amd
    common-cpu-amd-pstate
    common-gpu-amd
    common-pc-ssd
    framework-16-7040-amd
    ./filesystems.nix
    "${flakePath}/machines/x86_64"
    "${flakePath}/modules/components/alacritty.nix"
    "${flakePath}/modules/components/displaylink.nix"
    "${flakePath}/modules/components/goose-ai.nix"
    "${flakePath}/modules/components/ollama.nix"
    "${flakePath}/modules/components/networking/network-manager.nix"
    "${flakePath}/modules/components/desktop-environments/gnome.nix"
    "${flakePath}/modules/components/zsh"
    "${flakePath}/modules/components/virtd.nix"
    "${flakePath}/modules/components/qml.nix"
    "${flakePath}/modules/components/docker.nix"
  ];

  # Customization of modules
  customization = {
    hardware = {
      cpu.cores = 8;
      cpu.vendor = "amd";
      storage.hasNvme = true;
    };
    general = {
      hostName = "simao-workbook";
      timeZone = "Europe/Berlin";
      defaultLocale = "en_US.UTF-8";
      keymap = "de";
    };
    compat.enable = true;
    graphics =  {
      amd.enable = true;
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
    peripherals.qmk.enable = true;
    shells.zsh.lite.enable = true;
    shell.simaosSuite.enable = true;
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
  systemd.services.tailscaled.wantedBy = lib.mkForce [];

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
      nerd-fonts.fira-code nerd-fonts.hasklug
      noto-fonts noto-fonts-emoji noto-fonts-cjk-sans
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
      duperemove
      ripgrep
      exfatprogs
      nix-bundle
      gparted
      pop-wallpapers
      (
        pkgs.writeShellScriptBin "dhcp-setup" ''
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

          nixos-firewall-tool open 67
          nixos-firewall tool open 68

          # Start dnsmasq with DHCP
          ${lib.getExe pkgs.dnsmasq} -d -i "$IFACE" --port=0 --listen-address="$GATEWAY" --dhcp-range="$DHCP_START,$DHCP_END,12h"
        ''
      )
    ];
    defaultPackages = [ ];
    variables = {
      EDITOR = "vim";
      VISUAL = "vim";
      PAGER = "less";
      BROWSER = "firefox";
    };
    pathsToLink = [ "/share/backgrounds" "/share/gnome-background-properties" ];
  };

  nixpkgs.overlays = [
    (final: prev: {
      pop-wallpapers = prev.pop-wallpapers.overrideAttrs (finalAttrs: prevAttrs: {
        fixupPhase = ''
          sed -i -re 's/\/usr/\/run\/current-system\/sw/g' $out/share/gnome-background-properties/pop-wallpapers.xml
        '';
      });
    })
  ];

  services.udev.packages = with pkgs; [
    android-udev-rules
  ];

  services.clamav = {
    updater.enable = true;
    fangfrisch.enable = true;
    daemon.enable = true;
    updater.interval = "*-*-* 00/4:00:00";
    fangfrisch.interval = "*-*-* 00/4:00:00";
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
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
  ];

  security.pki.certificateFiles = [
    "${flakePath}/local/certificates/thea_root_ca.crt"
  ];

  virtualisation.vmVariant = import ./vm.nix;
}
