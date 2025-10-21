{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./base.nix
    ./debug.nix
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
          overlays = config.nixpkgs-unstable.overlays;
        };
        master = import inputs.nixpkgs-master {
          inherit (prev) system;
          config = config.nixpkgs.config;
          overlays = config.nixpkgs-master.overlays;
        };
        mfc9332cdwcupswrapper = pkgs.callPackage ./components/mfc9332cdw.nix { };
        mfc9332cdwlpr = pkgs.callPackage ./components/mfc9332cdwlpr.nix { };
      })
    ];
  };
}
