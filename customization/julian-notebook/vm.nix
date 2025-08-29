{ lib, modulesPath, ... }:
{
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
    ../vm-common.nix
  ];

  boot.supportedFilesystems = lib.mkForce [ ];
  boot.extraModulePackages = [ ];
  services.timesyncd.enable = lib.mkForce false;
  customization.hardware.cpu.cores = lib.mkForce 4;
}
