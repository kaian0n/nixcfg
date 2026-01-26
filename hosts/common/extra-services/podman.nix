# /hosts/common/extra-services/podman.nix
{ pkgs, config, lib, ... }:
with lib;
let
   cfg = config."extra-services".podman;
in {
   options."extra-services".podman.enable = mkEnableOption "enable podman";

   config = mkIf cfg.enable {
      virtualisation = {
         oci-containers.backend = "podman";
         podman = {
            enable = true;
            dockerCompat = true;
            autoPrune = {
               enable = true;
               dates = "weekly";
               flags = [
                  "--filter=until=24h"
                  "--filter=label!=important"
               ];
            };
            defaultNetwork.settings.dns_enabled = true;
         };
      };
      environment.systemPackages = with pkgs; [
         podman-compose
      ];
   };
}
