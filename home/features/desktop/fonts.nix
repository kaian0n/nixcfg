# home/features/desktop/fonts.nix
{
   config,
   lib,
   pkgs,
   ...
}:
with lib; let
    cfg = config.features.desktop.fonts;
in {
   options.features.desktop.fonts.enable =
      mkEnableOption "install additional fonts for desktop apps";
   config = mkIf cfg.enable {
      home.packages = with pkgs; [
         font-manager
         meslo-lgs-nf
      ];
   };
}
