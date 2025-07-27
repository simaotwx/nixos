{
  boot.initrd.luks = {
    devices."main" = {
      device = "/dev/disk/by-uuid/df437e2d-4e95-4439-a70b-2e251c6b6549";
    };
  };

  boot.supportedFilesystems = {
    btrfs = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/c5145846-61de-46d5-b2e4-a96dad352de5";
      fsType = "btrfs";
      options = [
        "subvol=@nixos"
        "compress=no"
        "noatime"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/E8EC-B683";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/c5145846-61de-46d5-b2e4-a96dad352de5";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "compress=lzo"
        "noatime"
      ];
    };

    "/mnt/games" = {
      device = "/dev/disk/by-label/games";
      fsType = "btrfs";
      options = [
        "rw"
        "noatime"
        "nosuid"
        "nodev"
        "nofail"
        "compress=no"
        "subvol=@games"
      ];
    };

    "/mnt/romsrc" = {
      device = "/dev/disk/by-label/romsrc";
      fsType = "btrfs";
      options = [
        "rw"
        "noatime"
        "nosuid"
        "nodev"
        "nofail"
        "compress=no"
      ];
    };

    "/mnt/romout" = {
      device = "/dev/disk/by-partlabel/romout";
      fsType = "btrfs";
      options = [
        "rw"
        "noatime"
        "nosuid"
        "nodev"
        "nofail"
        "compress=no"
      ];
    };
  };
}
