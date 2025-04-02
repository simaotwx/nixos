{
  boot.initrd.luks = {
    devices."main" = {
      device = "/dev/disk/by-uuid/21f1ebd8-81cd-4d73-9148-976a47c5225e";
    };
  };

  boot.supportedFilesystems = {
    btrfs = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/main";
      fsType = "btrfs";
      options = [ "subvol=@nixos" "compress=no" "noatime" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/F4B1-B260";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" "codepage=437" "iocharset=iso8859-1" "shortname=mixed" "utf8" "errors=remount-ro" ];
    };

    "/home" = {
      device = "/dev/mapper/main";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=no" "noatime" ];
    };
  };
}