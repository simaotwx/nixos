{ lib, options, config, ... }: {
  options = {
    customization = {
      nix.enable = (lib.mkEnableOption "nix module") // {
        default = true;
      };
      nix.autoGc = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = options.nix.gc.automatic.description;
      };
    };
  };
  config =
  let
    customization = config.customization;
  in
  lib.mkMerge [(lib.mkIf customization.nix.enable {
    nix = {
      gc = {
        automatic = customization.nix.autoGc;
        dates = lib.mkDefault "weekly";
        options = lib.mkDefault "--delete-older-than 60d";
      };
      settings = {
        max-jobs = lib.mkDefault 4;
        cores = customization.hardware.cpu.threads;
      };
    };
  }) {
    # Do not disable flakes, otherwise you won't be able to use this
    # configuration amyore.
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
  }];
}