{
  pkgs,
  flakePath,
  foundrixModules,
  ...
}:
{
  imports = [
    ./dconf.nix
    ./gtk.nix
    ./packages.nix
    ./qt.nix
    "${flakePath}/modules/components/home/vscode.nix"
    ./xdg.nix
    foundrixModules.home.htop
    foundrixModules.home.direnv
  ];

  home = {
    pointerCursor = {
      package = pkgs.rose-pine-cursor;
      gtk.enable = true;
      name = "BreezeX-RosePine-Linux";
      size = 28;
    };
    language = {
      base = "de_DE.UTF-8";
      measurement = "de_DE.UTF-8";
      monetary = "de_DE.UTF-8";
      name = "de_DE.UTF-8";
      paper = "de_DE.UTF-8";
      time = "de_DE.UTF-8";
    };
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      LIBVIRT_DEFAULT_URI = "qemu:///system";
      NIXOS_OZONE_WL = "1";
    };
  };
  services.gnome-keyring.enable = true;

  home.stateVersion = "25.05";
}
