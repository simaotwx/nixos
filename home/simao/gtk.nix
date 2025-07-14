{ pkgs, ... }: rec {
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
    };
    cursorTheme = {
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePine-Linux";
      size = 24;
    };
    font = {
      package = pkgs.adwaita-fonts;
      name = "Adwaita Sans";
      size = 11;
    };
    iconTheme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita";
    };
    gtk2.extraConfig = ''
      gtk-theme-name = "Adwaita"
    '';
    gtk3 = {
      extraConfig = {
        gtk-toolbar-style = "GTK_TOOLBAR_ICONS";
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "rgb";
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = gtk.theme.name;
      color-scheme = "prefer-dark";
    };
  };
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
  ];
}