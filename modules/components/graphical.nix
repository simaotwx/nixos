{ lib, ... }:
{
  fonts.fontDir.enable = lib.mkDefault true;
  gtk.iconCache.enable = lib.mkDefault true;
  services.libinput.enable = lib.mkDefault true;
}
