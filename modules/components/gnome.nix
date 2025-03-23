{ pkgs, lib, config, ... }: {
  options = {
    customization = {
      desktop.gnome.configure.users = lib.mkOption {
        type = with lib.types; listOf str;
        default = config.configurableUsers;
        description = "Which users to apply gnome configuration to. Defaults to all users.";
      };
      desktop.gnome.useGdm = lib.mkEnableOption "whether to use GDM" // {
        default = true;
      };
      desktop.gnome.extensions = lib.mkOption {
        type = with lib.types; listOf package;
        default = [];
        description = "Extension packages to install and enable";
      };
    };
  };

  config = {
    home-manager.users = lib.genAttrs config.customization.desktop.gnome.configure.users (username: {
      xdg.portal.config = {
        common = {
          default = [
            "gnome"
            "gtk"
          ];
        };
      };
      xdg.portal.extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
      home.packages = config.customization.desktop.gnome.extensions;
      dconf = {
        settings."org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = lib.map (
            package: package.extensionUuid
          ) config.customization.desktop.gnome.extensions;
        };
      };
    });
    services.xserver.displayManager.gdm.enable = config.customization.desktop.gnome.useGdm;
    services.xserver.desktopManager.gnome.enable = true;
    nixpkgs.overlays = [
      (final: prev: {
        spotify = prev.spotify.overrideAttrs (finalAttrs: prevAttrs: {
          fixupPhase = builtins.replaceStrings [
            ''--add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime=true''
            ''--add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland}}"''
          ] ["" ""] prevAttrs.fixupPhase;
        });
      })
    ];
  };
}