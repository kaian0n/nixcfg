# /flake.nix
{
   description = "alns nix flake";

   inputs = {
      # Use the current stable NixOS branch for the server.
      nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

      # Keep unstable available explicitly for packages that genuinely need it.
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

      home-manager = {
         url = "github:nix-community/home-manager/release-25.11";
         inputs.nixpkgs.follows = "nixpkgs";
      };

      disko = {
         url = "github:nix-community/disko";
         inputs.nixpkgs.follows = "nixpkgs";
      };

      dotfiles = {
         url = "github:kaian0n/dotfiles";
         flake = false;
      };

      agenix = {
         url = "github:ryantm/agenix";
         inputs.nixpkgs.follows = "nixpkgs";
      };
   };

   outputs = { self, disko, dotfiles, home-manager, nixpkgs, nixpkgs-unstable, agenix, ... } @ inputs:
   let
      inherit (self) outputs;
      lib = nixpkgs.lib;
      systems = [
         "x86_64-linux"
      ];
      forAllSystems = lib.genAttrs systems;
   in {
      packages = forAllSystems (system:
         import ./pkgs { pkgs = nixpkgs.legacyPackages.${system}; }
      );

      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = {
         alns = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs outputs; };
            modules = [
               ./hosts/alns
               inputs.disko.nixosModules.disko
               agenix.nixosModules.default
            ];
         };
      };

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
   };
}
