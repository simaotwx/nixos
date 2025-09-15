{
  config = {
    fileSystems."/boot" = {
      device = "/dev/disk/by-partuuid/C12A7328-F81F-11D2-BA4B-00A0C93EC93B";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
        "noatime"
        "x-systemd.device-timeout=30s"
      ];
    };
  };
}