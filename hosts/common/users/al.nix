# hosts/common/users/al.nix
{
   config,
   pkgs,
   inputs,
   ...
}:{
   users.users.al = {
      initialHashedPassword = "$y$j9T$LxxaDd7WC3yyF0FKWZ0bq0$xBrBc6YyAFKxe4WwYpRrWt/bzKkFmopoGJNO3uelvM4";
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
         "kvm"
         "qemu-libvirtd"
         "libvirtd" #maybe dont need on nonvm
      ];
      openssh.authorizedKeys.keys = [
         "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGkaAXy+lhmq0WhrVCbcFukYLZBWyLAjiSdO6M+YCdVU linsenmannalex@proton.me"
      ];
   };
   home-manager.users.al =
      import ../../../home/al/${config.networking.hostName}.nix;
}
