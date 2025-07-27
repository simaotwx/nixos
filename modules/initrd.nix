{ config, lib, ... }:
let
  customization = config.customization;
in
{
  boot.initrd = {
    availableKernelModules =
      lib.optionals customization.hardware.storage.hasNvme [ "nvme" ]
      ++ lib.optionals customization.hardware.io.hasUsb [
        "usb_storage"
        "usbhid"
        "xhci_pci"
      ]
      ++ [ "sd_mod" ];
    systemd.enable = true;
  };
}
