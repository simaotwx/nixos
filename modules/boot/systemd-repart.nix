{
  lib,
  config,
  ...
}:
{
  options = {
    target.boot.systemdRepart.device = lib.mkOption {
      type = lib.types.str;
      description = "System disk device path for runtime repart";
    };
  };

  config = {
    boot.initrd.systemd.repart = {
      enable = true;
      device = config.target.boot.systemdRepart.device;
      empty = "allow";
    };

    # Add systemd-repart dependency to nix-store mount
    fileSystems."/nix/store".options = [ "x-systemd.after=systemd-repart.service" ];
  };
}