{
  dconf.settings = {
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
      experimental-features = [ "scale-monitor-framebuffer" ];
      overlay-key = "Super_L";
      workspaces-only-on-primary = false;
    };
  };
}