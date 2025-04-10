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
              SplitName = "-";
            };
          };
          "store" = {
            storePaths = [ config.system.build.toplevel ];
            stripNixStorePrefix = true;
            repartConfig = {
              Type = "linux-generic";
              Label = "store_${config.system.image.version}";
              Format = "squashfs";
              Minimize = "off";
              ReadOnly = "yes";
              SizeMinBytes = "3G";
              SplitName = "store";
            };
          };
          "store-empty" = {
            repartConfig = {
              Type = "linux-generic";
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
    systemd.repart = {
      enable = true;
      partitions = {
        "home" = {
          Type = "home";
          UUID = lib.toLower "933AC7E1-2EB4-4F13-B844-0E14E2AEF915";
          Format = "btrfs";
          Subvolumes = "/home";
          Label = "home";
          Minimize = "off";
          Encrypt = "off";
          SizeMinBytes = "4G";
          SplitName = "-";
          FactoryReset = "yes";
        };
      };
    };
  };
}