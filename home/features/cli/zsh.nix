# /home/features/cli/zsh.nix
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.cli.zsh;
in {
  options.features.cli.zsh.enable = mkEnableOption "enable extended zsh configuration";

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      profileExtra = ''
        export NIX_LOG=info
        export Terminal=ghostty
        # Ensure 24-bit color everywhere (helps SSH sessions render hex colors properly)
        export COLORTERM="''${COLORTERM:-truecolor}"
      '';

      # Use initContent (initExtra is deprecated).
      # Disable Starship only on a local Linux VT (no GUI, no SSH).
      # Fallback prompt uses '>' for user, '#' for root.
      initContent = ''
        if [[ $- == *i* ]]; then
          is_local_linux_tty() {
            # Not SSH, no GUI env, and looks like a VT session
            [[ -z "$SSH_CONNECTION$SSH_TTY" ]] && \
            [[ -z "$DISPLAY$WAYLAND_DISPLAY" ]] && \
            { [[ "$TERM" = linux ]] || [[ "''${XDG_SESSION_TYPE:-}" = tty ]] || [[ -n "''${XDG_VTNR:-}" ]]; }
          }

          if is_local_linux_tty; then
            # Simple, readable prompt for the console; '>' for user, '#' for root.
            PROMPT='%n@%m:%~ %(!.#.>) '
            unset RPROMPT
          else
            eval "$(${pkgs.starship}/bin/starship init zsh)"
          fi
        fi
      '';

      shellAliases = {
        ls = "eza";
        grep = "rg";
      };
    };
  };
}
