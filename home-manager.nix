{ unstable, noice }:
{ config, pkgs, lib, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
  oh-my-zsh-plugin = name:
      {
        name = name;
        file = "plugins/${name}/${name}.plugin.zsh";
        src = builtins.fetchGit {
          url = "https://github.com/ohmyzsh/ohmyzsh";
          rev = "c68ff8aeedc2b779ae42d745457ecd443e22e212";
        };
      };
  oh-my-zsh-plugins = names: lib.lists.forEach names oh-my-zsh-plugin;
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
          "text/html" = "librewolf.desktop";
          "x-scheme-handler/http" = "librewolf.desktop";
          "x-scheme-handler/https" = "librewolf.desktop";
          "x-scheme-handler/about" = "librewolf.desktop";
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
        "text/html" = "librewolf.desktop";
        "x-scheme-handler/http" = "librewolf.desktop";
        "x-scheme-handler/https" = "librewolf.desktop";
        "x-scheme-handler/about" = "librewolf.desktop";
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
          "git" "history" "shrink-path" "sudo" "transfer"
        ]
      );
    };

    home.packages = with pkgs; [
      librewolf
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
      g810-led
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
      telegram-desktop
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
      unstable.ladybird
      imagemagick
      noice.yuzu
      thunderbird
      evince
      stress
      ntfs3g woeusb-ng
      smartmontools rsync
      vlc

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
      DEFAULT_BROWSER = "${pkgs.librewolf}/bin/librewolf";
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
      extensions = with pkgs.vscode-extensions; [
        bungcip.better-toml
        jnoortheen.nix-ide
        rust-lang.rust-analyzer
        naumovs.color-highlight
        ziglang.vscode-zig
      ];
    };

  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
}
