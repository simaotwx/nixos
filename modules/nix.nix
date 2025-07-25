{
  lib,
  options,
  config,
  ...
}:
{
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
      nix.buildDirOnTmp = lib.mkEnableOption "storing build directories on /tmp which is usually a tmpfs";
    };
  };
  config =
    let
      customization = config.customization;
    in
    lib.mkMerge [
      (lib.mkIf customization.nix.enable {
        system.rebuild.enableNg = true;
        nix = {
          enable = lib.mkForce true;
          gc = {
            automatic = customization.nix.autoGc;
            dates = lib.mkDefault "weekly";
            options = lib.mkDefault "--delete-older-than 60d";
          };
          settings = {
            max-jobs = lib.mkDefault 4;
            cores = customization.hardware.cpu.threads;
            build-dir = if customization.nix.buildDirOnTmp then "/tmp" else "/var/tmp";
          };
          extraOptions = ''
            min-free = ${toString (4096 * 1024 * 1024)}
            max-free = ${toString (8192 * 1024 * 1024)}
          '';
        };
      })
      {
        # Do not disable flakes, otherwise you won't be able to use this
        # configuration amyore.
        nix.settings.experimental-features = [
          "nix-command"
          "flakes"
        ];
      }
    ];
}
