# /home/features/desktop/fonts.nix
{ config, lib, pkgs, ... }:
with lib;
let
   cfg = config.features.desktop.fonts;
in {
   options.features.desktop.fonts.enable = mkEnableOption "install additional fonts for desktop apps";

   config = mkIf cfg.enable {
      # Make user-installed fonts discoverable
      fonts.fontconfig.enable = true;

      # Use new per-font packages under pkgs.nerd-fonts.*
      home.packages = with pkgs; [
         font-manager
         nerd-fonts.meslo-lg
         nerd-fonts.fira-code
      ];
   };
}
