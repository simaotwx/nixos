{ lib, config, ... }:
{
  options = {
    customization.virtualisation.docker.rootless.enable = lib.mkEnableOption "rootless docker";
    customization.virtualisation.docker.autostart = lib.mkEnableOption "docker starting at boot";
  };

  config = {
    virtualisation.docker.enable = true;
    virtualisation.docker.rootless =
      lib.optionalAttrs config.customization.virtualisation.docker.rootless.enable
        {
          enable = true;
          setSocketVariable = true;
        };
    virtualisation.docker.storageDriver = "overlay2";
    systemd.services.docker.wantedBy =
      if config.customization.virtualisation.docker.autostart then lib.mkForce [ ] else [ ];
    systemd.services.docker.serviceConfig = lib.optionalAttrs (
      !config.customization.virtualisation.docker.autostart
    ) { Restart = lib.mkForce "no"; };
    virtualisation.docker.daemon.settings = {
      userland-proxy = true;
      ipv6 = true;
      fixed-cidr-v6 = "fd00::/80";
    };

    virtualisation.containers.enable = true;
  };
}
