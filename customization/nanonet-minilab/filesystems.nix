{ config, ... }: {
  boot.initrd.supportedFilesystems = {
    btrfs = true;
    squashfs = true;
    overlay = true;
  };
  boot.kernelParams = [
    "systemd.setenv=SYSTEMD_REPART_MKFS_OPTIONS_BTRFS=--nodiscard"
  ];

  fileSystems = {
    "/" = {
      fsType = "tmpfs";
      options = [
        "size=10%"
        "noatime"
        "mode=0755"
        "uid=0"
        "gid=0"
      ];
    };

    "/var/updates" = {
      fsType = "tmpfs";
      options = [
        "size=60%"
        "noatime"
      ];
    };

    "/boot" =
      let partitionConfig = config.image.repart.partitions."esp".repartConfig;
      in {
        device = "/dev/disk/by-partuuid/${partitionConfig.UUID}";
        fsType = partitionConfig.Format;
        options = [
          "fmask=0077" "dmask=0077" "noatime"
          "x-systemd.device-timeout=30s"
        ];
      };

    "/nix/store" =
      let partitionConfig = config.image.repart.partitions."store".repartConfig;
      in {
        device = "/dev/disk/by-partlabel/${partitionConfig.Label}";
        fsType = partitionConfig.Format;
        options = [ "noatime" "x-systemd.after=initrd-parse-etc.service" "x-systemd.device-timeout=10s" ];
        neededForBoot = true;
      };

    "/var" =
      let partitionConfig = config.systemd.repart.partitions.var;
      in {
        device = "/dev/disk/by-partuuid/${partitionConfig.UUID}";
        fsType = partitionConfig.Format;
        options = [
          "noatime" "x-systemd.rw-only"
          "x-systemd.device-timeout=30s"
        ];
        neededForBoot = true;
      };

    "/home" = {
      fsType = "tmpfs";
      options = [
        "size=10%"
        "noatime"
      ];
      neededForBoot = true;
    };
  };

  systemd.tmpfiles.settings = {
    "var" = {
      "/var/updates" = {
        d = {
          user = "root";
          group = "root";
          mode = "0755";
        };
      };
    };
  };
}