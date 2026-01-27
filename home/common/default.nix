# /home/common/default.nix
{ config, lib, outputs, pkgs, ... }: {
   nixpkgs = {
      overlays = [
         outputs.overlays.additions
         outputs.overlays.modifications
         outputs.overlays.stable-packages
      ];
      config = {
         allowUnfree = true;
         allowUnfreePredicate = _: true;
      };
   };
}
