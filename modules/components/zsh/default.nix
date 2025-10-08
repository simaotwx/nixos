{
  lib,
  config,
  pkgs,
  mkConfigurableUsersOptionOld,
  forEachUser,
  ...
}:
{
  options = {
    customization.shells = {
      zsh.lite.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to set up a light variant of all the zsh things, including Spaceship,
          Oh My Zsh, plugins etc. This is an opinionated setup.
        '';
      };
      zsh.lite.users = mkConfigurableUsersOptionOld {
        description = "Which users to apply zsh.lite to. Defaults to all users.";
      };
      zsh.power10k.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to set up the heavy variant of all the zsh things, including
          Powerlevel10k, Oh My Zsh, plugins etc. This is an opinionated setup.
        '';
      };
      zsh.power10k.users = mkConfigurableUsersOptionOld {
        description = "Which users to apply zsh.power10k to. Defaults to all users.";
      };
      zsh.power10k.osIconCodepoint = lib.mkOption {
        type = lib.types.str;
        default = "f313";
        description = ''
          Choose a logo from
          https://github.com/Lukas-W/font-logos?tab=readme-ov-file#usage
          and use the part of the codepoint after 0x
        '';
      };
      zsh.power10k.colors = {
        osIconBackground = lib.mkOption {
          type = lib.types.str;
          default = "#233253";
        };
        hostBackground = lib.mkOption {
          type = lib.types.str;
          default = "#26375B";
        };
        userBackground = lib.mkOption {
          type = lib.types.str;
          default = "#2A3D64";
        };
        dirBackground = lib.mkOption {
          type = lib.types.str;
          default = "#2E436E";
        };
        dirAnchorBackground = lib.mkOption {
          type = lib.types.str;
          default = "#334A79";
        };
        osIconForeground = lib.mkOption {
          type = lib.types.str;
          default = "#7EBAE4";
        };
        hostForeground = lib.mkOption {
          type = lib.types.str;
          default = "#87BFE6";
        };
        userForeground = lib.mkOption {
          type = lib.types.str;
          default = "#8FC3E8";
        };
        dirForeground = lib.mkOption {
          type = lib.types.str;
          default = "#9FCCEB";
        };
        dirAnchorForeground = lib.mkOption {
          type = lib.types.str;
          default = "#BFDDF2";
        };
      };
    };
  };

  config =
    let
      customization = config.customization;
      zshCacheDir = "$XDG_CACHE_HOME/zsh";
      oh-my-zsh-plugin = name: {
        name = name;
        file = "plugins/${name}/${name}.plugin.zsh";
        src = builtins.fetchGit {
          url = "https://github.com/ohmyzsh/ohmyzsh";
          rev = "eeaf9f89b0e8b10a02f16cb6cdd93779c28eb2ea";
        };
      };
      oh-my-zsh-plugins = names: lib.lists.forEach names oh-my-zsh-plugin;
    in
    lib.mkMerge [
      (lib.mkIf customization.shells.zsh.lite.enable {
        environment.pathsToLink = [ "/share/zsh" ];
        programs.zsh.enable = true;
        programs.direnv.enableZshIntegration = true;
        programs.starship = {
          enable = true;
        };
        home-manager.users = forEachUser customization.shells.zsh.lite.users {
          home.packages = with pkgs; [
            spaceship-prompt
            zsh-history-substring-search
            zsh-completions
            zsh-z
          ];
          programs.zsh = {
            enable = true;
            enableCompletion = true;
            autosuggestion = {
              enable = true;
              highlight = "fg=#cacaca";
            };
            syntaxHighlighting = {
              enable = true;
            };
            autocd = true;

            history = {
              size = 402000;
              save = 400000;
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

            initContent = ''
              source ${pkgs.spaceship-prompt}/share/zsh/themes/spaceship.zsh-theme

              COMPLETION_WAITING_DOTS="true"
            '';

            plugins = [
            ]
            ++ (oh-my-zsh-plugins [
              "history"
              "shrink-path"
              "sudo"
              "transfer"
              "z"
            ]);
          };
        };
      })
      (lib.mkIf customization.shells.zsh.power10k.enable {
        environment.pathsToLink = [ "/share/zsh" ];
        programs.zsh.enable = true;
        programs.direnv.enableZshIntegration = true;
        home-manager.users = forEachUser customization.shells.zsh.power10k.users {
          home.packages = with pkgs; [
            zsh-history-substring-search
            zsh-completions
            zsh-z
            thefuck
          ];
          programs.zsh = {
            enable = true;
            enableCompletion = true;
            autosuggestion = {
              enable = true;
              highlight = "fg=#cacaca";
            };
            syntaxHighlighting = {
              enable = true;
            };
            autocd = true;

            history = {
              size = 402000;
              save = 400000;
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

            initContent =
              let
                p10kConfigFile = ./.p10k.zsh;
                p10kCfg = customization.shells.zsh.power10k;
              in
              ''
                mkdir -p "${zshCacheDir}"
                ZSH_CACHE_DIR="${zshCacheDir}"
                ZSH_THEME="powerlevel10k/powerlevel10k"
                if [ `tput colors` != "256" ] || [[ "$(tty)" == *"/tty"* ]]; then
                  export ZSH_THEME="clean"
                fi
                DISABLE_AUTO_UPDATE="true"
                DISABLE_UPDATE_PROMPT="true"
                COMPLETION_WAITING_DOTS="true"
                source "${p10kConfigFile}"
                alias ll='ls -alF'
                alias la='ls -A'
                alias l='ls -CF'
                if [[ $COLORTERM =~ ^(truecolor|24bit)$ ]]; then
                  typeset -g POWERLEVEL9K_CUSTOM_OS_ICON_BACKGROUND="${p10kCfg.colors.osIconBackground}"
                  typeset -g POWERLEVEL9K_HOST_BACKGROUND="${p10kCfg.colors.hostBackground}"
                  typeset -g POWERLEVEL9K_USER_BACKGROUND="${p10kCfg.colors.userBackground}"
                  typeset -g POWERLEVEL9K_DIR_BACKGROUND="${p10kCfg.colors.dirBackground}"
                  typeset -g POWERLEVEL9K_DIR_ANCHOR_BACKGROUND="${p10kCfg.colors.dirAnchorBackground}"

                  typeset -g POWERLEVEL9K_CUSTOM_OS_ICON_FOREGROUND="${p10kCfg.colors.osIconForeground}"
                  typeset -g POWERLEVEL9K_HOST_FOREGROUND="${p10kCfg.colors.hostForeground}"
                  typeset -g POWERLEVEL9K_USER_FOREGROUND="${p10kCfg.colors.userForeground}"
                  typeset -g POWERLEVEL9K_DIR_FOREGROUND="${p10kCfg.colors.dirForeground}"
                  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND="${p10kCfg.colors.dirAnchorForeground}"

                  typeset -g POWERLEVEL9K_CUSTOM_OS_ICON="echo $'\u${p10kCfg.osIconCodepoint}'"
                fi
                source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
                [[ -z "$ZSH_LAST_WORKING_DIRECTORY" ]] || return
                [[ "$PWD" == "$HOME" ]] || return

                if lwd 2>/dev/null; then
                  ZSH_LAST_WORKING_DIRECTORY=1
                fi
              '';

            plugins = [
            ]
            ++ (oh-my-zsh-plugins [
              "git"
              "adb"
              "battery"
              "colorize"
              "cp"
              "emoji"
              "fancy-ctrl-z"
              "fd"
              "git-flow"
              "github"
              "gitignore"
              "gnu-utils"
              "golang"
              "history"
              "httpie"
              "jsontools"
              "jump"
              "last-working-dir"
              "lol"
              "man"
              "mosh"
              "nmap"
              "node"
              "pep8"
              "pip"
              "pj"
              "ripgrep"
              "rsync"
              "shrink-path"
              "sudo"
              "themes"
              "transfer"
              "yarn"
              "z"
            ]);
          };
        };
      })
    ];
}
