{
  pkgs,
  lib,
  config,
  ...
}:
{
  _module.args.appleGpuSupport = true;
  hardware.graphics.enable32Bit = lib.mkForce false;
  hardware.asahi.extractPeripheralFirmware =
    config.hardware.asahi.peripheralFirmwareDirectory != null;
  environment.systemPackages = with pkgs; [
    asahi-btsync
    asahi-wifisync
    asahi-bless
    asahi-nvram
  ];
}
