{
  boot.initrd.luks = {
    devices."main" = {
      device = "/dev/disk/by-partuuid/e460921e-ffa7-4e23-8a5b-f155619dc2cb";
    };
  };

  boot.supportedFilesystems = {
    btrfs = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/main";
      fsType = "btrfs";
      options = [
        "subvol=@nixos"
        "compress=no"
        "noatime"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/CB90-2DBA";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
        "codepage=437"
        "iocharset=iso8859-1"
        "shortname=mixed"
        "utf8"
        "errors=remount-ro"
      ];
    };

    "/home" = {
      device = "/dev/mapper/main";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "compress=zstd:3"
        "noatime"
      ];
    };

    "/.snapshots" = {
      device = "/dev/mapper/main";
      fsType = "btrfs";
      options = [
        "subvol=@.snapshots"
        "compress=zstd:3"
        "noatime"
      ];
    };
  };
}
