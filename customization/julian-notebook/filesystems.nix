{
  boot.initrd.luks = {
    devices."main" = {
      device = "/dev/nvme0n1p2";
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
      device = "/dev/disk/by-uuid/BACD-4D6F";
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
        "compress=no"
        "noatime"
      ];
    };
  };
}
