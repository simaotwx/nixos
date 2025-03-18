{ inputs, ... }: {
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc
    common-cpu-amd
    common-cpu-amd-pstate
    common-gpu-amd
    common-pc-ssd
  ];

  # Customization of modules
  customization = {
    hardware = {
      cpu.cores = 12;
      storage.hasNvme = true;
    };
    general = {
      hostName = "aludepp";
      timeZone = "Europe/Berlin";
      defaultLocale = "en_US.UTF-8";
      keymap = "de";
    };
    graphics =  {
      amd.enable = true;
      amd.overclocking.unlock = true;
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
    sound = {
      lowLatency = true;
    };
    storage =  {
      hasNvme = true;
    };
    peripherals = {
      via.enable = true;
      razer.enable = true;
    };
    shells.zsh.lite.enable = true;
    shell.simaosSuite.enable = true;
  };

  # Additional configuration
  i18n.supportedLocales = [
    "C.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
    "en_GB.UTF-8/UTF-8"
    "de_DE.UTF-8/UTF-8"
  ];

  services.fwupd.enable = true;
}