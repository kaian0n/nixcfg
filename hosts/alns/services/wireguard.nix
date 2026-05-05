# /hosts/alns/services/wireguard.nix
{ config, pkgs, ... }:

{
   # Agenix secret declaration
   age.secrets.wireguard-private-key = {
      file = ../../../secrets/wireguard-private-key.age;
      owner = "root";
      group = "root";
      mode = "0400";
   };

   # WireGuard VPN server
   networking.wg-quick.interfaces.wg0 = {
      listenPort = 51820;
      privateKeyFile = config.age.secrets.wireguard-private-key.path;
      address = [ "10.100.0.1/24" ];

      peers = [
         {
            # Peer 1: macOS client
            publicKey = "OsOhgLfwCpQSTtzacIKbV2RGLWIFBHXBkt/4066+i18=";
            allowedIPs = [ "10.100.0.2/32" ];
            persistentKeepalive = 25;
         }
      ];
   };

   networking.firewall = {
      interfaces.eno1.allowedUDPPorts = [
         51820  # Public WireGuard endpoint from the router port-forward.
      ];
      interfaces.wg0.allowedTCPPorts = [
         22  # SSH admin over WireGuard.
      ];
   };

   environment.systemPackages = [ pkgs.wireguard-tools ];
}
