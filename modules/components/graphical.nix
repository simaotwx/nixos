{ lib, flakePath, ... }:
{
  imports = [
    # It just makes sense to have this around so that you can enter your password
    "${flakePath}/modules/components/gnupg.nix"
  ];

  fonts.fontDir.enable = lib.mkDefault true;
  gtk.iconCache.enable = lib.mkDefault true;
  services.libinput.enable = lib.mkDefault true;
}
