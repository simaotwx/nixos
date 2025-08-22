{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.unstable; [
    goose-cli
  ];
}
