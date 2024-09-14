{ config, lib, pkgs, inputs, ... }:

let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/24.11-pre) {
      config = config.nixpkgs.config;
    };
in
{
  imports =
    [
      ./hardware-configuration.nix
     # ./linux-nitrous.nix
      (import ./home-manager.nix { unstable = unstable; })
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
    consoleMode = "max";
  };
  boot.loader.timeout = 1;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth = let theme = "lone"; in {
    enable = true;
    theme = theme;
    themePackages = with pkgs; [
      (adi1090x-plymouth-themes.override {
        selected_themes = [ theme ];
      })
    ];
  };
  boot.tmp = {
    useTmpfs = true;
  };
  boot.consoleLogLevel = 0;
  boot.kernelParams = [
    "quiet" "splash" "loglevel=2" "elevator=bfq" "boot.shell_on_fail"
    "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3"
  ];
  boot.initrd.verbose = false;

  boot.kernel.sysctl = {
    # Security
    # https://medium.com/@ganga.jaiswal/build-a-hardened-linux-system-with-nixos-88bb7d77ba22
    # tip: use reader mode to not get your eyes destroyed
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    "kernel.yama.ptrace_scope" = 2;
    "kernel.kptr_restrict" = 2;
    "kernel.unprivileged_bpf_disabled" = 1;
    "net.core.bpf_jit_harden" = 2;
    "kernel.ftrace_enabled" = false;
    "kernel.randomize_va_space" = 2;
    "fs.suid_dumpable" = 0;
    "kernel.dmesg_restrict" = 1;
    "vm.unprivileged_userfaultfd" = 0;
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.tcp_syn_retries" = 2;
    "net.ipv4.tcp_synack_retries" = 2;
    "net.ipv4.tcp_max_syn_backlog" = 4096;
    "net.ipv4.tcp_rfc1337" = 1;
    "net.ipv4.conf.all.log_martians" = true;
    "net.ipv4.conf.default.log_martians" = true;
    # Other stuff
    "vm.dirty_ratio" = 60;
    "vm.dirty_background_ratio" = 20;
    "vm.max_map_count" = 16777216;
    "vm.vfs_cache_pressure" = 80;
  };
  security.virtualisation.flushL1DataCache = "always";
  networking.nftables.enable = true;
  networking.firewall.enable = true;
  programs.firejail = {
    enable = true;
  };
  security.forcePageTableIsolation = true;

  networking.hostName = "aludepp";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  environment.pathsToLink = [ "/share/zsh" ];
  environment.shellAliases = {
    gpick = "git cherry-pick -s";
  };

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "C.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
    "en_GB.UTF-8/UTF-8"
    "de_DE.UTF-8/UTF-8"
  ];
  console = {
     font = "Lat2-Terminus16";
     keyMap = "de";
     earlySetup = true;
  };

  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    extraConfig.pipewire = {
      "92-low-latency" = {
        context.properties = {
          default.clock = {
            rate = 48000;
            quantum = 32;
            min-quantum = 32;
            max-quantum = 32;
          };
        };
      };
    };
    extraConfig.pipewire-pulse = {
      "92-low-latency" = {
         context.modules = [
           {
             name = "libpipewire-module-protocol-pulse";
             args = {
               pulse.min.req = "32/48000";
               pulse.default.req = "32/48000";
               pulse.max.req = "32/48000";
               pulse.min.quantum = "32/48000";
               pulse.max.quantum = "32/48000";
             };
           }
         ];
         stream.properties = {
           node.latency = "32/48000";
           resample.quality = 1;
         };
       };
    };
  };

  services.libinput.enable = true;

  programs.dconf.enable = true;
  programs.zsh.enable = true;

  users.users.simao = {
    isNormalUser = true;
    extraGroups = [ "wheel" "gamemode" "cdrom" "adbusers" ];
    uid = 1000;
    hashedPassword = "$y$j9T$dnI7w6vlAMDavd6yzhEZo/$zG.rUrydeU/An8SRDBs7IEHW9ygTuBL8GNJO.CGLMuB";
    shell = pkgs.zsh;
  };
  users.mutableUsers = false;
  users.groups.simao.gid = 1000;

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
      noto-fonts noto-fonts-emoji noto-fonts-cjk
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
      vim
      dust
      duperemove
      ripgrep
      polkit-kde-agent
    ];
    defaultPackages = [ ];
    variables = {
      EDITOR = "vim";
      VISUAL = "vim";
      PAGER = "less";
      BROWSER = "librewolf";
    };
  };

  programs.gnupg.agent = {
     enable = true;
  };

  services.udev.packages = with pkgs; [
    android-udev-rules
  ];

  system.copySystemConfiguration = true;

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      package = unstable.hyprland;
      portalPackage = unstable.xdg-desktop-portal-hyprland;
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.extraConfig = ''
    DefaultLimitNOFILE=1048576
  '';

  security.pam.loginLimits = [{
    type = "hard";
    domain = "*";
    item = "nofile";
    value = "1048576";
  }];

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  services.dbus.enable = true;
  services.timesyncd.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [
    unstable.xdg-desktop-portal-hyprland
    pkgs.xdg-desktop-portal-gtk
  ];
  gtk.iconCache.enable = true;

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.swraid.enable = true;

  security.polkit.enable = true;
  
  system.stateVersion = "24.05";

  nix.settings = {
    max-jobs = 10;
    cores = 24;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 60d";
  };
}


