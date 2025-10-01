{
  lib,
  config,
  ...
}:
{
  system.stateVersion = lib.mkDefault "25.05";

  boot.tmp = {
    useTmpfs = !config.customization.hardware.mem.lowMemory;
  };
}
