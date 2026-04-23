{
  description = "Harris's macOS Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      hyprland,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
      supportedSystems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];
      forEachSupportedSystem =
        f:
        lib.genAttrs supportedSystems (
          system:
          f {
            inherit system;
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
          }
        );
    in
    {
      # Home Manager configurations (multi-platform)
      # macOS:  nix run .#homeConfigurations."harris@aarch64-darwin".activationPackage
      # Linux:  nix run .#homeConfigurations."harris@x86_64-linux".activationPackage
      homeConfigurations =
        let
          mkHome =
            system:
            home-manager.lib.homeManagerConfiguration {
              pkgs = nixpkgs.legacyPackages.${system};
              modules = [ ./home.nix ];
              extraSpecialArgs = { inherit inputs self; };
            };
        in
        {
          "harris@aarch64-darwin" = mkHome "aarch64-darwin";
          "harris@x86_64-linux" = mkHome "x86_64-linux";
        };

      # NixOS system configuration
      nixosConfigurations.neon = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/neon/default.nix ];
      };

      # devShells
      devShells = forEachSupportedSystem (
        { pkgs, system }:
        {
          default = pkgs.mkShellNoCC {
            packages = [ self.formatter.${system} ];
          };
        }
      );

      # formatter
      formatter = forEachSupportedSystem ({ pkgs, ... }: pkgs.nixfmt-rfc-style);
    };
}
