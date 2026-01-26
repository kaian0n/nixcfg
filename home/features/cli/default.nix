# /home/features/cli/default.nix
{ pkgs, ... }:
{
   imports = [
      ./zsh.nix
      ./fzf.nix
      ./bottom.nix
      ./starship.nix
      ./tmux.nix
   ];

   programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
   };

   programs.eza = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      extraOptions = [ "-l" "--icons" "--git" "-a" ];
   };

   programs.bat.enable = true;

   home.packages = with pkgs; [
      coreutils
      fd
      httpie
      jq
      procs
      ripgrep
      tldr
      zip
      macchina
      fastfetch
   ];
}
