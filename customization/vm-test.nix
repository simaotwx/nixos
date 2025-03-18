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
    peripherals = {
      via.enable = true;
      razer.enable = true;
    };
    shells.zsh.lite.enable = true;
    shell.simaosSuite.enable = true;
  };

  users.allowNoPasswordLogin = true;
  services.getty.autologinUser = "root";
}