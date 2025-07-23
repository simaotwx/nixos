{
  lib,
  config,
  pkgs,
  pkgsUnstable,
  ...
}:
{
  options = {
    customization = {
      hardware = {
        cpu.cores = lib.mkOption {
          type = lib.types.ints.positive;
          # We will assume a generous 4 cores if this value is not set anywhere.
          default = 4;
          description = "How many physical CPU cores your machine has";
        };
        cpu.vendor = lib.mkOption {
          type = lib.types.enum [
            "amd"
            "intel"
            "transmeta"
            "idt"
            "via"
            "apple"
            "qcom"
            "rockchip"
            "allwinner"
            "broadcom"
            "mediatek"
            "nxp"
            "samsung"
          ];
          default = "";
          description = "Vendor of your CPU";
        };
        cpu.threads = lib.mkOption {
          type = lib.types.ints.positive;
          # We will assume the CPU has SMP.
          default = config.customization.hardware.cpu.cores * 2;
          description = "How many logical CPU threads your machine has";
        };
        mem.lowMemory = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether the system shall be configured to work on low memory devices";
        };
        storage.hasNvme = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether the system shall be equipped with necessary drivers and support for NVMe";
        };
        io.hasUsb = lib.mkOption {
          type = lib.types.bool;
          # I think it's a sensible default to assume USB support
          default = true;
          description = "Whether the system shall be set up to support USB, even in initrd.";
        };
        io.hasOpticalDrive = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to add support for optical drives";
        };
        board.ahci.enable = lib.mkOption {
          type = lib.types.bool;
          default = pkgs.system == "x86_64-linux";
          description = "Whether the system shall be set up to support AHCI";
        };
        firmware.supportsEfi = lib.mkOption {
          type = lib.types.bool;
          # Assume EFI is supported on x86_64
          default = pkgs.system == "x86_64-linux";
          description = "Whether the system shall be set up to support and use EFI features";
        };
        graphics.latestMesa = lib.mkEnableOption "latest mesa from nixos-unstable";
      };
    };
  };

  config = {
    hardware.graphics = lib.optionalAttrs config.customization.hardware.graphics.latestMesa {
      package = pkgsUnstable.mesa;
      package32 = lib.mkIf config.hardware.graphics.enable32Bit pkgsUnstable.driversi686Linux.mesa;
    };

    nixpkgs.overlays = lib.optional config.customization.hardware.graphics.latestMesa (
      _: _: { mesa = pkgsUnstable.mesa; }
    );
  };
}
