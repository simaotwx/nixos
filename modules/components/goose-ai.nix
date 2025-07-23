{ pkgsUnstable, ... }:
{
  environment.systemPackages = with pkgsUnstable; [
    goose-cli
  ];
}
