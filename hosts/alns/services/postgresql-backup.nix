# /hosts/alns/services/postgresql-backup.nix
{ config, lib, ... }:
{
   services.postgresqlBackup = {
      enable = true;
      location = "/var/backup/postgresql";
      startAt = "Sun 03:30";   # weekly, Sunday at 03:30 local time
   };

   # Ensure backup directory exists with sane ownership
   systemd.tmpfiles.rules = [ "d /var/backup/postgresql 0750 postgres postgres - -" ];
}
