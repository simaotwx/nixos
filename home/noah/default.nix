{ pkgs, ... }: {
  imports = [
    ./direnv.nix
    ./gtk.nix
    ./htop.nix
    ./packages.nix
    ./qt.nix
    ./steam.nix
    ./vscode.nix
    ./xdg.nix
  ];

  home = {
    pointerCursor = {
      package = pkgs.rose-pine-cursor;
      gtk.enable = true;
      name = "BreezeX-RosePine-Linux";
      size = 28;
    };
    language = {
      base = "en_US.UTF-8";
      measurement = "de_DE.UTF-8";
      monetary = "de_DE.UTF-8";
      name = "de_DE.UTF-8";
      paper = "de_DE.UTF-8";
      time = "de_DE.UTF-8";
    };
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      LIBVIRT_DEFAULT_URI = "qemu:///system";
      NIXOS_OZONE_WL = "1";
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
    };
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    settings."org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        vitals.extensionUuid
        user-themes.extensionUuid
        dock-from-dash.extensionUuid
        clipboard-indicator.extensionUuid
        caffeine.extensionUuid
      ];
    };
  };

  home.stateVersion = "24.11";
}