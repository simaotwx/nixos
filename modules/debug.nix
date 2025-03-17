{ lib, config, ... }: {
  options = {
    customization = {
      debug.enable = lib.mkEnableOption "debugging";
    };
  };

  config =
  let customization = config.customization;
  in
  {
    boot.initrd.verbose = customization.debug.enable;
  };
}