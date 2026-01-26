# /hosts/alns/services/homepage.nix
{ config, lib, ... }:
{
   systemd.services.homepage-dashboard.environment = { HOMEPAGE_ALLOWED_HOSTS = lib.mkForce "*"; };

   services.homepage-dashboard = {
      enable = true;
      listenPort = 8080;
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
                  "Immich" = {
                     href = "http://${config.networking.hostName}:2283";
                     icon = "immich";
                  };
               }
            ];
         }
      ];
   };

   networking.firewall.allowedTCPPorts = [ 8080 ];
}
