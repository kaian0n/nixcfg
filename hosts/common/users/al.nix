{
  config,
  pkgs,
  inputs,
  ...
}: {
  users.users.al = {
    initialHashedPassword = "$y$j9T$j7Vz30P1VxEZ0kFMzoK92.$ZS6qOgOnZwx4hoGYnozzHva2GuF/AkVDFXdOfXohgm3";
    isNormalUser = true;
    description = "al";
    extraGroups = [
      "networkmanager"
      "wheel"
      "flatpak"
      "audio"
      "video"
      "plugdev"
      "input"
    ];
   openssh.authorizedKeys.keys = [
     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGkaAXy+lhmq0WhrVCbcFukYLZBWyLAjiSdO6M+YCdVU linsenmannalex@proton.me"
   ];
   packages = [inputs.home-manager.packages.${pkgs.system}.default];
  };
  home-manager.users.al=
     import al/${config.networking.hostName}.nix;
}
