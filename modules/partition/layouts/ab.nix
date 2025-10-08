{
  lib,
  ...
}:
{
  config = {
    # Add store-empty partition for A/B updates
    image.repart.partitions."25-store-empty" = {
      repartConfig = {
        Type = "root";
        UUID = lib.toLower "00000000-0000-4000-9000-000000000250";
        Label = "_empty";
        Minimize = "off";
        SizeMinBytes = "16G";
        SplitName = "-";
      };
    };

    # Add B-slot targets for systemd-sysupdate A/B updates
    systemd.sysupdate.transfers."10-uki-remote".Target.InstancesMax = 2;
    systemd.sysupdate.transfers."20-store-remote".Target.InstancesMax = 2;
  };
}
