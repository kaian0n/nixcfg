# /secrets/secrets.nix
# This file defines which public keys can decrypt which secrets.
# It is NOT imported into your NixOS config - it's only used by the agenix CLI.

let
   # Your personal SSH key (for encrypting secrets from your workstation)
   al = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGkaAXy+lhmq0WhrVCbcFukYLZBWyLAjiSdO6M+YCdVU";

   # Host SSH key - the server needs this to decrypt at boot
   # Get this by running on alns: cat /etc/ssh/ssh_host_ed25519_key.pub
   alns = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL+HrSqigFfS/Y2ZxHVkD2zT4uk6ZQdj5yHOj1NDoO3k root@alns";

   # Convenience groupings
   allUsers = [ al ];
   allHosts = [ alns ];
   all = allUsers ++ allHosts;
in {
   "wireguard-private-key.age".publicKeys = all;

   # Add more secrets as needed:
   # "some-api-token.age".publicKeys = all;
   # "database-password.age".publicKeys = all;
}
