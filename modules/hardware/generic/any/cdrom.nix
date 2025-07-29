{ config, lib, ... }:
{
  users.users = lib.genAttrs config.configurableUsers (username: {
    extraGroups = [ "cdrom" ];
  });
  boot.kernelModules = [ "sg" ];
}
