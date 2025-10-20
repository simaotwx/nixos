{
  pkgs,
  inputs,
  osConfig,
  ...
}:
{
  home.packages =
    with pkgs;
    let
      foundrixPkgs = inputs.foundrix.packages.${pkgs.system};
    in
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
      lm_sensors
      fastfetch
      unstable.nixd
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
      p7zip
      iptables
      nftables
      inetutils
      simple-scan
      hwloc
      inputs.zen-browser.packages.${pkgs.system}.beta
      dysk
      openssl
      fd
      nmap
      lz4
      zip
      mpv
      btop
      foundrixPkgs.json2nix
      foundrixPkgs.nix2json
      foundrixPkgs.git-aliases
      foundrixPkgs.pickrange

      # GStreamer
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-libav
      gst_all_1.gst-vaapi
    ]
    ++ lib.optionals (osConfig.networking.hostName == "aludepp") [
      makemkv
      unstable.android-studio
      (vesktop.override { withSystemVencord = true; })
      via
      unstable.jetbrains.idea-community
      jdk
      unstable.spotify
      inputs.quickshell.packages.${system}.default
      qt6Packages.qtdeclarative
      aider-chat-full
      crush-latest
      gimp3
      pinta
      krita
      ddrescue
      hdparm
      feishin
      brasero
      gnome-boxes
      libreoffice-fresh
      audacity
      devenv
      master.opencode
      unstable.zed-editor

      # AOSP stuff
      git-repo
      xmlstarlet
      ccache
    ];

  programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
    bradlc.vscode-tailwindcss
    golang.go
  ];

  home.file.".zed_server" = {
    source = "${pkgs.unstable.zed-editor.remote_server}/bin";
  };
}
