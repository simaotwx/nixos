{ modulesPath, lib, ... }: {
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
  ];

  boot.supportedFilesystems = lib.mkForce [];
  boot.extraModulePackages = [];
  customization = {
    hardware = {
      cpu.cores = 1;
    };
    general = {
      hostName = "vm-test";
      keymap = "de";
    };
    kernel = {
      sysrq.enable = true;
    };
    security = {
      network.enable = true;
      hardware.enable = true;
      kernel.enable = true;
      fs.enable = true;
      userspace.enable = true;
    };
    services = {
      printing = true;
      scanning = true;
      networkDiscovery = true;
    };
  };
}