# /hosts/alns/services/homepage.nix
{ config, lib, ... }:
{
   services.homepage-dashboard = {
      enable = true;
      listenPort = 8080;
      allowedHosts = "localhost:8080,127.0.0.1:8080,${config.networking.hostName}:8080";
      customCSS = ''
         :root {
           --accent: #ff3f00;
           --bg: #7a251e;
           --fg: #d0b989;
         }
      '';
      services = [
         {
            "Media" = [
               {
                  "Jellyfin" = {
                     href = "http://${config.networking.hostName}:8096";
                     icon = "jellyfin";
                     description = "Media streaming";
                  };
               }
               {
                  "Immich" = {
                     href = "http://${config.networking.hostName}:2283";
                     icon = "immich";
                     description = "Photo management";
                  };
               }
            ];
         }
      ];
   };
}
