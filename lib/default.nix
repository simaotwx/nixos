{ nixpkgs, home-manager, lib, inputs, ... }: {
  forEachSystem = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
  homeManager = users: let userList = lib.attrsets.mapAttrsToList (name: _: name) users; in [
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users = users;
      home-manager.backupFileExtension = "bak";
      home-manager.extraSpecialArgs = { inherit inputs; };
      configurableUsers = userList;
    }
    {
      home-manager.users = lib.genAttrs userList (username: {
        home.preferXdgDirectories = true;
      });
    }
  ];
  mkUpdate = system: nixos:
  let
    config = nixos.config;
    pkgs = nixpkgs.legacyPackages.${system};
  in
  pkgs.runCommand "update-${config.system.image.version}"
    {
      nativeBuildInputs = [ pkgs.xz ];
    } ''
    mkdir -p $out
    xz -1 -cz ${config.system.build.uki}/${config.system.boot.loader.ukiFile} \
      > $out/${config.system.boot.loader.ukiFile}.xz
    xz -1 -cz ${config.system.build.image}/${config.boot.uki.name}_${config.system.image.version}.store.raw \
      > $out/store_${config.system.image.version}.img.xz
  '';

}