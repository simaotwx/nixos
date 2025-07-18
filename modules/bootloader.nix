{ config, options, lib, pkgs, ... }: {
  options = {
    customization = {
      bootloader.enable = (lib.mkEnableOption "bootloader module") // {
        default = true;
      };
      bootloader.choice = lib.mkOption {
        type = lib.types.enum ({
          "x86_64-linux" = [ "systemd-boot" ];
          "aarch64-linux" = [ "systemd-boot" ];
        }.${pkgs.system} or []);
        description = "Choose the bootloader you'd like to use.";
        default = {
          "x86_64-linux" = "systemd-boot";
          "aarch64-linux" = "systemd-boot";
        }.${pkgs.system} or null;
      };
      bootloader.timeout = lib.mkOption {
        type = options.boot.loader.timeout.type;
        description = options.boot.loader.timeout.description;
        default = 1;
      };
    };
  };

  config =
  let
    customization = config.customization;
  in
  lib.mkIf customization.bootloader.enable {
    boot.loader.systemd-boot = lib.mkIf (customization.bootloader.choice == "systemd-boot") {
      enable = true;
      configurationLimit = lib.mkDefault 5;
      consoleMode = lib.mkDefault "max";
    };
    boot.loader.timeout = lib.mkDefault customization.bootloader.timeout;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}