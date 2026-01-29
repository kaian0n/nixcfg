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

      environment = {
         # Force Go resolver to use these DNS servers
         GODEBUG = "netdns=go";
      };

      serviceConfig = {
         Restart = "on-failure";
         RestartSec = "5s";
         # Use systemd's DNS override for this unit
         BindReadOnlyPaths = [
            "${pkgs.writeText "resolv.conf" ''
               nameserver 8.8.8.8
               nameserver 1.1.1.1
            ''}:/etc/resolv.conf"
         ];
      };

      script = ''
         TOKEN=$(cat ${config.age.secrets.cloudflared-token.path})
         exec ${pkgs.cloudflared}/bin/cloudflared tunnel \
           --no-autoupdate \
           --edge-ip-version 4 \
           --protocol http2 \
           run --token "$TOKEN"
      '';
   };
}
