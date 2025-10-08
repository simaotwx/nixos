{
  lib,
  config,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/image/repart.nix"
  ];

  options = { };

  config =
    let
      partitionIds = {
        esp = "10-esp";
        store = "20-store";
      };
      efiArch = config.nixpkgs.hostPlatform.efiArch;
    in
    {
      _module.args.target.images.readOnly.repartPartitionIds = partitionIds;

      # Automatically enable read-only system storage
      target.storage.system.readOnly = true;

      # Set device path for read-only systems using current image version
      target.storage.layout.nixStore.device = "PARTLABEL=store_${config.system.image.version}";

      image.repart = {
        name = config.boot.uki.name;
        split = true;

        partitions = {
          ${partitionIds.esp} = {
            contents = {
              "/EFI/BOOT/BOOT${lib.toUpper efiArch}.EFI".source =
                "${pkgs.systemd}/lib/systemd/boot/efi/systemd-boot${efiArch}.efi";

              "/EFI/Linux/${config.system.boot.loader.ukiFile}".source =
                "${config.system.build.uki}/${config.system.boot.loader.ukiFile}";

              "/loader/loader.conf".source = pkgs.writeText "loader.conf" ''
                timeout ${toString config.boot.loader.timeout}
                ${lib.concatMapStrings (x: "${x}\n") config.target.boot.loader.systemd-boot.extraConfig}
              '';
            };
            repartConfig = {
              Type = "esp";
              Label = "esp";
              UUID = "C12A7328-F81F-11D2-BA4B-00A0C93EC93B";
              Format = "vfat";
              SizeMinBytes = "512M";
              SplitName = "-";
            };
          };

          ${partitionIds.store} = {
            storePaths = [ config.system.build.toplevel ];
            stripNixStorePrefix = true;
            repartConfig = rec {
              Type = "root";
              SplitName = "store";
              Label = "${SplitName}_${config.system.image.version}";
              UUID = lib.toLower "00000000-0000-4000-9000-000000000200";
              Format = "erofs";
              Compression = "lz4";
              ReadOnly = "yes";
              SizeMinBytes = "16G";
            };
          };
        };
      };

      system.build.ota.artifacts =
        let
          ukiFile = "${config.system.build.uki}/${config.system.boot.loader.ukiFile}";
          storeFile = "${config.system.build.image}/${config.boot.uki.name}_${config.system.image.version}.store.raw";
          ukiOutName = config.system.boot.loader.ukiFile;
          storeOutName = "store_${config.system.image.version}.img";
        in
        {
          ${ukiOutName}.source = ukiFile;
          ${storeOutName}.source = storeFile;
        };
    };
}
