{
  pkgs,
  lib,
  foundrixPackages,
  ...
}:
let
  jdks = with pkgs; [
    jdk17
    jdk21
  ];
in
{
  home.packages =
    with pkgs;
    let
      foundrixPkgs = foundrixPackages pkgs;
    in
    [
      kitty
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
      dig
      unzip
      file
      zstd
      tree
      bat
      fd
      brotli
      gparted
      picocom
      chromium
      protobuf
      e2fsprogs
      lm_sensors
      fastfetch
      jdk
      unstable.nixd
      nixpkgs-fmt
      bc
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
      libreoffice-fresh
      p7zip
      iptables
      nftables
      inetutils
      simple-scan
      via
      hwloc
      firefox
      mattermost-desktop
      gnome-boxes
      gitleaks
      nodejs
      gettext
      php
      filezilla
      citrix_workspace
      teams-for-linux
      azure-cli
      dysk
      chromedriver
      openssl
      fd
      zip

      # AOSP stuff
      git-repo
      xmlstarlet
      ccache

      unstable.spotify
      unstable.android-studio
      google-chrome
      foundrixPkgs.git-aliases
      foundrixPkgs.pickrange
    ]
    ++ (with unstable.jetbrains; [
      idea-ultimate
      phpstorm
      goland
      pycharm-professional
    ]);

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
    hashicorp.terraform
    hashicorp.hcl
  ];
}
