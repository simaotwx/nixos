{
  pkgs,
  inputs,
  lib,
  osConfig,
  ...
}:
let
  jdks = with pkgs; [
    jdk21
  ];
in
{
  home.packages =
    with pkgs;
    let
      foundrixPkgs = inputs.foundrix.packages.${pkgs.system};
    in
    [
      #wpaperd eww wofi
      #hyprlock hypridle hyprshot
      rose-pine-cursor
      jq
      pv
      pwgen
      socat
      pavucontrol
      playerctl
      #gopass gopass-jsonapi
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
      #orca-slicer
      dig
      signal-desktop
      unzip
      file
      zstd
      tree
      bat
      fd
      brotli
      gparted
      picocom
      telegram-desktop
      chromium
      protobuf
      e2fsprogs
      #audacity
      lm_sensors
      fastfetch
      unstable.jetbrains.idea-community
      jdk
      unstable.nixd
      nixpkgs-fmt
      bc
      #jellycli
      imagemagick
      thunderbird
      evince
      stress
      subfinder
      ntfs3g
      woeusb-ng
      smartmontools
      rsync
      vlc
      #libreoffice-fresh
      p7zip
      iptables
      nftables
      inetutils
      simple-scan
      via
      hwloc
      inputs.zen-browser.packages.${pkgs.system}.beta
      gimp3-with-plugins
      zip

      # Gnome
      pkgs.gnome-tweaks
      gnome-terminal

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
      apktool

      (vesktop.override { withSystemVencord = true; })
      unstable.spotify
      #makemkv
      unstable.android-studio
      prismlauncher
      postman
      dysk
      vulkan-tools
      discord-ptb
      onlyoffice-desktopeditors
      foundrixPkgs.git-aliases
      foundrixPkgs.pickrange
    ]
    ++ lib.optionals (osConfig.networking.hostName == "triceratops") [
      ddrescue
    ]
    ++ lib.optionals (osConfig.networking.hostName == "pteranodon") [

    ];

  home.file = (
    builtins.listToAttrs (
      builtins.concatMap (jdk: [
        {
          name = ".jdks/${lib.versions.major jdk.version}";
          value = {
            source = "${jdk}/lib/openjdk";
          };
        }
        {
          name = ".jdks/${lib.versions.major jdk.version}.intellij";
          value = {
            text = builtins.toJSON rec {
              vendor = jdk.meta.homepage;
              product = jdk.pname;
              flavour = jdk.meta.description;
              jdk_version_major = lib.versions.major jdk.version;
              jdk_version = builtins.concatStringsSep "." (lib.take 3 (lib.versions.splitVersion jdk.version));
              shared_index_aliases = [
                jdk.name
                jdk.version
                "${jdk.pname}-${jdk_version_major}"
                jdk_version_major
                jdk_version
              ];
            };
          };
        }
      ]) jdks
    )
  );

  programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
    vue.volar
    mathiasfrohlich.kotlin
  ];

}
