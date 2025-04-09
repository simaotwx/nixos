{
  boot.supportedFilesystems = {
    btrfs = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-partlabel/system";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=no" "noatime" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/E8EC-B683";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };
}