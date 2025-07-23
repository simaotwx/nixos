{
  pkgs,
  inputs,
  osConfig,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      rose-pine-cursor
      jq
      pv
      pwgen
      socat
      pavucontrol
      playerctl
      gopass
      gopass-jsonapi
      git
      curl
      wl-clipboard
      cliphist
      wl-clipboard-x11
      easyeffects
      nautilus
      file-roller
      loupe
      gedit
      gnome-calculator
      mangohud
      appimage-run
      celluloid
      orca-slicer
      dig
      signal-desktop
      unzip
      file
      zstd
      tree
      bat
      fd
      brotli
      picocom
      chromium
      protobuf
      e2fsprogs
      audacity
      lm_sensors
      fastfetch
      nixd
      nixpkgs-fmt
      bc
      imagemagick
      thunderbird
      evince
      stress
      subfinder
      smartmontools
      rsync
      vlc
      libreoffice-fresh
      p7zip
      iptables
      nftables
      inetutils
      simple-scan
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
      gimp3
      pinta
      krita

      # GStreamer
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-libav
      gst_all_1.gst-vaapi

      # AOSP stuff
      git-repo
      xmlstarlet
      ccache

    ]
    ++ lib.optionals (osConfig.networking.hostName == "aludepp") [
      makemkv
      android-studio
      (vesktop.override { withSystemVencord = true; })
      via
      jetbrains.idea-community
      jdk
      spotify
    ];

}
