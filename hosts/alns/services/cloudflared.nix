# /hosts/alns/services/cloudflared.nix
{ config, pkgs, ... }:

{
   users.groups.cloudflared = { };
   users.users.cloudflared = {
      isSystemUser = true;
      group = "cloudflared";
      home = "/var/lib/cloudflared";
      createHome = true;
   };

   age.secrets.cloudflared-token = {
      file = ../../../secrets/cloudflared-token.age;
      owner = "cloudflared";
      group = "cloudflared";
      mode = "0400";
   };

   systemd.services.cloudflared = {
      description = "Cloudflare Tunnel";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
         ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate --protocol auto run --token-file ${config.age.secrets.cloudflared-token.path} --dns-resolver-addrs 1.1.1.1:53 --dns-resolver-addrs 1.0.0.1:53";
         Restart = "on-failure";
         RestartSec = "10s";

         User = "cloudflared";
         Group = "cloudflared";
         UMask = "0077";

         NoNewPrivileges = true;
         PrivateTmp = true;
         PrivateDevices = true;
         ProtectHome = true;
         ProtectSystem = "strict";
         ProtectClock = true;
         ProtectControlGroups = true;
         ProtectKernelLogs = true;
         ProtectKernelModules = true;
         ProtectKernelTunables = true;
         RestrictSUIDSGID = true;
         LockPersonality = true;
         MemoryDenyWriteExecute = true;
         CapabilityBoundingSet = "";
         AmbientCapabilities = "";
         RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
         SystemCallArchitectures = "native";
         SystemCallFilter = [ "@system-service" "~@privileged" ];
      };
   };
}
