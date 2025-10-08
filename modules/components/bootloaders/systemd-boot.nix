{
  config,
  options,
  lib,
  ...
}:
{

  options = {
    target.boot.loader.systemd-boot.extraConfig = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "Extra configuration lines for systemd-boot loader.conf";
    };
    customization = {
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
    {
      boot.loader.systemd-boot = {
        enable = true;
        configurationLimit = lib.mkDefault 5;
        consoleMode = lib.mkDefault "max";
      };
      boot.loader.timeout = lib.mkDefault customization.bootloader.timeout;
      boot.loader.efi.canTouchEfiVariables = true;
    };
}
