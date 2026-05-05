# /hosts/alns/services/default.nix
{
   imports = [
      ./containers
      ./jellyfin.nix
      ./nextcloud.nix
      ./homepage.nix
      ./postgresql-backup.nix
      ./wireguard.nix
      ./cloudflared.nix
   ];
}
