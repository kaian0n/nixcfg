# /hosts/common/default.nix
{ pkgs, lib, inputs, outputs, ... }:
{
   imports = [
      ./extra-services
      ./users
      inputs.home-manager.nixosModules.home-manager
   ];

   home-manager = {
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs outputs; };
      backupFileExtension = "backup";
   };

   nixpkgs = {
      overlays = [
         outputs.overlays.additions
         outputs.overlays.modifications
         outputs.overlays.stable-packages
      ];
      config = {
         allowUnfree = true;
      };
   };

   nix = let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
   in {
      settings = {
         experimental-features = [ "nix-command" "flakes" ];
         trusted-users = [
            "root"
            "al"
         ];
      };

      gc = {
         automatic = true;
         options = "--delete-older-than 30d";
      };

      optimise.automatic = true;

      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;

      nixPath =
         [ "/etc/nix/path" ]
         ++ lib.mapAttrsToList (name: _: "${name}=flake:${name}") flakeInputs;
   };

   systemd.tmpfiles.rules = [
      "d /etc/nix/path 0755 root root - -"
   ];

   boot.enableContainers = true;

   programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
   };

   environment.variables = {
      SYSTEMD_EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      GIT_EDITOR = "nvim";
   };

   environment.systemPackages = with pkgs; [
      nvme-cli
      smartmontools
      lm_sensors
      (writeShellScriptBin "vimdiff" ''
         exec ${neovim}/bin/nvim -d "$@"
      '')
   ];

   users.defaultUserShell = pkgs.zsh;
}
