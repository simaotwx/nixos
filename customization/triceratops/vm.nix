{ lib, modulesPath, flakePath, ... }: {
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
    ../vm-common.nix
    "${flakePath}/modules/components/linux-nitrous.nix"
  ];

  boot.supportedFilesystems = lib.mkForce [];
  boot.extraModulePackages = [];
  services.timesyncd.enable = lib.mkForce false;
  customization.hardware.cpu.cores = lib.mkForce 4;
}