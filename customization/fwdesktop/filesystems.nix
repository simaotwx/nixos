{
  boot.supportedFilesystems = {
    btrfs = true;
  };

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

    "/nix/tmp" = {
      fsType = "tmpfs";
      options = [
        "size=90%"
        "noatime"
        "mode=0750"
        "uid=0"
        "gid=0"
      ];
    };

    "/nix" = {
      device = "/dev/disk/by-partlabel/main";
      fsType = "btrfs";
      options = [
        "subvol=@nixos"
        "compress=lzo"
        "noatime"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-partlabel/ESP";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
        "noatime"
        "x-systemd.device-timeout=30s"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-partlabel/main";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "compress=lzo"
        "noatime"
      ];
    };

    "/var" = {
      device = "/dev/disk/by-partlabel/main";
      fsType = "btrfs";
      options = [
        "subvol=@var"
        "compress=lzo"
        "noatime"
      ];
    };
  };
}
