# /hosts/alns/scripts/default.nix
{ config, pkgs, ... }:

{
   check_storage = pkgs.stdenvNoCC.mkDerivation {
      pname = "alns-check-storage";
      version = "1.0.0";

      src = ./check_storage;

      dontUnpack = true;

      nativeBuildInputs = [
         pkgs.makeWrapper
      ];

      installPhase = ''
         runHook preInstall

         install -Dm0755 "$src" "$out/bin/check_storage"
         patchShebangs "$out/bin/check_storage"

         wrapProgram "$out/bin/check_storage" \
            --set NEXTCLOUD_OCC "${config.services.nextcloud.occ}/bin/nextcloud-occ" \
            --prefix PATH : ${pkgs.lib.makeBinPath [
               pkgs.coreutils
               pkgs.gawk
               pkgs.gnused
               pkgs.util-linux
               config.boot.zfs.package
            ]}

         runHook postInstall
      '';
   };
}
