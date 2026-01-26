# /home/features/desktop/default.nix
{ ... }:
{
   imports = [
      ./fonts.nix
      ./wayland.nix
      ./hyprland.nix
      ./ghostty.nix
      ./apps.nix
      ./theme.nix
   ];
}
