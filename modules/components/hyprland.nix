{ pkgs, lib, config, ... }: {
  options = {
    customization = {
      desktop.hyprland.enable = lib.mkEnableOption "Hyprland";
      desktop.hyprland.configure.users = lib.mkOption {
        type = with lib.types; listOf str;
        default = config.configurableUsers;
        description = "Which users to apply hyprland configuration to. Defaults to all users.";
      };
    };
  };

  config = lib.mkIf config.customization.desktop.hyprland.enable {
    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
    programs = {
      hyprland = {
        enable = true;
        xwayland.enable = true;
        package = pkgs.hyprland;
        portalPackage = pkgs.xdg-desktop-portal-hyprland;
      };
    };
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal";
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    home-manager.users = lib.genAttrs config.customization.desktop.hyprland.configure.users (username: {
      xdg.portal.extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
      xdg.portal.config = {
        common = {
          default = [
            "hyprland"
            "gtk"
          ];
        };
      };
    });
  };
}