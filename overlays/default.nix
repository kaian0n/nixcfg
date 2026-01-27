# /overlays/default.nix
{ inputs, ... }:
{
   # Bring custom packages from ./pkgs
   additions = final: _prev: import ../pkgs { pkgs = final; };

   # Reserved for future overrides
   modifications = final: prev: { };

   # Stable channel as an attribute set
   stable-packages = final: _prev: {
      stable = import inputs.nixpkgs-stable {
         system = final.system;
         config = { allowUnfree = true; };
      };
   };
}
