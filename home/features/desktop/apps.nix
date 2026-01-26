# /home/features/desktop/apps.nix
{ config, lib, pkgs, ... }:
with lib;
let
   cfg = config.features.desktop.apps;
in {
   options.features.desktop.apps.enable = mkEnableOption "extra desktop applications (brave, vlc)";

   config = mkIf cfg.enable {
      programs.chromium = {
         enable = true;
         package = pkgs.ungoogled-chromium;
      };
      home.packages = with pkgs; [
         vlc
      ];
   };
}
