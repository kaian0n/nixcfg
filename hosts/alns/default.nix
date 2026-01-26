# /hosts/alns/default.nix
{
   imports = [
      ../common
      ./configuration.nix
      ./services
   ];

   "extra-services".podman.enable = true;
}
