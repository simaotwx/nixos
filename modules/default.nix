{ lib, inputs, config, ... }:
{
  imports = [
    ./base.nix
    ./console.nix
    ./debug.nix
    ./general.nix
    ./hardware.nix
    ./initrd.nix
    ./kernel.nix
    ./nix.nix
    ./security.nix
    ./services.nix
    ./lib.nix
    ./targets
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
        master = import inputs.nixpkgs-master {
          inherit (prev) system;
          config = config.nixpkgs.config;
        };
      })
    ];
  };
}
