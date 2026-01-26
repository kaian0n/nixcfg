# /hosts/common/users/al.nix
{ config, pkgs, inputs, ... }:
{
  users.users.al = {
    initialHashedPassword = "$y$j9T$hkbcNcSVU6meI8SVcz2/10$iElppu6DicE7qd3CKiVISN47Ep/IaJoeJL4pvMns9.3";
    isNormalUser = true;
    description = "al";
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "flatpak"
      "audio"
      "video"
      "plugdev"
      "input"
      "qemu-libvirtd"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICqyyU56DPcUBpsvOxSZmLSvfxj5ltrNNR0sFMeOe4Xl alex@alns"
    ];
  };
  home-manager.users.al = import al/${config.networking.hostName}.nix;

}
