{ config, pkgsUnstable, pkgs, ... }: {
  imports = [
    ./gpu.nix
  ];

  _module.args.rocmPackages =
    if config.customization.graphics.amd.latestMesa then pkgsUnstable.rocmPackages else pkgs.rocmPackages;
}