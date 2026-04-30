# /overlays/default.nix
{ inputs, ... }:
{
   # Bring custom packages from ./pkgs.
   additions = final: _prev: import ../pkgs { pkgs = final; };

   # Reserved for future overrides.
   modifications = final: prev: { };

   # Keep unstable explicit instead of making the whole server track unstable.
   unstable-packages = final: _prev: {
      unstable = import inputs.nixpkgs-unstable {
         system = final.system;
         config = { allowUnfree = true; };
      };
   };
}
