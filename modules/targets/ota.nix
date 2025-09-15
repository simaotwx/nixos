{ pkgs, config, lib, ... }: {
  options = {
    system.build.ota.artifacts = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          source = lib.mkOption {
            type = lib.types.path;
            description = "Source path of the artifact";
          };
          compressionLevel = lib.mkOption {
            type = lib.types.int;
            default = 4;
            description = "Compression level for pigz (1-9)";
          };
        };
      });
      default = {};
      description = "Artifacts to include in the OTA update";
    };
  };

  config =
  let
    mkCompressed = { name, inputFile, compressionLevel }:
      pkgs.runCommand name {
        allowSubstitutes = false;
        dontFixup = true;
        nativeBuildInputs = [ pkgs.pigz ];
      } ''
        pigz -${toString compressionLevel} -c ${inputFile} > $out
      '';
  in
  {
    system.build.otaUpdate =
      let
        sys = config.system;
        artifacts = config.system.build.ota.artifacts;
      in
      pkgs.runCommand "update-${sys.image.id}-${sys.image.version}" {
        allowSubstitutes = false;
        dontFixup = true;
        nativeBuildInputs = [ pkgs.coreutils ];
      } ''
        mkdir -p $out
        ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: artifact: ''
          cp --reflink=auto ${artifact.source} $out/${name}
        '') artifacts)}
        ${lib.optionalString (artifacts != {}) ''
          cd $out
          sha256sum ${lib.concatStringsSep " " (lib.attrNames artifacts)} > SHA256SUMS
        ''}
      '';

    system.build.compressedOtaUpdate =
      let
        sys = config.system;
        artifacts = config.system.build.ota.artifacts;
      in
      pkgs.runCommand "compressed-update-${sys.image.id}-${sys.image.version}" {
        allowSubstitutes = false;
        dontFixup = true;
        nativeBuildInputs = [ pkgs.coreutils ];
      } ''
        mkdir -p $out
        ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: artifact:
          let
            compressed = mkCompressed {
              name = "compressed-${name}.gz";
              inputFile = artifact.source;
              compressionLevel = artifact.compressionLevel;
            };
          in ''
            cp --reflink=auto ${compressed} $out/${name}.gz
          ''
        ) artifacts)}
        ${lib.optionalString (artifacts != {}) ''
          cd $out
          sha256sum ${lib.concatStringsSep " " (map (n: "${n}.gz") (lib.attrNames artifacts))} > SHA256SUMS
        ''}
      '';
  };
}