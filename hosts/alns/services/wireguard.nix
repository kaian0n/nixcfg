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

   networking.nat = {
      enable = true;
      externalInterface = "eno1";
      internalInterfaces = [ "wg0" ];
   };

   boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
   };

   networking.firewall = {
      allowedUDPPorts = [ 51820 ];
      interfaces.wg0.allowedTCPPorts = [
         22    # SSH admin over VPN
         8080  # Homepage over VPN
         8096  # Jellyfin over VPN
      ];
   };

   environment.systemPackages = [ pkgs.wireguard-tools ];
}
