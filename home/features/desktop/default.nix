# home/features/desktop/default.nix
{
   pkgs,
   ...
}:{
   imports = [
      ./fonts.nix
      ./wayland.nix
      ./hyprland.nix
   ];
   home.packages = with pkgs; [
   ];
}
