{ lib, config, ... }: {
  options = {
    customization.networking = {
      enable = (lib.mkEnableOption "networking module") // {
        default = true;
      };
      solution = lib.mkOption {
        type = lib.types.enum [ "NetworkManager" ];
        default = "NetworkManager";
        description = "The networking solution to use";
      };
    };
  };

  config =
  let customization = config.customization;
  in
  lib.mkIf customization.networking.enable {
    networking.networkmanager.enable = customization.networking.solution == "NetworkManager";
    networking.useDHCP = lib.mkDefault true;
    systemd.services.NetworkManager-wait-online.enable = lib.mkDefault false;
  };
}