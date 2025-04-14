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
      ];
    };

    "/var/updates" = {
      fsType = "tmpfs";
      options = [
        "size=50%"
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

    "/nix/ro-store" =
      let partitionConfig = config.image.repart.partitions."store".repartConfig;
      in {
        device = "/dev/disk/by-partlabel/${partitionConfig.Label}";
        fsType = partitionConfig.Format;
        options = [ "noatime" "x-systemd.after=initrd-parse-etc.service" "x-systemd.device-timeout=10s" ];
        neededForBoot = true;
      };

    "/nix/rw-store" =
      let partitionConfig = config.systemd.repart.partitions."20-nix-store-rw";
      in {
        device = "/dev/disk/by-partuuid/${partitionConfig.UUID}";
        fsType = partitionConfig.Format;
        options = [
          "noatime" "x-systemd.rw-only"
          "x-systemd.device-timeout=30s"
        ];
        neededForBoot = true;
      };

    "/nix/store" = {
      overlay = {
        lowerdir = ["/nix/ro-store"];
        upperdir = "/nix/rw-store/upper";
        workdir = "/nix/rw-store/work";
      };
      options = [
        "noatime" "x-systemd.device-timeout=30s"
      ];
    };

    "/home" =
      let partitionConfig = config.systemd.repart.partitions."30-home";
      in {
        device = "PARTUUID=${partitionConfig.UUID}";
        fsType = partitionConfig.Format;
        options = [
          "noatime" "x-systemd.rw-only"
          "x-systemd.device-timeout=30s"
        ];
        autoResize = true;
        neededForBoot = true;
      };
  };

  systemd.tmpfiles.settings = {
    "home" = {
      "/home/${config.customization.kodi.user}" = {
        d = {
          group = config.customization.kodi.user;
          mode = "0750";
          user = config.customization.kodi.user;
        };
      };
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