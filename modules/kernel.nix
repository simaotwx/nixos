{ config, lib, ... }:
let customization = config.customization;
in
{
  options = {
    customization.kernel = {
      sysrq.enable = lib.mkEnableOption "SysRq key";
    };
  };

  config = {
    boot = {
      kernelParams =
        lib.optionals customization.hardware.firmware.supportsEfi [ "add_efi_memmap" ] ++
        lib.optionals customization.kernel.sysrq.enable [ "sysrq_always_enabled=1" ] ++
        [];
    };
  };
}