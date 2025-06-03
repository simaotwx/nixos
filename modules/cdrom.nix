{ config, lib, ... }: lib.mkIf config.customization.hardware.io.hasOpticalDrive {
  users.users = lib.genAttrs config.configurableUsers (username: {
    extraGroups = [ "cdrom" ];
  });
  boot.kernelModules = [ "sg" ];
}