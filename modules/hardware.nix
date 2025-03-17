{ lib, config, ... }: {
  options = {
    customization = {
      hardware = {
        cpu.cores = lib.mkOption {
          type = lib.types.ints.positive;
          # We will assume a generous 4 cores if this value is not set anywhere.
          default = 4;
          description = "How many physical CPU cores your machine has";
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
      };
    };
  };
}