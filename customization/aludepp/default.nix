{ inputs, ... }: {
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc
    common-cpu-amd
    common-cpu-amd-pstate
    common-gpu-amd
    common-pc-ssd
    ./common.nix
    ./filesystems.nix
    ../../machines/x86_64
    ../../modules/components/linux-nitrous.nix
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
    compat.enable = true;
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
    peripherals = {
      via.enable = true;
      razer.enable = true;
    };
    shells.zsh.lite.enable = true;
    shell.simaosSuite.enable = true;
  };

  # Support for Crush 80 wireless
  services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="320f", ATTRS{idProduct}=="5088", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  security.pki.certificateFiles = [
    ../../local/certificates/at2.crt
  ];

  services.timesyncd.enable = true;
}