{ config, ... }: {
  boot.supportedFilesystems = {
    btrfs = true;
  };

  fileSystems = {
    "/" = {
      fsType = "tmpfs";
      options = [
        "size=10%"
        "noatime"
      ];
    };

    "/boot" =
      let partitionConfig = config.image.repart.partitions."esp".repartConfig;
      in {
        device = "PARTUUID=${partitionConfig.UUID}";
        fsType = partitionConfig.Format;
        options = [ "fmask=0077" "dmask=0077" "noatime" ];
      };

    "/nix/store" =
      let partitionConfig = config.image.repart.partitions."store".repartConfig;
      in {
        device = "PARTLABEL=${partitionConfig.Label}";
        fsType = partitionConfig.Format;
        options = [ "noatime" ];
      };

    "/home" =
      let partitionConfig = config.systemd.repart.partitions."home";
      in {
        device = "PARTLABEL=${partitionConfig.Label}";
        fsType = partitionConfig.Format;
        options = [ "x-systemd.rw-only" "x-systemd.device-timeout=30s" "noatime" "discard" ];
        autoResize = true;
      };
  };
}