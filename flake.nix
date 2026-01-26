# /flake.nix
{
   description = "alns nix flake";

   inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

      home-manager = {
         url = "github:nix-community/home-manager";
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

      ghostty = {
         url = "github:ghostty-org/ghostty";
         inputs.nixpkgs.follows = "nixpkgs";
      };
      agenix = {

         url = "github:ryantm/agenix";
         inputs.nixpkgs.follows = "nixpkgs";
    };

   };

   outputs = { self, disko, dotfiles, home-manager, nixpkgs, nixpkgs-stable, ghostty, agenix, ... } @ inputs:
   let
      inherit (self) outputs;
      lib = nixpkgs.lib;
      systems = [
         "aarch64-linux"
         "i686-linux"
         "x86_64-linux"
         "aarch64-darwin"
         "x86_64-darwin"
      ];
      forAllSystems = lib.genAttrs systems;
   in {
      packages = forAllSystems (system:
         import ./pkgs { pkgs = nixpkgs.legacyPackages.${system}; }
      );

      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = {
         alns = nixpkgs.lib.nixosSystem {
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
