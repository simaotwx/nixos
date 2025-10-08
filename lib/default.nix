{
  nixpkgs,
  home-manager,
  lib,
  inputs,
  flakePath,
  foundrixModules,
  ...
}@args:
{
  forEachSystem = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
  homeManager =
    users:
    let
      userList = lib.attrsets.mapAttrsToList (name: _: name) users;
    in
    [
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users = users;
        home-manager.backupFileExtension = "bak";
        home-manager.extraSpecialArgs = { inherit inputs flakePath foundrixModules; };
        configurableUsers = userList;
      }
      {
        home-manager.users = lib.genAttrs userList (username: {
          home.preferXdgDirectories = true;
        });
      }
    ];
  mkUpdate =
    system: nixos:
    let
      config = nixos.config;
      pkgs = nixpkgs.legacyPackages.${system};
      ukiFile = "${config.system.build.uki}/${config.system.boot.loader.ukiFile}";
      storeFile = "${config.system.build.image}/${config.boot.uki.name}_${config.system.image.version}.store.raw";
      ukiOutName = "${config.system.boot.loader.ukiFile}.xz";
      storeOutName = "store_${config.system.image.version}.img.xz";
    in
    pkgs.runCommand "update-${config.system.image.version}"
      {
        nativeBuildInputs = [
          pkgs.xz
          pkgs.coreutils
        ];
      }
      ''
        mkdir -p $out
        xz -1 -cz ${ukiFile} > $out/${ukiOutName}
        xz -1 -cz ${storeFile} > $out/${storeOutName}
        cd $out
        sha256sum ${ukiOutName} ${storeOutName} > SHA256SUMS
      '';
  images = import ./images.nix args;
  defaultModuleArgs = rec {
    maybeImport =
      file: import (if builtins.pathExists file then file else "${flakePath}/lib/empty.nix");
    maybeImportedModule = file: args: {
      config = maybeImport file;
    };
  };
}
