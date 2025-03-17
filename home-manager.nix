{ ... }:
{ config, pkgs, lib, ... }:
let
  # release-24.11
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/9d3d080aec2a35e05a15cedd281c2384767c2cfe.tar.gz";
  oh-my-zsh-plugin = name:
      {
        name = name;
        file = "plugins/${name}/${name}.plugin.zsh";
        src = builtins.fetchGit {
          url = "https://github.com/ohmyzsh/ohmyzsh";
          rev = "1c2127727af0ac452292f844ee32306f12906d03";
        };
      };
  oh-my-zsh-plugins = names: lib.lists.forEach names oh-my-zsh-plugin;
  zen-browser = (builtins.getFlake "github:0xc000022070/zen-browser-flake/30fdea2435aeeb961acba896b9b65bab4fd17003").packages."${pkgs.system}".beta;
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "discord"
    "spotify"
    "steam"
    "steam-original"
    "steam-run"
    "steam-unwrapped"
    "makemkv"
    "android-studio-stable"
  ];

  programs.steam = {
    enable = true;
    package = pkgs.steam;
  };
  programs.gamemode.enable = true;
  programs.adb.enable = true;

  services.gvfs.enable = true;

  #programs.nix-ld = { enable = true; libraries = pkgs.steam-run.fhsenv.args.multiPkgs pkgs; };
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
        alsa-lib
        libGL
        xorg.libICE
        xorg.libSM
        xorg.libX11
        xorg.libXcursor
        xorg.libXext
        xorg.libXi
        xorg.libXinerama
        xorg.libXrandr
        libpulseaudio
        libxkbcommon
        wayland

        libgcc
        gcc
  ];

  home-manager.users.simao = {
    home.stateVersion = "24.05";
    xdg = {
      enable = true;
      mimeApps.enable = true;
      mimeApps.associations = {
        added = {
          "application/pdf" = "org.gnome.Evince.desktop";
          "text/html" = "zen.desktop";
          "text/x-log" = "org.gnome.gedit.desktop";
          "x-scheme-handler/http" = "zen.desktop";
          "x-scheme-handler/https" = "zen.desktop";
          "x-scheme-handler/about" = "zen.desktop";
          "image/png" = "org.gnome.Loupe.desktop"; 
          "image/jpg" = "org.gnome.Loupe.desktop"; 
          "image/jpeg" = "org.gnome.Loupe.desktop"; 
          "image/gif" = "org.gnome.Loupe.desktop";
          "audio/aac" = "io.github.celluloid_player.Celluloid.desktop"; 
          "audio/flac" = "io.github.celluloid_player.Celluloid.desktop"; 
          "audio/ogg" = "io.github.celluloid_player.Celluloid.desktop"; 
          "audio/wav" = "io.github.celluloid_player.Celluloid.desktop"; 
          "audio/opus" = "io.github.celluloid_player.Celluloid.desktop";
          "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
          "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
        };
      };
      mimeApps.defaultApplications = {
        "application/pdf" = "org.gnome.Evince.desktop";
        "text/html" = "zen.desktop";
        "x-scheme-handler/http" = "zen.desktop";
        "x-scheme-handler/https" = "zen.desktop";
        "x-scheme-handler/about" = "zen.desktop";
        "image/png" = "org.gnome.Loupe.desktop"; 
        "image/jpg" = "org.gnome.Loupe.desktop"; 
        "image/jpeg" = "org.gnome.Loupe.desktop"; 
        "image/gif" = "org.gnome.Loupe.desktop"; 
        "audio/aac" = "io.github.celluloid_player.Celluloid.desktop"; 
        "audio/flac" = "io.github.celluloid_player.Celluloid.desktop"; 
        "audio/ogg" = "io.github.celluloid_player.Celluloid.desktop"; 
        "audio/wav" = "io.github.celluloid_player.Celluloid.desktop"; 
        "audio/opus" = "io.github.celluloid_player.Celluloid.desktop"; 
        "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
        "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
      };
    };
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion = {
        enable = true;
        highlight = "fg=#cacaca";
#        strategy = [ "completion" ];
      };
      syntaxHighlighting = {
        enable = true;
#        higlighters = [ "brackets" ];
      };
      autocd = true;

      history = {
        size = 402000;
        save = 400000;
#        append = true;
        expireDuplicatesFirst = true;
        extended = true;
        ignoreDups = true;
        share = true;
        ignoreSpace = false;
      };

      historySubstringSearch = {
        enable = true;
        searchDownKey = "$terminfo[kcud1]";
        searchUpKey = "$terminfo[kcuu1]";
      };

      initExtra = ''
        source ${pkgs.spaceship-prompt}/share/zsh/themes/spaceship.zsh-theme

        COMPLETION_WAITING_DOTS="true"
      '';

      plugins = [
      ] ++ (
        oh-my-zsh-plugins [
          "history" "shrink-path" "sudo" "transfer"
        ]
      );
    };

    home.packages = with pkgs; [
      alacritty
      wpaperd eww wofi
      hyprlock hypridle hyprshot
      rose-pine-cursor
      jq pv pwgen
      socat
      pavucontrol playerctl
      gopass gopass-jsonapi
      git curl
      wl-clipboard cliphist wl-clipboard-x11
      easyeffects
      spaceship-prompt zsh-history-substring-search zsh-completions zsh-z
      nautilus file-roller loupe gedit gnome-calculator
      mangohud
      appimage-run
      celluloid
      orca-slicer
      dig
      signal-desktop
      unzip file zstd tree bat fd brotli
      gparted
      picocom
      #telegram-desktop
      polychromatic
      chromium
      protobuf
      e2fsprogs
      audacity
      lm_sensors
      fastfetch
      jetbrains.idea-community jdk
      nixd nixpkgs-fmt
      bc
      jellycli
      imagemagick
      thunderbird
      evince
      stress
      subfinder
      ntfs3g woeusb-ng
      smartmontools rsync
      vlc
      libreoffice-fresh
      p7zip iptables nftables inetutils simple-scan
      zen-browser
      via
      android-studio
      hwloc

      # GStreamer
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-libav
      gst_all_1.gst-vaapi

      # AOSP stuff
      git-repo xmlstarlet ccache

      vesktop
      spotify
      makemkv
    ];

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    programs.starship = {
      enable = true;
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        gtk-theme = "Adwaita";
        color-scheme = "prefer-dark";
      };
    };

    gtk = {
      enable = true;
      theme = {
        package = pkgs.gnome-themes-extra;
        name = "Adwaita";
      };
      cursorTheme = {
        package = pkgs.rose-pine-cursor;
        name = "BreezeX-RosePine-Linux";
        size = 28;
      };
      font = {
        package = pkgs.fira;
        name = "Fira Sans Condensed";
        size = 11;
      };
      iconTheme = {
        package = pkgs.gnome-themes-extra;
        name = "Adwaita";
      };
      gtk2.extraConfig = ''
        gtk-theme-name = "Adwaita"
      '';
      gtk3 = {
        extraConfig = {
          gtk-toolbar-style = "GTK_TOOLBAR_ICONS";
          gtk-xft-antialias = 1;
          gtk-xft-hinting = 1;
          gtk-xft-hintstyle = "hintslight";
          gtk-xft-rgba = "rgb";
          gtk-application-prefer-dark-theme = 1;
        };
      };
    };

    home.pointerCursor = {
      package = pkgs.rose-pine-cursor;
      gtk.enable = true;
      name = "BreezeX-RosePine-Linux";
      size = 28;
    };

    systemd.user.sessionVariables = config.home-manager.users.simao.home.sessionVariables;

    home.language = {
      base = "en_US.UTF-8";
      measurement = "de_DE.UTF-8";
      monetary = "de_DE.UTF-8";
      name = "en_GB.UTF-8";
      paper = "de_DE.UTF-8";
      time = "en_GB.UTF-8";
    };

    home.preferXdgDirectories = true;

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      LIBVIRT_DEFAULT_URI = "qemu:///system";
      NIXOS_OZONE_WL = "1";
      DEFAULT_BROWSER = "${zen-browser}/bin/zen";
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
    };

    home.sessionPath = [
      "$HOME/Documents/amdgpu-clocks"
    ];

    programs.htop = {
      enable = true;
      settings = {
        color_scheme = 6;
        cpu_count_from_one = 1;
        delay = 500;
      };
    };

    # This installs VSCodium
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      mutableExtensionsDir = false;
      #profiles.default = {
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;

        userSettings = {
          "editor.fontFamily" = "'Iosevka Comfy', monospace";
          "editor.lineHeight" = 22;
          "files.autoSave" = "onFocusChange";
          "files.trimTrailingWhitespace" = true;
          "terminal.integrated.fontFamily" = "Hasklug Nerd Font Mono";
          "workbench.startupEditor" = "none";
          "git.terminalAuthentication" = false;
          "github.gitAuthentication" = false;
          "files.enableTrash" = false;
          "git.autoRepositoryDetection" = "openEditors";
          "debug.console.fontFamily" = "Hasklug Nerd Font Mono";
          "editor.inlayHints.enabled" = "off";
          "terminal.integrated.shellIntegration.history" = 6000;
          "terminal.integrated.enablePersistentSessions" = false;
          "editor.rulers" = [ 120 ];
          "workbench.colorCustomizations" = {
            "editorRuler.foreground" = "#242424";
          };
          "terminal.integrated.tabs.enabled" = true;
          "editor.fontSize" = 13;
          "git.openRepositoryInParentFolders" = "never";
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nixd";
        };
        extensions = with pkgs.vscode-extensions; [
          tamasfe.even-better-toml
          jnoortheen.nix-ide
          rust-lang.rust-analyzer
          naumovs.color-highlight
          ziglang.vscode-zig
          mkhl.direnv
          ms-azuretools.vscode-docker
          vadimcn.vscode-lldb
          matthewpi.caddyfile-support
        ];
      #};
    };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
}
