{ pkgs, lib, config, flakePath, mkConfigurableUsersOption, forEachUser, ... }: {
  imports = [
    "${flakePath}/modules/components/graphical.nix"
  ];

  options = {
    customization = {
      desktop.hyprland = {
        configure.users = mkConfigurableUsersOption {
          description = "Which users to apply hyprland configuration to. Defaults to all users.";
        };
        monitors = lib.mkOption {
          type = with lib.types; listOf str;
          default = [];
          description = "Monitors to configure, in Hyprland config syntax. By default, it's dynamic.";
        };
        terminal = lib.mkOption {
          type = lib.types.package;
          default = pkgs.alacritty;
          description = "Default terminal application";
        };
        fileManager = lib.mkOption {
          type = lib.types.package;
          default = pkgs.nautilus;
          description = "Default file manager";
        };
        menu = lib.mkOption {
          type = lib.types.package;
          default = pkgs.wofi;
          description = "Default menu application (you probably want to make a custom package)";
        };
        browser = lib.mkOption {
          type = lib.types.package;
          default = pkgs.librewolf;
          description = "Default web browser";
        };
        wallpaper = lib.mkOption {
          type = with lib.types; nullOr package;
          default = null;
          description = "Wallpaper engine, like wpaperd (you probably want to make a custom package)";
        };
        topbar = lib.mkOption {
          type = with lib.types; nullOr package;
          default = null;
          description = "Topbar package to use (you probably want to make a custom package)";
        };
        execOnce = lib.mkOption {
          type = with lib.types; listOf str;
          default = [];
          description = "Additional exec-once statements";
        };
        mainMod = lib.mkOption {
          type = lib.types.str;
          default = "SUPER";
          description = "Default modifier key (usuallay SUPER)";
        };
      };
    };
  };

  config = let cfg = config.customization.desktop.hyprland; in {
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

    home-manager.users = forEachUser cfg.configure.users {
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
      wayland.windowManager.hyprland.settings =
      let
        wlPaste = lib.getExe' pkgs.wl-clipboard "wl-paste";
        cliphist = lib.getExe pkgs.cliphist;
        polkitKdeAgent = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
        polkitAuthAgentScript = pkgs.writeShellScript "polkit-auth-agent" ''
          while ! "${polkitKdeAgent}"; do
            sleep 5
          done
        '';
        loginctl = lib.getExe' pkgs.systemd "loginctl";
        ydotool = lib.getExe pkgs.ydotool;
      in
      {
        env = [
          "XCURSOR_SIZE,32"
          "HYPRCURSOR_SIZE,28"
          "HYPRCURSOR_THEME,rose-pine-hyprcursor"
        ];
        monitor = cfg.monitors ++ [
          ",highres,auto,auto"
        ];
        exec-once = [
          #hypridle
          #wpaperd -d
          #eww daemon && eww open topbar
          #gopass sync
          # For text
          "${wlPaste} --type text --watch ${cliphist} store -max-dedupe-search 40 -max-items 100"
          # For images
          "${wlPaste} --type image --watch ${cliphist} store -max-items 100"
          polkitAuthAgentScript
        ] ++ cfg.execOnce;

        input = {
          kb_layout = config.customization.general.keymap;
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";
          repeat_rate = 32;
          repeat_delay = 440;
          follow_mouse = 1;

          touchpad = {
            natural_scroll = true;
            drag_lock = true;
          };

          sensitivity = 0;
        };
        general = {
          gaps_in = 2;
          gaps_out = 4;
          border_size = 2;
          "col.active_border" = "rgba(00b4e7ee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(606060aa)";
          layout = "dwindle";
          resize_on_border = true;
          extend_border_grab_area = 5;
          hover_icon_on_border = false;
          allow_tearing = false;
        };
        decoration = {
          rounding = 7;

          blur = {
              enabled = true;
              size = 3;
              passes = 3;
              noise = 0.01;
              contrast = 0.92;
              brightness = 0.92;
              vibrancy = 0.18;
              vibrancy_darkness = 0.1;
          };

          shadow = {
              enabled = true;
              range = 2;
              render_power = 2;
              color = "rgba(1a1a1a1a)";
              color_inactive = "rgba(1a1a1a9a)";
          };
        };
        animations = {
          enabled = true;

          bezier = "myBezier, 0.05, 0.98, 0.56, 1.02";

          aimation = [
            "windows, 1, 3, myBezier"
            "windowsOut, 1, 3, default, popin 80%"
            "border, 1, 8, default"
            "borderangle, 1, 6, default"
            "fade, 1, 4, default"
            "workspaces, 1, 4, default"
          ];
        };
        dwindle = {
          pseudotile = false;
          preserve_split = true;
        };
        gestures = {
          workspace_swipe = true;
          workspace_swipe_fingers = 3;
        };
        misc = {
          force_default_wallpaper = false;
          new_window_takes_over_fullscreen = 2;
          middle_click_paste = false;
        };
        layerrule = [
          "ignorealpha, topbar"
          "blur, topbar"
        ];
        windowrulev2 = [
          "suppressevent, class:^(Grand Theft Auto V.*)$"
          "fullscreen, class:^(Grand Theft Auto V.*)$"
          "workspace empty, class:^(Grand Theft Auto V.*)$"
          "float, title:^(Picture-in-Picture)$"
          "size 640 360, title:^(Picture-in-Picture)$"
          "float, class:^(org.kde.polkit-kde-authentication-agent.*)$"
        ];
        "$mainMod" = cfg.mainMod;
        bind = [
          "$mainMod, Q, killactive,"
          "$mainMod, V, togglefloating,"
          "$mainMod, R, exec, ${lib.getExe cfg.menu}"
          "$mainMod, M, fullscreen, 1"
          "$mainMod, F, fullscreen, 0"
          "$mainMod SHIFT, Q, exec, hyprctl kill"
          "$mainMod, J, togglesplit,"
          "$mainMod, B, exec, ${lib.getExe cfg.browser}"
          "$mainMod, E, exec, ${lib.getExe cfg.fileManager}"
          "$mainMod, T, exec, ${lib.getExe cfg.terminal}"
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"
          "$mainMod, L, exec, ${loginctl} lock-session"
          "$mainMod, mouse_down, workspace, e-1"
          "$mainMod, mouse_up, workspace, e+1"
          "$mainMod, mouse_left, workspace, e-1"
          "$mainMod, mouse_right, workspace, e+1"
          "ALT SHIFT, KP_Begin, exec, ${ydotool} click C0"
          "ALT SHIFT, KP_Begin, exec, ${ydotool} click C0"
        ];
        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];
      };
    };
  };
}