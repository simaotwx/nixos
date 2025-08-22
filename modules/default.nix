{ lib, inputs, pkgs, config, ... }:
{
  imports = [
    ./base.nix
    ./commands.nix
    ./console.nix
    ./debug.nix
    ./general.nix
    ./hardware.nix
    ./initrd.nix
    ./kernel.nix
    ./nix.nix
    ./performance.nix
    ./security.nix
    ./services.nix
    ./lib.nix
  ];

  options = {
    configurableUsers = lib.mkOption {
      type = with lib.types; listOf str;
      description = "This will be set automatically if you use the predefined home manager stuff";
      default = [ ];
    };
  };

  config = {
    nixpkgs.overlays = [
      (final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (prev) system;
          config = config.nixpkgs.config;
        };
      })
    ];

    _module.args.pkgsUnstable =
      builtins.warn "DEPRECATED: use pkgs.unstable.<pkg> instead of pkgsUnstable"
        pkgs.unstable;
  };
}
