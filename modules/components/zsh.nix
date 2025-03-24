{ lib, config, pkgs, ... }: {
  options = {
    customization.shells = {
      zsh.ah-my-zsh.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to set up the heavy ah-my-zsh suite.
          NOTE: THIS IS CURRENTLY NOT IMPLEMENTED!
        '';
      };
      zsh.lite.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to set up a light variant of all the zsh things, including Spaceship,
          Oh My Zsh, plugins etc. This is an opinionated setup.
        '';
      };
      zsh.lite.users = lib.mkOption {
        type = with lib.types; listOf str;
        default = config.configurableUsers;
        description = "Which users to apply zsh.lite to. Defaults to all users.";
      };
    };
  };

  config =
  let
    customization = config.customization;
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
  in
  lib.mkIf customization.shells.zsh.lite.enable {
    environment.pathsToLink = [ "/share/zsh" ];
    programs.zsh.enable = true;
    programs.direnv.enableZshIntegration = true;
    programs.starship = {
      enable = true;
    };
    home-manager.users = lib.genAttrs customization.shells.zsh.lite.users (username: {
      home.packages = with pkgs; [
        spaceship-prompt zsh-history-substring-search zsh-completions zsh-z
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
    });
  };
}