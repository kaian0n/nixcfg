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
         outputs.overlays.ghostty
      ];
      config = {
         allowUnfree = true;
      };
   };

   nix = let
      # Collect only flake inputs (nixpkgs, home-manager, etc.)
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

      # Make flake refs like `nixpkgs#...` resolve to your pinned inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;

      # Make legacy `<nixpkgs>` (NIX_PATH) resolve to the same pinned inputs.
      nixPath =
         [ "/etc/nix/path" ]
         ++ lib.mapAttrsToList (name: _: "${name}=flake:${name}") flakeInputs;
   };

   # Materialize /etc/nix/path as a real directory (silences warning; allows extra <name> aliases)
   systemd.tmpfiles.rules = [
      "d /etc/nix/path 0755 root root - -"
   ];

   # NixOS containers (nixos-container) available on all hosts
   boot.enableContainers = true;

   # System-wide Neovim for every host/user.
   programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
   };

   # Cover tools that sometimes skip EDITOR/VISUAL.
   environment.variables = {
      SYSTEMD_EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      GIT_EDITOR = "nvim";
   };

   # Provide an actual `vimdiff` executable that calls Neovim's diff mode
   # + add hardware/diagnostic tools across all hosts.
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
