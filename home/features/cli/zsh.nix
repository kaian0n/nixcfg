# home/features/cli/zsh.nix
{
   config,
   lib,
   ...
}:
with lib; let
   cfg = config.features.cli.zsh;
in {
   options.features.cli.zsh.enable = mkEnableOption "enable extended zsh configuration";
   config = mkIf cfg.enable {
      programs.zsh = {
         enable = true;
         profileExtra = ''
            export NIX_PATH=nixpkgs=channel:nixos-25.05
            export NIX_LOG=info
            export Terminal=kitty
         '';
         shellAliases = {
            ls = "eza";
            grep = "rg";
         };
      };
   };
}
