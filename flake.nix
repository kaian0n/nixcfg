# flake.nix
{
   description = "alns nix flake";
   inputs = {
      home-manager = {
         url = "github:nix-community/home-manager/release-25.05";
         inputs.nixpkgs.follows = "nixpkgs";
      };
      nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
      nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
      disko = {
         url = "github:nix-community/disko";
         inputs.nixpkgs.follows = "nixpkgs";
      };
      dotfiles = {
         url = "github:kaian0n/dotfiles";
         flake = false;
      };
   };
   outputs = {
      self,
      disko,
      dotfiles,
      home-manager,
      nixpkgs,
      ... }@inputs:
      let
         inherit (self) outputs;
         systems = [
            "aarch64-linux"
            "i686-linux"
            "x86_64-linux"
            "aarch64-darwin"
            "x86_64-darwin"
         ];
         forAllSystems = nixpkgs.lib.genAttrs systems;
      in {
         packages =
            forAllSystems (system: import ./pkgs { pkgs = nixpkgs.legacyPackages.${system}; });
         overlays = import ./overlays { inherit inputs; };
         nixosConfigurations = {
            alns = nixpkgs.lib.nixosSystem {
               specialArgs = { inherit inputs outputs; };
               modules = [ ./hosts/alns inputs.disko.nixosModules.disko ];
            };
         };
         homeConfigurations = {
            "al@alns" = home-manager.lib.homeManagerConfiguration {
               pkgs = nixpkgs.legacyPackages."x86_64-linux";
               extraSpecialArgs = { inherit inputs outputs; };
               modules = [
                  ./home/al/alns.nix
               ];
            };
         };
      };
}
