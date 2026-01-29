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

      postUp = ''
         ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
         ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
      '';
      postDown = ''
         ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
         ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
      '';

      peers = [
         {
            # Peer 1: Replace with actual client public key
            publicKey = "REPLACE_WITH_CLIENT_PUBLIC_KEY";
            allowedIPs = [ "10.100.0.2/32" ];
            persistentKeepalive = 25;
         }
      ];
   };

   boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
   };

   networking.firewall = {
      allowedUDPPorts = [ 51820 ];
      trustedInterfaces = [ "wg0" ];
   };

   environment.systemPackages = [ pkgs.wireguard-tools ];
}
