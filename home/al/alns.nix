# /home/al/alns.nix
{ config, ... }:
{
   imports = [
      ./home.nix
      ../common
      ../features/cli
   ];

   features = {
      cli = {
         zsh.enable = true;
         fzf.enable = true;
         bottom.enable = true;
         starship.enable = true;
         tmux.enable = true;
      };
   };
}
