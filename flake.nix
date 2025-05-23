{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@flake:
  let
    flakePath = ./.;
    lib = nixpkgs.lib;
    unstableLib = nixpkgs-unstable.lib;
    customLib = import ./lib (flake // { inherit lib flakePath; inputs = flake; });
    inherit (customLib) forEachSystem homeManager;
    commonModules = [
      ./modules
      ./hardware
    ];
    homeManagerModules = {
      simao = homeManager {
        simao = import ./home/simao;
      };
      simaoHtpc = homeManager {
        htpc = import ./home/simaoHtpc;
      };
      simaoWork = homeManager {
        simao = import ./home/simaoWork;
      };
      kehoeldWork = homeManager {
        kehoeld = import ./home/kehoeldWork;
      };
      julianWork = homeManager {
        julian = import ./home/julianWork;
      };
      noah = homeManager {
        noah = import ./home/noah;
      };
    };
  in
  rec {
    nixosConfigurations = {
      vm-test = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit (self) inputs; inherit flakePath; };
        modules = commonModules ++ [
          ./customization/vm-test.nix
        ];
      };
      vm-live = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit (self) inputs; inherit flakePath; };
        modules = commonModules ++ [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
          ./customization/vm-test.nix
        ];
      };

      aludepp = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit (self) inputs; inherit flakePath; };
        modules = commonModules ++ [
          ./customization/aludepp
        ] ++ homeManagerModules.simao;
      };

      simao-htpc = unstableLib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inputs = {
            inherit (self.inputs) nixos-hardware nixpkgs-unstable;
            nixpkgs = nixpkgs-unstable;
          };
          packages = self.packages.${system}; inherit flakePath system; };
        modules = commonModules ++ [
          ./customization/simao-htpc
        ];
      };

      simao-workbook = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit (self) inputs; inherit flakePath; };
        modules = commonModules ++ [
          ./customization/simao-workbook
        ] ++ homeManagerModules.simaoWork;
      };

      bohrmaschine = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit (self) inputs; inherit flakePath; };
        modules = commonModules ++ [
          ./customization/bohrmaschine
        ] ++ homeManagerModules.kehoeldWork;
      };

      presslufthammer = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit (self) inputs; inherit flakePath; };
        modules = commonModules ++ [
          ./customization/presslufthammer
        ] ++ homeManagerModules.julianWork;
      };

      triceratops = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit (self) inputs; inherit flakePath; };
        modules = commonModules ++ [
          ./customization/triceratops
        ] ++ homeManagerModules.noah;
      };
    };

    packages = forEachSystem (system: let pkgs = import nixpkgs { inherit system; }; in {
      simao-htpc-update = customLib.mkUpdate system nixosConfigurations.simao-htpc;
      simao-htpc-kodi-factory-data = import ./packages/simao-htpc-kodi-factory-data.nix {
        inherit pkgs nixosConfigurations system flakePath;
      };
    });

    formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
  };
}