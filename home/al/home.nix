# /home/al/home.nix
{ config, lib, pkgs, ... }:
{
   home.username = lib.mkDefault "al";
   home.homeDirectory = lib.mkDefault "/home/${config.home.username}";

   home.stateVersion = "25.11";

   home.packages = with pkgs; [
      wofi
      cowsay
   ];

   home.file = { };

   home.sessionVariables = { };

   programs.home-manager.enable = true;
}
