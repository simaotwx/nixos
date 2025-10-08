{ ... }:
rec {
  concatOutputCombination =
    {
      name,
      artifact,
      variant ? null,
      deviceName,
    }:
    if variant == null || variant == "default" then
      "${name}/${artifact}:${deviceName}"
    else
      "${name}/${artifact}@${variant}:${deviceName}";

  mkTargetOutputs =
    {
      name,
      deviceName,
      nixosConfiguration,
    }:
    let
      outputs = {
        image = nixosConfiguration.config.system.build.image;
        update = {
          default = nixosConfiguration.config.system.build.otaUpdate;
          compressed = nixosConfiguration.config.system.build.compressedOtaUpdate;
        };
        toplevel = nixosConfiguration.config.system.build.toplevel;
        /*
          live-installer = nixosConfiguration.config.system.build.liveInstaller;
          live-updater = nixosConfiguration.config.system.build.liveUpdater;
        */
      };

      isDerivation = value: value ? type && value.type == "derivation";

      # Flatten outputs, handling both direct values and variant attribute sets
      flattenedOutputs = builtins.concatLists (
        builtins.attrValues (
          builtins.mapAttrs (
            artifact: value:
            if isDerivation value then
              [
                {
                  key = concatOutputCombination { inherit name artifact deviceName; };
                  value = value;
                }
              ]
            else if builtins.isAttrs value then
              map (variant: {
                key = concatOutputCombination {
                  inherit
                    name
                    artifact
                    variant
                    deviceName
                    ;
                };
                value = value.${variant};
              }) (builtins.attrNames value)
            else
              [
                {
                  key = concatOutputCombination { inherit name artifact deviceName; };
                  value = value;
                }
              ]
          ) outputs
        )
      );
    in
    builtins.listToAttrs (
      map (item: {
        name = item.key;
        value = item.value;
      }) flattenedOutputs
    );
}
