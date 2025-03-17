{ modulesPath, ... }: {
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
  ];

  customization = {
    hardware = {
      cpu.cores = 1;
    };
    general = {
      hostName = "vm-test";
      keymap = "de";
    };
    security = {
      network.enable = true;
      hardware.enable = true;
      kernel.enable = true;
      fs.enable = true;
      userspace.enable = true;
    };
  };
}