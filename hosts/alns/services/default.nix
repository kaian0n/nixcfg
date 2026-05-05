# /hosts/alns/services/default.nix
{
   imports = [
      ./containers
      ./immich.nix
      ./jellyfin.nix
      ./nextcloud.nix
      ./homepage.nix
      ./postgresql-backup.nix
      ./wireguard.nix
      ./cloudflared.nix
   ];
}
