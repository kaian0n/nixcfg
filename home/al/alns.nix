# /home/al/alns.nix
{ config, ... }:
{
   imports = [
      ./home.nix
      ../common
      ./dotfiles
      ../features/cli
      ../features/desktop
   ];

   features = {
      cli = {
         zsh.enable = true;
         fzf.enable = true;
         bottom.enable = true;
         starship.enable = true;
         tmux.enable = true;
      };
      desktop = {
         fonts.enable = true;

         wayland = {
            enable = true;
            weatherLocation = "Boise,US-ID";
            weatherUnit = "imperial";
         };

         hyprland.enable = true;
         ghostty.enable = true;
         apps.enable = true;

         theme.enable = true;

         wallpaper = {
            enable = true;
            imagePath = "${config.home.homeDirectory}/.local/share/wallpapers/Image.png";
            monitor = "HDMI-A-1";
         };
      };
   };

   wayland.windowManager.hyprland = {
      settings = {
         monitor = [ "HDMI-A-1,preferred,0x0,1" ];
         workspace = [
            "1, default:true"
            "2"
            "3"
            "4"
            "5"
         ];
      };
   };
}
