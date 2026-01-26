# /hosts/alns/services/containers/default.nix
{
   imports = [
      ./echo.nix
      ./nginx.nix
    ];
}
