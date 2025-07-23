{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  documentation = {
    enable = mkDefault false;
    doc.enable = mkDefault false;
    info.enable = mkDefault false;
    man.enable = mkDefault false;
    nixos.enable = mkDefault false;
  };

  environment = {
    defaultPackages = mkDefault [ ];
  };

  programs = {
    less.lessopen = mkDefault null;
    command-not-found.enable = mkDefault false;
  };

  boot.enableContainers = mkDefault false;

  services = {
    logrotate.enable = mkDefault false;
    udisks2.enable = mkDefault false;
  };

  system.switch.enable = false;
  boot.initrd.systemd.enable = lib.mkDefault true;
}
