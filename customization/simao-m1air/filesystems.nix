{
  boot.supportedFilesystems = {
    btrfs = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/07d3f329-5ec2-41f7-b1b4-23d83cc3862c";
    fsType = "btrfs";
    options = [
      "compress=no"
      "noatime"
    ];
  };

  boot.initrd.luks.devices."main".device = "/dev/disk/by-uuid/54735616-d99b-4d42-8302-4411233bccff";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/72AF-1DFA";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

}
