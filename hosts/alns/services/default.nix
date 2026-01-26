# /hosts/alns/services/default.nix
{
   imports = [
      ./containers
      ./immich.nix
      ./homepage.nix
      ./postgresql-backup.nix
   ];
}
