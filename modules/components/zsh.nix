{ lib, config, ... }: {
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
    };
  };

  config =
  let customization = config.customization;
  in
  lib.mkIf customization.shells.zsh.lite.enable {
    environment.pathsToLink = [ "/share/zsh" ];
    programs.zsh.enable = true;
    # TODO: add home-manager part
  };
}