{ lib, config, ... }: {
  options = {
    customization.services = {
      enable = (lib.mkEnableOption "services module") // {
        default = true;
      };
      printing = lib.mkEnableOption "printing services";
      networkDiscovery = lib.mkEnableOption "network discovery services like Avahi";
    };
  };

  config =
  let customization = config.customization;
  in
  lib.mkIf customization.services.enable (lib.mkMerge [
    {
      services.printing.enable = customization.services.printing;
    }
    (lib.mkIf customization.services.networkDiscovery {
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
      services.rpcbind.enable = true;
    })
  ]);
}