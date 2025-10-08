{
  lib,
  config,
  ...
}:
{
  config = {
    # Enable runtime systemd-repart for var partition creation
    systemd.repart = {
      enable = true;
      partitions = {
        "70-var" = {
          Type = "var";
          UUID = lib.toLower "00000000-0000-4000-9000-000000000070";
          Format = "btrfs";
          Label = "var";
          Minimize = "off";
          Encrypt = "off";
          SizeMinBytes = "1G";
          SplitName = "-";
          FactoryReset = "yes";
          Priority = -15;
        };
      };
    };

    # Mount the var partition
    fileSystems."/var" = {
      device = "PARTUUID=00000000-0000-4000-9000-000000000070";
      fsType = "btrfs";
      options = [
        "x-systemd.rw-only"
        "x-systemd.device-timeout=60s"
        "noatime"
        "discard"
        "x-systemd.after=initrd-parse-etc.service"
        "subvol=var"
      ]
      ++ lib.optionals config.boot.initrd.systemd.repart.enable [
        "x-systemd.after=systemd-repart.service"
      ];
    };
  };
}
