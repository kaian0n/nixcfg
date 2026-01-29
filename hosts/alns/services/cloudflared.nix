# /hosts/alns/services/cloudflared.nix
{ config, ... }:

{
   age.secrets.cloudflared-token = {
      file = ../../../secrets/cloudflared-token.age;
      owner = "cloudflared";
      group = "cloudflared";
   };

   services.cloudflared = {
      enable = true;
      tunnels = {
         "alns" = {
            credentialsFile = config.age.secrets.cloudflared-token.path;
            default = "http_status:404";
            ingress = {
               "jellyfin.alnsweb.com" = "http://localhost:8096";
               "immich.alnsweb.com" = "http://localhost:2283";
               "home.alnsweb.com" = "http://localhost:8080";
            };
         };
      };
   };
}
