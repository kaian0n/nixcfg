# /hosts/common/users/al.nix
{ config, pkgs, inputs, ... }:
{
   age.secrets.al-password-hash = {
      file = ../../../secrets/al-password-hash.age;
      owner = "root";
      group = "root";
      mode = "0400";
   };

   users.mutableUsers = false;

   users.users.al = {
      hashedPasswordFile = config.age.secrets.al-password-hash.path;
      isNormalUser = true;
      description = "al";
      extraGroups = [
         "wheel"
         "networkmanager"
      ];
      openssh.authorizedKeys.keys = [
         "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGkaAXy+lhmq0WhrVCbcFukYLZBWyLAjiSdO6M+YCdVU linsenmannalex@proton.me"
      ];
   };

   home-manager.users.al = import ../../../home/al/${config.networking.hostName}.nix;
}
