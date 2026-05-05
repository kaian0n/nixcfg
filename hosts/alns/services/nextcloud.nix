# /hosts/alns/services/nextcloud.nix
{ config, lib, pkgs, ... }:

let
   nextcloudHostName = "nc.alnsweb.com";
   nextcloudLocalPort = 8082;
in {
   age.secrets.nextcloud-admin-pass = {
      file = ../../../secrets/nextcloud-admin-pass.age;
      owner = "root";
      group = "root";
      mode = "0400";
   };

   services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud32;

      # Public hostname used by browsers and Nextcloud clients.
      # The NixOS module also adds this as a trusted Nextcloud domain.
      hostName = nextcloudHostName;

      # Tell Nextcloud/PHP that the external-facing URL is HTTPS.
      https = true;

      # Keep all Nextcloud state on /var, which is on the encrypted SSD-backed ZFS pool.
      # Do not point this at /media; /media is the HDD-backed Jellyfin disk.
      home = "/var/lib/nextcloud";
      datadir = "/var/lib/nextcloud/data";

      # Origin-side upload limits. Cloudflare may still impose its own request-size limits.
      maxUploadSize = "16G";

      # Use local PostgreSQL and Redis managed by the NixOS module.
      database.createLocally = true;
      configureRedis = true;

      # Initial admin user. The password file is only used during first setup.
      config = {
         dbtype = "pgsql";
         adminuser = "al";
         adminpassFile = config.age.secrets.nextcloud-admin-pass.path;
      };

      settings = {
         # Cloudflared connects to nginx from 127.0.0.1.
         trusted_proxies = [
            "127.0.0.1"
         ];

         # Users see HTTPS at Cloudflare even though the local origin is plain HTTP.
         overwritehost = nextcloudHostName;
         overwriteprotocol = "https";
         "overwrite.cli.url" = "https://${nextcloudHostName}";

         default_phone_region = "US";

         # Avoid public user profile pages by default.
         "profile.enabled" = false;
      };
   };

   # The Nextcloud module creates this nginx virtual host.
   # Bind it only to loopback so only cloudflared on this same server can reach it.
   services.nginx.virtualHosts.${nextcloudHostName}.listen = lib.mkForce [
      {
         addr = "127.0.0.1";
         port = nextcloudLocalPort;
      }
   ];
}
