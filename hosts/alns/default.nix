# /hosts/alns/default.nix
{
   imports = [
      ../common
      ./configuration.nix
      ./services
      ./secrets.nix
   ];

   "extra-services".podman.enable = true;
}
