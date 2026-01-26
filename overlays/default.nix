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

   # Ghostty from its flake, pinned via inputs
   ghostty = final: prev: {
      ghostty = inputs.ghostty.packages.${prev.stdenv.hostPlatform.system}.default;
   };
}
