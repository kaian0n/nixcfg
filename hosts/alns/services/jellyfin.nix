# /hosts/alns/services/jellyfin.nix
{ pkgs, ... }:
{
   services.jellyfin = {
      enable = true;
      openFirewall = true;  # Port 8096
   };

   # Jellyfin needs GPU access for hardware transcoding
   users.users.jellyfin.extraGroups = [ "video" "render" ];

   # Force Intel media driver (iHD) for Arc GPU
   environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
   };

   environment.systemPackages = with pkgs; [
      jellyfin-ffmpeg  # Jellyfin's optimized ffmpeg with QSV/VAAPI
   ];
}
