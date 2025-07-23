{ lib, config, ... }:
{
  options = {
    customization.console = {
      enable = (lib.mkEnableOption "console module") // {
        default = true;
      };
    };
  };

  config =
    let
      customization = config.customization;
    in
    lib.mkIf customization.console.enable {
      console = {
        font = lib.mkDefault "Lat2-Terminus16";
        keyMap = lib.mkDefault customization.general.keymap;
        earlySetup = true;
      };
    };
}
