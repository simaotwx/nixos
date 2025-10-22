{
  pkgs,
  lib,
  inputs,
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
      audacity
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
      yaml2json
      yq
      azure-cli
      opentofu
      dysk
      geckodriver
      terraform
      openssl
      fd
      nmap
      brightnessctl
      lz4
      zip
      qt6Packages.qtdeclarative
      bmap-tools
      gimp3
      pinta
      krita
      ddrescue
      hdparm
      crush-latest
      remmina
      btop
      foundrixPkgs.json2nix
      foundrixPkgs.nix2json
      foundrixPkgs.git-aliases
      foundrixPkgs.pickrange
      gnome-network-displays

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

      unstable.spotify
      unstable.android-studio
      devenv
    ]
    ++ (with unstable.jetbrains; [
      idea-ultimate
      phpstorm
      goland
      pycharm-professional
    ])
    ++ (
      with pkgs.azure-cli-extensions;
      let
        mkAzExtension =
          {
            pname,
            version,
            url,
            hash,
            description,
            ...
          }@args:
          let
            self = python3.pkgs.buildPythonPackage (
              {
                format = "wheel";
                src = fetchurl { inherit url hash; };
                passthru = {
                  updateScript = extensionUpdateScript { inherit pname; };
                  tests.azWithExtension = testAzWithExts [ self ];
                }
                // args.passthru or { };
                meta = {
                  inherit description;
                  inherit (azure-cli.meta) platforms maintainers;
                  homepage = "https://github.com/Azure/azure-cli-extensions";
                  changelog = "https://github.com/Azure/azure-cli-extensions/blob/main/src/${pname}/HISTORY.rst";
                  license = lib.licenses.mit;
                  sourceProvenance = [ lib.sourceTypes.fromSource ];
                }
                // args.meta or { };
              }
              // (removeAttrs args [
                "url"
                "hash"
                "description"
                "passthru"
                "meta"
              ])
            );
          in
          self;
      in
      [
        ssh
        kusto
        webapp
        support
        terraform
        vm-repair
        front-door
        automation
        log-analytics
        image-gallery
        azure-firewall
        application-insights
        (mkAzExtension rec {
          pname = "serial-console";
          version = "1.0.0b2";
          url = "https://github.com/Azure/azure-cli-extensions/releases/download/serial-console-${version}/serial_console-${version}-py3-none-any.whl";
          hash = "sha256-Weu4BEdq/0dvi07682UfYL8FzAd3cKZUGVJLTzJ27JM=";
          description = "Azure CLI extension for Serial Console access and management";
        })
      ]
    );

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
    golang.go
  ];
}
