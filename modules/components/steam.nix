{ pkgs, lib, config, ...}: {
  options = {
    customization.software.steam = {
      gamemode.enable = lib.mkEnableOption "gamemode" // { default = true; };
      package = lib.mkOption {
        type = lib.types.package;
        description = "Steam package to use";
        default = pkgs.steam;
      };
      gamescope.enable = lib.mkEnableOption "gamescope";
      gamescope.session.enable = lib.mkEnableOption "gamescope session";
    };
  };

  config = let cfg = config.customization.software.steam; in {
    programs.gamemode = {
      enable = cfg.gamemode.enable;
    };
    programs.gamescope = {
      enable = cfg.gamescope.enable;
      capSysNice = lib.mkDefault true;
    };
    programs.steam = {
      enable = true;
      package = cfg.package;
      gamescopeSession.enable = cfg.gamescope.session.enable;
    };
  };

}