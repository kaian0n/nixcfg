# /hosts/alns/services/immich.nix
{
   services.immich = {
      enable = true;

      # Keep Immich private unless you explicitly publish it through Cloudflare Access or WireGuard.
      host = "127.0.0.1";
      port = 2283;
      openFirewall = false;

      # data
      mediaLocation = "/var/lib/immich";

      # these are default true; no need to pin unless you want the documentation effect
      # database.enable = true;
      # redis.enable = true;
   };
}
