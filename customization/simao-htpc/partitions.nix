{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/image/repart.nix"
  ];

  options = {
    customization.partitions = {
      systemDisk = lib.mkOption {
        type = lib.types.str;
      };
    };
  };

  config = {
    image.repart =
      let
        efiArch = "x64";
      in
      {
        name = config.boot.uki.name;
        split = true;

        partitions = {
          "esp" = {
            contents = {
              "/EFI/BOOT/BOOT${lib.toUpper efiArch}.EFI".source =
                "${pkgs.systemd}/lib/systemd/boot/efi/systemd-boot${efiArch}.efi";
              "/EFI/Linux/${config.system.boot.loader.ukiFile}".source =
                "${config.system.build.uki}/${config.system.boot.loader.ukiFile}";
              "/loader/loader.conf".source = (
                pkgs.writeText "$out" ''
                  timeout ${toString config.boot.loader.timeout}
                ''
              );
            };
            repartConfig = {
              Type = "esp";
              UUID = lib.toLower "C12A7328-F81F-11D2-BA4B-00A0C93EC93B";
              Format = "vfat";
              SizeMinBytes = "256M";
              SplitName = "esp";
            };
          };
          "store" = {
            storePaths = [ config.system.build.toplevel ];
            stripNixStorePrefix = true;
            repartConfig = {
              Type = lib.toLower "00000000-0000-4000-9000-000000000040";
              Label = "store_${config.system.image.version}";
              UUID = lib.toLower "00000000-0000-4000-9000-100000000040";
              Format = "erofs";
              Compression = "lz4hc";
              ReadOnly = "yes";
              SizeMinBytes = "4G";
              SplitName = "store";
            };
          };
          "store-empty" = {
            repartConfig = {
              Type = lib.toLower "00000000-0000-4000-9000-000000000040";
              UUID = lib.toLower "00000000-0000-4000-9000-100000000050";
              Label = "_empty";
              Minimize = "off";
              SizeMinBytes = "4G";
              SplitName = "-";
            };
          };
        };
      };

    boot.initrd.systemd.repart = {
      enable = true;
      device = config.customization.partitions.systemDisk;
    };

    boot.initrd.systemd.repart.empty = "allow";
    boot.initrd.systemd.services.systemd-repart.after = lib.mkForce [ ];
    systemd.repart = {
      enable = true;
      partitions = {
        "21-data" = {
          Type = lib.toLower "00000000-0000-4000-9000-000000000070";
          UUID = lib.toLower "00000000-0000-4000-9000-100000000070";
          Format = "btrfs";
          Label = "userdata";
          Subvolumes = "/kodi";
          MakeDirectories = "/kodi";
          Minimize = "off";
          Encrypt = "off";
          SizeMinBytes = "1G";
          SizeMaxBytes = "16G";
          SplitName = "-";
          FactoryReset = "yes";
          Priority = -15;
        };
      };
    };
  };
}
