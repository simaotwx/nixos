{
  config,
  lib,
  pkgs,
  packages,
  flakePath,
  ...
}@args:
let
  simao-htpc-kodi-factory-data = import "${flakePath}/packages/simao-htpc-kodi-factory-data.nix" args;
in
{
  boot.initrd.supportedFilesystems = {
    btrfs = true;
    squashfs = true;
    overlay = true;
  };
  boot.kernelParams = [
    "systemd.setenv=SYSTEMD_REPART_MKFS_OPTIONS_BTRFS=--nodiscard"
  ];

  fileSystems = {
    "/" = {
      fsType = "tmpfs";
      options = [
        "size=10%"
        "noatime"
        "mode=0755"
        "uid=0"
        "gid=0"
      ];
    };

    "/var/updates" = {
      fsType = "tmpfs";
      options = [
        "size=60%"
        "noatime"
      ];
    };

    "/boot" =
      let
        partitionConfig = config.image.repart.partitions."esp".repartConfig;
      in
      {
        device = "/dev/disk/by-partuuid/${partitionConfig.UUID}";
        fsType = partitionConfig.Format;
        options = [
          "fmask=0077"
          "dmask=0077"
          "noatime"
          "x-systemd.device-timeout=30s"
        ];
      };

    "/nix/store" =
      let
        partitionConfig = config.image.repart.partitions."store".repartConfig;
      in
      {
        device = "/dev/disk/by-partlabel/${partitionConfig.Label}";
        fsType = partitionConfig.Format;
        options = [
          "noatime"
          "x-systemd.after=initrd-parse-etc.service"
          "x-systemd.device-timeout=10s"
        ];
        neededForBoot = true;
      };

    "/data" =
      let
        partitionConfig = config.systemd.repart.partitions."21-data";
      in
      {
        device = "/dev/disk/by-partuuid/${partitionConfig.UUID}";
        fsType = partitionConfig.Format;
        options = [
          "noatime"
          "x-systemd.rw-only"
          "x-systemd.device-timeout=30s"
        ];
        neededForBoot = true;
      };

    "/kodi" =
      let
        partitionConfig = config.systemd.repart.partitions."21-data";
      in
      {
        device = "/dev/disk/by-partuuid/${partitionConfig.UUID}";
        fsType = partitionConfig.Format;
        options = [
          "subvol=kodi"
          "noatime"
          "x-systemd.rw-only"
          "x-systemd.device-timeout=30s"
        ];
        neededForBoot = true;
      };

    "/home" = {
      fsType = "tmpfs";
      options = [
        "size=10%"
        "noatime"
      ];
      neededForBoot = true;
    };
  };

  systemd.tmpfiles.settings = {
    "home" = {
      "/home/${config.customization.kodi.user}" = {
        d = {
          group = config.customization.kodi.user;
          mode = "0750";
          user = config.customization.kodi.user;
        };
      };
    };
    "kodi" =
      lib.genAttrs
        [
          "${config.customization.kodi.kodiData}"
        ]
        (_: {
          d = {
            user = config.customization.kodi.user;
            group = config.customization.kodi.user;
            mode = "0750";
          };
        });
  };

  system.activationScripts.populate-kodi-data =
    let
      data = config.customization.kodi.kodiData;
    in
    {
      text = ''
        ${pkgs.rsync}/bin/rsync -rac '${simao-htpc-kodi-factory-data}'/. ${data}/.
        ${pkgs.coreutils-full}/bin/install -m644 \
          '${pkgs.master.widevine-cdm}/share/google/chrome/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so' \
          '${data}/cdm/libwidevinecdm.so'
        ${pkgs.coreutils-full}/bin/install -m644 \
          '${pkgs.master.widevine-cdm}/share/google/chrome/WidevineCdm/manifest.json' \
          '${data}/cdm/manifest.json'
        ${pkgs.coreutils-full}/bin/chown -R \
          '${config.customization.kodi.user}:${config.customization.kodi.user}' '${data}'
        ${pkgs.coreutils-full}/bin/chmod -R u=rwX,g=rwX,o= '${data}'
      '';
    };
}
