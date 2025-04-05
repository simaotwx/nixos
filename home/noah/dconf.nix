{
  dconf.settings = {
    "org/gnome/shell/extensions/vitals" = {
      fixed-widths = false;
      hot-sensors = [
        "_temperature_k10temp_tctl_"
        "_temperature_amdgpu_junction_"
        "_memory_usage_"
        "_processor_frequency_"
        "__network-rx_max__"
        "__network-tx_max__"
      ];
      menu-centered = false;
      position-in-panel = 0;
      show-fan = false;
      show-storage = false;
      show-system = false;
      show-voltage = false;
      update-time = 1;
      use-higher-precision = true;
    };
    "org/gnome/mutter" = {
      edge-tiling = true;
      experimental-features = [ "scale-monitor-framebuffer" ];
      center-new-windows = true;
      dynamic-workspaces = true;
      workspaces-only-on-primary = true;
    };
    "org/gnome/shell/extensions/caffeine" = {
      indicator-position-max = 1;
    };
    "org/gnome/shell/extensions/spotify-controls" = {
      position = "leftmost-right";
    };
    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };
    "org/gnome/desktop/peripherals/keyboard" = {
      numlock-state = true;
    };
    "org/gnome/desktop/interface" = {
      accent-color = "blue";
      clock-show-date = false;
      clock-show-seconds = true;
      color-scheme = "prefer-dark";
    };
    "org/gnome/shell" = {
      favorite-apps = [
        "signal-desktop.desktop"
        "vesktop.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Console.desktop"
        "codium.desktop"
        "zen-beta.desktop"
        "idea-community.desktop"
        "steam.desktop"
        "spotify.desktop"
      ];
      last-selected-power-profile = "performance";
    };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-schedule-automatic = false;
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };
  };
}