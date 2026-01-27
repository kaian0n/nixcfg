# /hosts/alns/services/jellyfin.nix
{ pkgs, ... }:
{
   services.jellyfin = {
      enable = true;
      openFirewall = true;  # Opens port 8096
   };

   # Give jellyfin user access to media drive
   users.users.jellyfin.extraGroups = [ "video" "render" ];

   # Hardware acceleration for transcoding (Intel QuickSync)
   hardware.graphics.enable = true;

   environment.systemPackages = with pkgs; [
      jellyfin-ffmpeg  # Optimized ffmpeg for Jellyfin
   ];
}
