{ pkgs, ... }:
{
  imports = [
    ./packages.nix
    ./gtk.nix
    ./qt.nix
    ./xdg.nix
  ];

  home = {
    pointerCursor = {
      package = pkgs.rose-pine-cursor;
      gtk.enable = true;
      name = "BreezeX-RosePine-Linux";
      size = 28;
    };
    language = {
      base = "en_US.UTF-8";
      measurement = "de_DE.UTF-8";
      monetary = "de_DE.UTF-8";
      name = "en_GB.UTF-8";
      paper = "de_DE.UTF-8";
      time = "en_GB.UTF-8";
    };
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
    };
  };

  home.stateVersion = "24.11";
}
