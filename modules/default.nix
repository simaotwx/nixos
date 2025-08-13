{ lib, ... }:
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
    ./compat.nix
    ./lib.nix
  ];

  options = {
    configurableUsers = lib.mkOption {
      type = with lib.types; listOf str;
      description = "This will be set automatically if you use the predefined home manager stuff";
      default = [ ];
    };
  };
}
