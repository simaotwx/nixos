{ lib, osConfig, ... }:
{
  dconf.settings = lib.optionalAttrs (osConfig.services.xserver.desktopManager.gnome.enable) (
    with lib.hm.gvariant;
    {
      "org/gnome/shell/app-switcher" = {
        current-workspace-only = true;
      };
      "org/gnome/shell/extensions/caffeine" = {
        indicator-position-max = 1;
        show-notifications = false;
      };
      "org/gnome/shell/extensions/clipboard-indicator" = {
        cache-size = 10;
        disable-down-arrow = true;
        display-mode = 0;
        history-size = 500;
        move-item-first = false;
        notify-on-copy = false;
        preview-size = 30;
        refresh-interval = 1000;
      };
      "org/gnome/shell/extensions/dash-to-dock" = {
        animation-time = 0.2;
        apply-custom-theme = false;
        background-color = "rgb(18,18,18)";
        background-opacity = 0.36;
        custom-background-color = true;
        custom-theme-customize-running-dots = true;
        custom-theme-running-dots = true;
        custom-theme-running-dots-border-color = "#2e3436";
        custom-theme-running-dots-border-width = 1;
        custom-theme-running-dots-color = "#ffffff";
        custom-theme-shrink = true;
        customize-alphas = true;
        dance-urgent-applications = false;
        dash-max-icon-size = 48;
        disable-overview-on-startup = true;
        dock-position = "BOTTOM";
        extend-height = false;
        force-straight-corner = true;
        height-fraction = 0.9;
        hide-delay = 0.5;
        icon-size-fixed = false;
        intellihide-mode = "ALL_WINDOWS";
        isolate-workspaces = true;
        max-alpha = 0.4;
        min-alpha = 0.0;
        multi-monitor = true;
        preferred-monitor = -2;
        pressure-threshold = 150.0;
        preview-size-scale = 0.1;
        running-indicator-dominant-color = false;
        running-indicator-style = "DOTS";
        show-icons-emblems = false;
        show-mounts = false;
        show-show-apps-button = false;
        show-trash = false;
        show-windows-preview = true;
        transparency-mode = "DYNAMIC";
        unity-backlit-items = false;
      };
      "org/gnome/shell/extensions/vitals" = {
        fixed-widths = true;
        hide-zeros = false;
        hot-sensors = [
          "_memory_allocated_"
          "_processor_usage_"
          "__network-tx_max__"
          "__network-rx_max__"
        ];
        position-in-panel = 0;
        show-battery = true;
        storage-measurement = 0;
        update-time = 1;
        use-higher-precision = true;
      };
      "org/gnome/shell/window-switcher" = {
        app-icon-mode = "both";
      };
      "org/gnome/mutter" = {
        edge-tiling = true;
        attach-modal-dialogs = false;
        experimental-features = [
          "scale-monitor-framebuffer"
          "xwayland-native-scaling"
        ];
        overlay-key = "Super_L";
        workspaces-only-on-primary = false;
      };
      "org/gnome/desktop/input-sources" = {
        show-all-sources = true;
        sources = [
          (mkTuple [
            "xkb"
            "de"
          ])
          (mkTuple [
            "xkb"
            "us"
          ])
        ];
        mru-sources = [
          (mkTuple [
            "xkb"
            "de"
          ])
          (mkTuple [
            "xkb"
            "us"
          ])
        ];
        per-window = false;
        xkb-options = [
          "terminate:ctrl_alt_bksp"
          "lv3:rwin_switch"
        ];
      };
      "org/gnome/desktop/media-handling" = {
        automount = false;
        autorun-never = true;
      };
    }
  );
}
