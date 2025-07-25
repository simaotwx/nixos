{
  pkgs,
  flakePath,
  lib,
  osConfig,
  ...
}:
{
  imports = [
    ./dconf.nix
    ./direnv.nix
    ./gtk.nix
    ./htop.nix
    ./packages.nix
    ./qt.nix
    "${flakePath}/modules/components/home/vscode.nix"
    ./xdg.nix
  ];

  home = {
    pointerCursor = {
      package = pkgs.rose-pine-cursor;
      gtk.enable = true;
      name = "BreezeX-RosePine-Linux";
      size = 24;
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
      MOZ_WAYLAND = "1";
      MOZ_DBUS_REMOTE = "1";
      MOZ_USE_XINPUT2 = "1";
      LIBVIRT_DEFAULT_URI = "qemu:///system";
      NIXOS_OZONE_WL = "1";
    };
  };

  services.gnome-keyring.enable = true;

  home.stateVersion = "25.05";

  programs = lib.optionalAttrs osConfig.services.xserver.desktopManager.gnome.enable {
    alacritty.settings.window.decorations = lib.mkForce "Full";
    alacritty.settings.window.opacity = lib.mkForce 0.8;
  };

  dconf.settings."org/gnome/desktop/input-sources" =
    lib.optionalAttrs osConfig.services.xserver.desktopManager.gnome.enable
      (
        with lib.hm.gvariant;
        {
          sources = lib.mkForce [
            (mkTuple [
              "xkb"
              "us"
            ])
          ];
          mru-sources = lib.mkForce [
            (mkTuple [
              "xkb"
              "us"
            ])
          ];
        }
      );
}
