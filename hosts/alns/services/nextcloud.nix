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

      # Nix owns the Nextcloud app directories. Do not let the web UI
      # install or update apps into read-only Nix store paths.
      appstoreEnable = false;
      autoUpdateApps.enable = false;

      # Tell Nextcloud/PHP that the external-facing URL is HTTPS.
      https = true;

      # Keep all Nextcloud state on /var, which is on the encrypted SSD-backed ZFS pool.
      # The NixOS module creates the actual uploaded-file directory at /var/lib/nextcloud/data.
      # Do not point this at /media; /media is the HDD-backed Jellyfin disk.
      home = "/var/lib/nextcloud";
      datadir = "/var/lib/nextcloud";

      # Origin-side upload limits. Cloudflare may still impose its own request-size limits.
      maxUploadSize = "16G";

      # Use local PostgreSQL and Redis managed by the NixOS module.
      database.createLocally = true;
      configureRedis = true;
      caching.redis = true;
      caching.apcu = true;

      # The default is 8; Nextcloud is warning that this is nearly full.
      phpOptions."opcache.interned_strings_buffer" = "32";

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

         # US phone-number validation default.
         default_phone_region = "US";

         # Run heavy background jobs starting at 09:00 UTC, which is 03:00 MDT.
         maintenance_window_start = 9;

         # Avoid public user profile pages by default.
         "profile.enabled" = false;

         # No SMTP for now. Create local users with passwords instead of emailed invites.
         mail_smtpmode = "null";

         # Make cache settings explicit. The NixOS module also sets these when
         # configureRedis = true, but keeping them here makes the intent obvious.
         "memcache.local" = "\\OC\\Memcache\\APCu";
         "memcache.distributed" = "\\OC\\Memcache\\Redis";
         "memcache.locking" = "\\OC\\Memcache\\Redis";
         redis = {
            host = config.services.redis.servers.nextcloud.unixSocket;
            port = 0;
         };
      };
   };

   # Do not send welcome emails while SMTP is intentionally disabled.
   # This makes user creation work with a local password-only workflow.
   systemd.services.nextcloud-disable-new-user-email = {
      description = "Disable Nextcloud welcome email for new local users";
      after = [ "nextcloud-setup.service" ];
      requires = [ "nextcloud-setup.service" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
         USER = "root";
      };

      serviceConfig = {
         Type = "oneshot";
      };

      script = ''
         ${config.services.nextcloud.occ}/bin/nextcloud-occ \
            config:app:set core newUser.sendEmail --value no
      '';
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
