{ lib, ...}: {
  imports = [
    ./boot.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
