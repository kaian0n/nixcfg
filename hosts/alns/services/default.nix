# /hosts/alns/services/default.nix
{
   imports = [
      ./containers
      ./immich.nix
      ./jellyfin.nix
      ./homepage.nix
      ./postgresql-backup.nix
   ];
}
