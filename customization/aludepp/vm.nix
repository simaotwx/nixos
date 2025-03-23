{ lib, modulesPath, ... }: {
  imports = [
    ./common.nix
    "${modulesPath}/profiles/qemu-guest.nix"
    ../vm-common.nix
  ];

  boot.supportedFilesystems = lib.mkForce [];
  boot.extraModulePackages = [];
  # Customization of modules
  customization = lib.mkForce {
    hardware.cpu.cores = 12;
    general = {
      hostName = "aludepp";
      timeZone = "Europe/Berlin";
      defaultLocale = "en_US.UTF-8";
      keymap = "de";
    };
    kernel.sysrq.enable = true;
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
    shells.zsh.lite.enable = true;
    shell.simaosSuite.enable = true;
  };
}