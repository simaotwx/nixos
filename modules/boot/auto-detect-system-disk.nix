{
  lib,
  ...
}:
{
  config = {
    # Use systemd-repart's built-in device detection by not setting a specific device
    # This makes systemd-repart automatically operate on the device backing the root partition
    boot.initrd.systemd.repart.device = lib.mkDefault null;
  };
}