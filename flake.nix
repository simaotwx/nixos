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
    hyprland.url = "github:hyprwm/Hyprland";
    nixos-apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      ...
    }@flake:
    let
      flakePath = ./.;
      lib = nixpkgs.lib;
      unstableLib = nixpkgs-unstable.lib;
      customLib = import ./lib (
        flake
        // {
          inherit lib flakePath;
          inputs = flake;
        }
      );
      inherit (customLib) forEachSystem homeManager;
      commonModules = [
        ./modules
        {
          system.configurationRevision = toString (
            self.shortRev or self.dirtyShortRev or self.lastModified or "unknown"
          );
        }
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
      commonArgs = system: {
        inherit (self) inputs;
        inherit flakePath;
        packages = self.packages.${system};
        pkgsUnstable = (import nixpkgs-unstable { inherit system; });
      };
    in
    rec {
      nixosConfigurations = {
        aludepp =
          let
            custPath = ./customization/aludepp;
          in
          lib.nixosSystem rec {
            system = "x86_64-linux";
            specialArgs = commonArgs system;
            modules =
              commonModules
              ++ [
                custPath
              ]
              ++ homeManagerModules.simao;
          };

        simao-m1air =
          let
            custPath = ./customization/simao-m1air;
          in
          lib.nixosSystem rec {
            system = "aarch64-linux";
            specialArgs = commonArgs system;
            modules =
              commonModules
              ++ [
                custPath
              ]
              ++ homeManagerModules.simao;
          };

        simao-htpc = unstableLib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            inputs = {
              inherit (self.inputs) nixos-hardware nixpkgs-unstable;
              nixpkgs = nixpkgs-unstable;
            }
            // (commonArgs system);
            packages = self.packages.${system};
            inherit flakePath system;
          };
          modules = commonModules ++ [
            ./customization/simao-htpc
          ];
        };

        nanonet-minilab = lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            inputs = {
              inherit (self.inputs) nixos-hardware nixpkgs-unstable;
            }
            // (commonArgs system);
            packages = self.packages.${system};
            inherit flakePath system;
          };
          modules = commonModules ++ [
            ./customization/nanonet-minilab
          ];
        };

        simao-workbook = lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = commonArgs system;
          modules =
            commonModules
            ++ [
              ./customization/simao-workbook
            ]
            ++ homeManagerModules.simaoWork;
        };

        bohrmaschine = lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = commonArgs system;
          modules =
            commonModules
            ++ [
              ./customization/bohrmaschine
            ]
            ++ homeManagerModules.kehoeldWork;
        };

        presslufthammer = lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = commonArgs system;
          modules =
            commonModules
            ++ [
              ./customization/presslufthammer
            ]
            ++ homeManagerModules.julianWork;
        };

        triceratops = lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = commonArgs system;
          modules =
            commonModules
            ++ [
              ./customization/triceratops
            ]
            ++ homeManagerModules.noah;
        };
      };

      packages = forEachSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          commonPackageArgs = {
            inherit
              pkgs
              nixosConfigurations
              system
              flakePath
              lib
              ;
          };
        in
        {
          simao-htpc-update = customLib.mkUpdate system nixosConfigurations.simao-htpc;
          nanonet-minilab-update = customLib.mkUpdate system nixosConfigurations.nanonet-minilab;
          simao-htpc-kodi-factory-data = import ./packages/simao-htpc-kodi-factory-data.nix commonPackageArgs;
          aludepp-gpu-gaming-tune = import ./customization/aludepp/gpu-gaming-tune.nix commonPackageArgs;
          aludepp-gpu-stock-tune = import ./customization/aludepp/gpu-stock-tune.nix commonPackageArgs;
          aludepp-gpu-fan-control = import ./customization/aludepp/gpu-fancontrol.nix commonPackageArgs;
        }
      );

      nixosModules = {
        linux-nitrous-module = import ./modules/components/linux-nitrous.nix;
      };

      formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
    };
}
