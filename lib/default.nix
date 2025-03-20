{ nixpkgs, home-manager, lib, inputs, ... }: {
  forEachSystem = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
  homeManager = users: let userList = lib.attrsets.mapAttrsToList (name: _: name) users; in [
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users = users;
      home-manager.extraSpecialArgs = { inherit inputs; };
      configurableUsers = userList;
    }
    {
      home-manager.users = lib.genAttrs userList (username: {
        home.preferXdgDirectories = true;
      });
    }
  ];
}