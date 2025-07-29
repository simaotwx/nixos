{
  config,
  options,
  lib,
  ...
}:
{
  options = {
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
