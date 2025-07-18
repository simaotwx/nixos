{ pkgs, inputs, ... }: {
  home.packages = with pkgs; [
    wpaperd eww wofi
    hyprlock hypridle hyprshot
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
    orca-slicer
    dig
    signal-desktop
    unzip file zstd tree bat fd brotli
    picocom
    chromium
    protobuf
    e2fsprogs
    audacity
    lm_sensors
    fastfetch
    jetbrains.idea-community jdk
    nixd nixpkgs-fmt
    bc
    jellycli
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
    inputs.zen-browser.packages."${pkgs.system}".beta
    gnome-boxes
    dysk
    brasero
    openssl
    fd
    nmap
    lz4
    zip
    gimp3 pinta krita

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

    (vesktop.override { withSystemVencord = true; })
    spotify
    makemkv
    android-studio
  ];

}