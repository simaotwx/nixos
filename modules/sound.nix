{ lib, config, ... }: {
  options = {
    customization.sound = {
      enable = (lib.mkEnableOption "sound module") // {
        default = true;
      };
      support32Bit = lib.mkEnableOption "support for 32 bit";
      pulse = (lib.mkEnableOption "pulse support") // {
        default = true;
      };
    };
  };

  config =
  let customization = config.customization;
  in
  lib.mkIf customization.sound.enable {
    services.pipewire = {
      enable = true;
      pulse.enable = customization.sound.pulse;
      alsa.enable = true;
      alsa.support32Bit = lib.mkDefault customization.sound.support32Bit;
    };
    security.rtkit.enable = true;
  };
}