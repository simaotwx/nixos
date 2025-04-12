{ config, pkgs, lib, modulesPath, ... }: {
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
      let efiArch = "x64";
      in {
        name = config.boot.uki.name;
        split = true;

        partitions = {
          "esp" = {
            contents = {
              "/EFI/BOOT/BOOT${lib.toUpper efiArch}.EFI".source =
                "${pkgs.systemd}/lib/systemd/boot/efi/systemd-boot${efiArch}.efi";
              "/EFI/Linux/${config.system.boot.loader.ukiFile}".source =
                "${config.system.build.uki}/${config.system.boot.loader.ukiFile}";
              "/loader/loader.conf".source = (pkgs.writeText "$out" ''
                timeout ${toString config.boot.loader.timeout}
              '');
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
              Format = "squashfs";
              ReadOnly = "yes";
              SizeMinBytes = "3G";
              SplitName = "store";
            };
          };
          "store-empty" = {
            repartConfig = {
              Type = lib.toLower "00000000-0000-4000-9000-000000000040";
              UUID = lib.toLower "00000000-0000-4000-9000-100000000050";
              Label = "_empty";
              Minimize = "off";
              SizeMinBytes = "3G";
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
        "20-nix-store-rw" = {
          Type = lib.toLower "00000000-0000-4000-9000-000000000060";
          UUID = lib.toLower "00000000-0000-4000-9000-100000000060";
          Format = "btrfs";
          Label = "nix-store-rw";
          Subvolumes = "/upper /work";
          MakeDirectories = "/upper /work";
          Minimize = "off";
          Encrypt = "off";
          SizeMinBytes = "1G";
          SizeMaxBytes = "1G";
          SplitName = "-";
          FactoryReset = "yes";
          Priority = -20;
        };
        "30-home" = {
          Type = "home";
          UUID = lib.toLower "933AC7E1-2EB4-4F13-B844-0E14E2AEF915";
          Format = "btrfs";
          Label = "home";
          Minimize = "off";
          Encrypt = "off";
          SizeMinBytes = "4G";
          SplitName = "-";
          FactoryReset = "yes";
          Priority = 0;
        };
      };
    };
  };
}