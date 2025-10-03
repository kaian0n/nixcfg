# home/al/alns.nix
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
      };
      desktop = {
         fonts.enable = true;
         wayland.enable = true;
         hyprland.enable = true;
      };
   };
   wayland.windowManager.hyprland = { #host/machine specific hyprland settings
      settings = {
         monitor = [
            "HDMI-A-1,preferred,0x0,1"
         ];
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
