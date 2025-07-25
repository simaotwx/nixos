{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rose-pine-cursor
    jq
    pv
    socat
    playerctl
    git
    curl
    wl-clipboard
    wl-clipboard-x11
    appimage-run
    dig
    unzip
    file
    zstd
    tree
    bat
    fd
    brotli
    chromium
    protobuf
    e2fsprogs
    lm_sensors
    fastfetch
    nixd
    nixpkgs-fmt
    bc
    imagemagick
    stress
    smartmontools
    rsync
    p7zip
    iptables
    nftables
    inetutils
    hwloc

    # GStreamer
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi
  ];

}
