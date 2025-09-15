{
  lib,
  config,
  ...
}:
{
  options = {
    target.storage.system.readOnly = lib.mkEnableOption "read-only system storage (immutable OS)";
    
    target.storage.layout.nixStore.device = lib.mkOption {
      type = lib.types.str;
      description = "Device path for /nix/store mount (set by A/B or A-only modules)";
    };
  };

  config = lib.mkIf config.target.storage.system.readOnly {
    fileSystems."/nix/store" = {
      device = config.target.storage.layout.nixStore.device;
      fsType = "erofs";
      options = [
        "noatime"
        "x-systemd.device-timeout=10s"
        "x-systemd.after=initrd-parse-etc.service"
      ];
    };
  };
}