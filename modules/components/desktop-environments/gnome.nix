{
  pkgs,
  lib,
  config,
  mkConfigurableUsersOptionOld,
  forEachUser,
  ...
}:
{
  options = {
    customization = {
      desktop.gnome.configure.users = mkConfigurableUsersOptionOld {
        description = "Which users to apply gnome configuration to. Defaults to all users.";
      };
      desktop.gnome.useGdm = lib.mkEnableOption "whether to use GDM" // {
        default = true;
      };
      desktop.gnome.extensions = lib.mkOption {
        type = with lib.types; listOf package;
        default = [ ];
        description = "Extension packages to install and enable";
      };
    };
  };

  config = {
    home-manager.users = forEachUser config.customization.desktop.gnome.configure.users {
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
      home.packages = config.customization.desktop.gnome.extensions ++ [
        pkgs.gnome-tweaks
      ];
      dconf = {
        settings."org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = lib.map (
            package: package.extensionUuid
          ) config.customization.desktop.gnome.extensions;
        };
      };
    };
    services.gnome.gnome-keyring.enable = true;
    services.xserver.displayManager.gdm.enable = config.customization.desktop.gnome.useGdm;
    services.xserver.desktopManager.gnome.enable = true;
    nixpkgs.overlays = [
      (
        final: prev:
        let
          fixSpotify =
            spotify:
            spotify.overrideAttrs (
              finalAttrs: prevAttrs: {
                fixupPhase =
                  builtins.replaceStrings
                    [
                      ''--add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime=true}}"''
                      ''--add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland}}"''
                    ]
                    [ "" "" ]
                    prevAttrs.fixupPhase;
              }
            );
        in
        {
          spotify = fixSpotify prev.spotify;
          unstable.spotify = fixSpotify prev.unstable.spotify;
        }
      )
      (final: prev: {
        mattermost-desktop = prev.mattermost-desktop.overrideAttrs (
          finalAttrs: prevAttrs: {
            installPhase =
              builtins.replaceStrings
                [ "--enable-features" ]
                [
                  "--disable-features=GlobalShortcutsPortal --enable-features"
                ]
                prevAttrs.installPhase;
          }
        );
      })
    ];
  };
}
