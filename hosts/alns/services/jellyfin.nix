# /hosts/alns/services/jellyfin.nix
{ pkgs, ... }:
{
   services.jellyfin = {
      enable = true;
      openFirewall = false;  # Cloudflare Tunnel can reach localhost without exposing 8096 on the LAN.
   };

   # Jellyfin needs GPU access for hardware transcoding.
   users.users.jellyfin.extraGroups = [ "video" "render" ];

   # Force Intel media driver (iHD) for Arc GPU.
   environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
   };

   systemd.services.jellyfin.serviceConfig = {
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectHome = true;
      ProtectSystem = "strict";
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      RestrictSUIDSGID = true;
      LockPersonality = true;
      SystemCallArchitectures = "native";

      # Jellyfin should be able to read media, but not rewrite the media disk by default.
      ReadOnlyPaths = [ "/media" ];
      ReadWritePaths = [
         "/var/lib/jellyfin"
         "/var/cache/jellyfin"
         "/var/log/jellyfin"
      ];

      # Hardware transcoding needs access to Intel GPU render devices.
      DevicePolicy = "closed";
      DeviceAllow = [
         "/dev/dri/renderD* rwm"
         "/dev/dri/card* rwm"
      ];
   };

   environment.systemPackages = with pkgs; [
      jellyfin-ffmpeg  # Jellyfin's optimized ffmpeg with QSV/VAAPI
   ];
}
