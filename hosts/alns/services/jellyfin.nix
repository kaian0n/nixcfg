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

   # These directories must exist before systemd applies ReadWritePaths.
   systemd.tmpfiles.rules = [
      "d /var/lib/jellyfin 0750 jellyfin jellyfin - -"
      "d /var/lib/jellyfin/log 0750 jellyfin jellyfin - -"
      "d /var/cache/jellyfin 0750 jellyfin jellyfin - -"
   ];

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
      # The leading "-" means: do not fail startup if /media is temporarily absent.
      ReadOnlyPaths = [ "-/media" ];

      # With ProtectSystem=strict, the filesystem is read-only unless explicitly opened.
      # Jellyfin needs these writable for its database, config, logs, cache, and transcode cache.
      ReadWritePaths = [
         "/var/lib/jellyfin"
         "/var/cache/jellyfin"
      ];

      # Hardware transcoding needs DRM/render device access.
      DevicePolicy = "closed";
      DeviceAllow = [
         "char-drm rw"
      ];
   };

   environment.systemPackages = with pkgs; [
      jellyfin-ffmpeg  # Jellyfin's optimized ffmpeg with QSV/VAAPI
   ];
}
