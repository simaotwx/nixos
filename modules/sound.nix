{ lib, config, ... }: {
  options = {
    customization.sound = {
      enable = (lib.mkEnableOption "sound module") // {
        default = true;
      };
      lowLatency = lib.mkEnableOption "low latency mode";
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
    }
      // (if customization.sound.lowLatency then {
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
      } else { });
  };
}