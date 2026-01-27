# /home/al/alns.nix
{ config, ... }:
{
   imports = [
      ./home.nix
      ../common
      ./dotfiles
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
