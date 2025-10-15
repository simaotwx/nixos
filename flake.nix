{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    foundrix = {
      url = "github:xdevs23/foundrix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
      inputs.nixpkgs-master.follows = "nixpkgs-master";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-master = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    hyprland.url = "github:hyprwm/Hyprland";
    nixos-apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell?ref=refs/tags/v0.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell-unstable = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell?ref=master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    linux-nitrous = {
      url = "file+https://gitlab.com/xdevs23/linux-nitrous/-/raw/v6.17.3-1-nixos/default.nix";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      foundrix,
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
          foundrixModules = foundrix.nixosModules;
          inputs = flake;
        }
      );
      inherit (customLib) forEachSystem homeManager homeManagerMaster;
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
        fwdesktop = homeManagerMaster {
          fwdesktop = import ./home/fwdesktop;
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
      commonArgs =
        system:
        {
          inherit (self) inputs;
          inherit flakePath system;
        }
        // customLib.defaultModuleArgs
        // foundrix.nixosModules.foundrixSpecialArgs;
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

        fwdesktop =
          let
            custPath = ./customization/fwdesktop;
          in
          unstableLib.nixosSystem rec {
            system = "x86_64-linux";
            specialArgs = lib.recursiveUpdate (commonArgs system) {
              inputs = {
                inherit (self.inputs) nixos-hardware nixpkgs-unstable nixpkgs-master;
                nixpkgs = nixpkgs-unstable;
              };
              packages = self.packages.${system};
            };
            modules =
              commonModules
              ++ [
                custPath
              ]
              ++ homeManagerModules.fwdesktop;
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
          specialArgs = lib.recursiveUpdate (commonArgs system) {
            inputs = {
              inherit (self.inputs) nixos-hardware nixpkgs-unstable nixpkgs-master;
              nixpkgs = nixpkgs-unstable;
            };
            packages = self.packages.${system};
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

        julian-notebook = lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = commonArgs system;
          modules =
            commonModules
            ++ [
              ./customization/julian-notebook
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
        customLib.images.mkTargetOutputs {
          name = "simao-htpc";
          deviceName = "odroid-h4";
          nixosConfiguration = nixosConfigurations.simao-htpc;
        }
      );

      formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
    };
}
