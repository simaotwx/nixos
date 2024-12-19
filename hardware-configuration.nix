{ config, lib, pkgs, modulesPath, ... }:

let
  nixos-hardware = builtins.fetchTarball "https://github.com/NixOS/nixos-hardware/archive/f7e31ff8efd7d450c3a9c6379963f333f32889a8.tar.gz";
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    "${nixos-hardware}/common/cpu/amd/default.nix"
    "${nixos-hardware}/common/cpu/amd/pstate.nix"
    "${nixos-hardware}/common/gpu/amd/default.nix"
    "${nixos-hardware}/common/pc/ssd/default.nix"
  ];

  boot.initrd = {
    availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "uas" "sd_mod" ];
    kernelModules = [ ];
    luks = {
      devices."main" = {
        device = "/dev/disk/by-uuid/df437e2d-4e95-4439-a70b-2e251c6b6549";
      };
    };
    systemd.enable = true;
  };
  boot.kernelModules = [ "kvm-amd" "sg" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [ 
    "add_efi_memmap" "amdgpu.ppfeaturemask=0xfff7ffff" "sysrq_always_enabled=1"
  ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/c5145846-61de-46d5-b2e4-a96dad352de5";
      fsType = "btrfs";
      options = [ "subvol=@nixos" "compress=no" "noatime" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/E8EC-B683";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/c5145846-61de-46d5-b2e4-a96dad352de5";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=lzo" "noatime" ];
    };

  fileSystems."/mnt/extension1" = {
    device = "/dev/disk/by-uuid/bd955d0e-727d-4095-8364-30f5d64aea9c";
    fsType = "xfs";
    options = [ "rw" "noatime" "nosuid" "nodev" "nofail" ];
  };

  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-label/games";
    fsType = "btrfs";
    options = [ "rw" "noatime" "nosuid" "nodev" "nofail" "compress=no" "subvol=@games" ];
  };

  swapDevices = [ ];

  services.udev = {
    packages = [
      pkgs.g810-led
    ];
    extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", RUN+="${pkgs.g810-led}/bin/g810-led -p /home/simao/.config/g810-led-profile"
    '';
  };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.amdgpu.amdvlk = {
    enable = false;
    support32Bit.enable = false;
  };
  hardware.amdgpu.initrd.enable = true;
  hardware.amdgpu.opencl.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      #amdvlk
      rocmPackages.clr.icd
    ];
    extraPackages32 = with pkgs; [
      #driversi686Linux.amdvlk
    ];
  };

  hardware.openrazer.enable = true;
  hardware.openrazer.users = [ "simao" ];

  hardware.sane.enable = true;

  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;

  environment.variables = {
    NIX_BUILD_CORES = "24";
    AMD_VULKAN_ICD = "RADV";
  };
}
