{ pkgs, inputs, ... }: {
  home.packages = with pkgs; [
    kitty
    rose-pine-cursor
    jq pv pwgen
    socat
    pavucontrol playerctl
    gopass gopass-jsonapi
    git curl
    wl-clipboard cliphist wl-clipboard-x11
    easyeffects
    nautilus file-roller loupe gedit gnome-calculator
    mangohud
    appimage-run
    celluloid
    dig
    unzip file zstd tree bat fd brotli
    gparted
    picocom
    polychromatic
    chromium
    protobuf
    e2fsprogs
    lm_sensors
    fastfetch
    jdk
    nixd nixpkgs-fmt
    bc
    imagemagick
    thunderbird
    evince
    stress
    subfinder
    ntfs3g woeusb-ng
    smartmontools rsync
    vlc
    libreoffice-fresh
    p7zip iptables nftables inetutils simple-scan
    via
    hwloc
    firefox
    mattermost-desktop
    gnome-boxes
    gitleaks
    nodejs

    # GStreamer
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi

    # AOSP stuff
    git-repo xmlstarlet ccache

    spotify
    android-studio
  ] ++ (with jetbrains; [
    idea-ultimate
    phpstorm
    goland
    pycharm-professional
  ]);

}
