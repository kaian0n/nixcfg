# /hosts/alns/services/immich.nix
{
   services.immich = {
      enable = true;

      # network
      host = "0.0.0.0";   # keep v4 + LAN bind (use "127.0.0.1" if you want local-only)
      port = 2283;
      openFirewall = true;

      # data
      mediaLocation = "/var/lib/immich";

      # these are default true; no need to pin unless you want the documentation effect
      # database.enable = true;
      # redis.enable = true;
   };
}
