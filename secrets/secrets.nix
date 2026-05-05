# /secrets/secrets.nix
let
   al = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGkaAXy+lhmq0WhrVCbcFukYLZBWyLAjiSdO6M+YCdVU";
   alns = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL+HrSqigFfS/Y2ZxHVkD2zT4uk6ZQdj5yHOj1NDoO3k root@alns";

   allUsers = [ al ];
   allHosts = [ alns ];
   all = allUsers ++ allHosts;
in {
   "al-password-hash.age".publicKeys = all;
   "nextcloud-admin-pass.age".publicKeys = all;
   "wireguard-private-key.age".publicKeys = all;
   "cloudflared-token.age".publicKeys = all;
}
