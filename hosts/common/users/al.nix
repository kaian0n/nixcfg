# /hosts/common/users/al.nix
{ config, pkgs, inputs, ... }:
{
   users.users.al = {
      initialHashedPassword = "$y$j9T$2rKcpDUPt85kRtbkEtjJV1$G/ipa1BxfDf4aF4xWZjspcLh9p4sjFNlLFe32K4xMsD";
      isNormalUser = true;
      description = "al";
      extraGroups = [
         "wheel"
         "networkmanager"
         "flatpak"
         "audio"
         "video"
         "plugdev"
         "input"
      ];
      openssh.authorizedKeys.keys = [
         "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGkaAXy+lhmq0WhrVCbcFukYLZBWyLAjiSdO6M+YCdVU linsenmannalex@proton.me"
      ];
   };

   home-manager.users.al = import ../../../home/al/${config.networking.hostName}.nix;
}
