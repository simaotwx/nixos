{
  pkgs,
  inputs,
  flakePath,
  lib,
  foundrixModules,
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
    "${flakePath}/machines/x86_64"
    "${flakePath}/modules/hardware/amd/gpu.nix"
    "${flakePath}/modules/components/displaylink.nix"
    "${flakePath}/modules/components/bootloaders/systemd-boot.nix"
    "${flakePath}/modules/components/networking/network-manager.nix"
    "${flakePath}/modules/components/desktop-environments/gnome.nix"
    "${flakePath}/modules/components/zsh"
    "${flakePath}/modules/components/virtd.nix"
        "${flakePath}/modules/components/docker.nix"
    "${flakePath}/modules/components/sound.nix"
    "${flakePath}/modules/components/shell/utilities/git.nix"
    foundrixModules.config.compat
    "${flakePath}/modules/components/ollama.nix"
    "${flakePath}/modules/components/chat-ui.nix"
    "${flakePath}/modules/components/crush.nix"
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
      chatUi = {
        enable = true;
        port = 3000;
        host = "127.0.0.1";
        openFirewall = false; # Local only
        mongodbPort = 27018;
        mongodbDbPath = "/var/db/mongodb-hf-chat-ui";
        # Configure to work with local Ollama instance
        openaiBaseUrl = "http://127.0.0.1:11434";
        models = [
          {
            id = "llama3.2:3b";
            name = "Llama 3.2 3B (Local)";
            description = "Local Llama 3.2 3B model via Ollama";
            websiteUrl = "https://ollama.com/library/llama3.2";
            modelUrl = "http://127.0.0.1:11434/api/generate";
            parameters = {
              temperature = 0.7;
              max_new_tokens = 2048;
              stop = ["<|eot_id|>" "<|end_of_text|>"];
            };
            promptTemplate = {
              prefix = "<|begin_of_text|><|start_header_id|>user<|end_header_id|>\n\n";
              suffix = "<|eot_id|><|start_header_id|>assistant<|end_header_id|>\n\n";
            };
          }
          {
            id = "llama3.2:1b";
            name = "Llama 3.2 1B (Local)";
            description = "Local Llama 3.2 1B model via Ollama";
            websiteUrl = "https://ollama.com/library/llama3.2";
            modelUrl = "http://127.0.0.1:11434/api/generate";
            parameters = {
              temperature = 0.7;
              max_new_tokens = 1024;
              stop = ["<|eot_id|>" "<|end_of_text|>"];
            };
            promptTemplate = {
              prefix = "<|begin_of_text|><|start_header_id|>user<|end_header_id|>\n\n";
              suffix = "<|eot_id|><|start_header_id|>assistant<|end_header_id|>\n\n";
            };
          }
        ];
      };
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

  services.tailscale.enable = true;
  systemd.services.tailscaled.wantedBy = lib.mkForce [ ];

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

  security.pki.certificateFiles = [
    "${flakePath}/local/certificates/thea_root_ca.crt"
  ];

  services.printing.drivers = [ pkgs.brlaser ];
  networking.firewall.allowedTCPPorts = [7236 7250];

  networking.firewall.allowedUDPPorts = [7236 5353];

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
    ];

  virtualisation.vmVariant = import ./vm.nix;

  system.stateVersion = "25.05";
}
