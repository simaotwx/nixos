{ config, pkgs, ... }: {
  systemd.sysupdate = {
    enable = true;

    transfers = {
      "10-uki" = {
        InstanceMax = 2;
        Source = {
          MatchPattern = [
            "${config.boot.uki.name}_@v.efi.xz"
            "${config.boot.uki.name}_@v.efi"
          ];

          # Path = "https://...";
          # Type = "url-file";
          Path = "/var/updates/";
          Type = "regular-file";
        };

        Target = {
          MatchPattern = [
            "${config.boot.uki.name}_@v.efi"
          ];

          Path = "/EFI/Linux";
          PathRelativeTo = "boot";

          Type = "regular-file";
        };

        Transfer = {
          ProtectVersion = "%A";
        };
      };

      "20-store" = {
        InstanceMax = 2;
        Source = {
          MatchPattern = [
            "store_@v.img.xz"
            "store_@v.img"
          ];

          Path = "/var/updates/";
          Type = "regular-file";
        };

        Target = {
          Path = config.customization.partitions.systemDisk;
          MatchPattern = "store_@v";
          Type = "partition";
        };
      };
    };
  };

  environment.systemPackages = [
    (pkgs.runCommand "systemd-sysupdate" {} ''
      mkdir -p $out/bin
      ln -s ${config.systemd.package}/lib/systemd/systemd-sysupdate $out/bin
    '')
  ];
}