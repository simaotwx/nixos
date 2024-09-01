{ config, pkgs, lib, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
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
    "makemkv"
  ];

  programs.steam = {
    enable = true;
  };

  services.gvfs.enable = true;

  home-manager.users.simao = {
    home.stateVersion = "24.05";
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
        size = 102000;
        save = 100000;
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
      jq
      socat
      pavucontrol playerctl
      gopass gopass-jsonapi
      git curl
      wl-clipboard cliphist wl-clipboard-x11
      g810-led
      easyeffects
      spaceship-prompt zsh-history-substring-search zsh-completions zsh-z
      gnome.nautilus

      vesktop
      spotify
      makemkv
    ];

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    gtk = {
      enable = true;
      theme = {
        package = pkgs.gnome.gnome-themes-extra;
        name = "Adwaita-dark";
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
        package = pkgs.gnome.gnome-themes-extra;
        name = "Adwaita-dark";
      };
      gtk2.extraConfig = ''
        gtk-theme-name = "Adwaita-dark"
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
      base = "en_US";
      measurement = "en_DE";
      monetary = "de_DE";
      name = "en_DE";
      paper = "de_DE";
      time = "en_UK";
    };

    home.preferXdgDirectories = true;

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
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

  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
}
