# /hosts/alns/services/cloudflared.nix
{ config, pkgs, ... }:

{
   age.secrets.cloudflared-token = {
      file = ../../../secrets/cloudflared-token.age;
      owner = "root";
      group = "root";
      mode = "0400";
   };

   systemd.services.cloudflared = {
      description = "Cloudflare Tunnel";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      script = ''
         TOKEN=$(cat ${config.age.secrets.cloudflared-token.path})
         exec ${pkgs.cloudflared}/bin/cloudflared tunnel \
           --no-autoupdate \
           --edge-ip-version 4 \
           run --token "$TOKEN"
      '';

      serviceConfig = {
         Restart = "on-failure";
         RestartSec = "5s";
      };
   };
}
