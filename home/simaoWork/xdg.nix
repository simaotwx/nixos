{ config, ... }: {
  xdg = {
    enable = true;
    mimeApps.enable = true;
    mimeApps.associations = {
      added = {
        "application/pdf" = "org.gnome.Evince.desktop";
        "text/html" = "firefox.desktop";
        "text/x-log" = "org.gnome.gedit.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "image/png" = "org.gnome.Loupe.desktop";
        "image/jpg" = "org.gnome.Loupe.desktop";
        "image/jpeg" = "org.gnome.Loupe.desktop";
        "image/gif" = "org.gnome.Loupe.desktop";
        "audio/aac" = "io.github.celluloid_player.Celluloid.desktop";
        "audio/flac" = "io.github.celluloid_player.Celluloid.desktop";
        "audio/ogg" = "io.github.celluloid_player.Celluloid.desktop";
        "audio/wav" = "io.github.celluloid_player.Celluloid.desktop";
        "audio/opus" = "io.github.celluloid_player.Celluloid.desktop";
        "application/xml" = "org.gnome.gedit.desktop";
      };
    };
    mimeApps.defaultApplications = config.xdg.mimeApps.associations.added;
    portal.enable = true;
  };
}