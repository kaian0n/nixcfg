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
        export COLORTERM="''${COLORTERM:-truecolor}"
      '';

      initContent = ''
        if [[ $- == *i* ]]; then
          is_local_linux_tty() {
            [[ -z "$SSH_CONNECTION$SSH_TTY" ]] && \
            [[ -z "$DISPLAY$WAYLAND_DISPLAY" ]] && \
            { [[ "$TERM" = linux ]] || [[ "''${XDG_SESSION_TYPE:-}" = tty ]] || [[ -n "''${XDG_VTNR:-}" ]]; }
          }

          if is_local_linux_tty; then
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
        list_media_storage = "df -B1 --output=avail /media | awk 'NR==2 {printf \"%.2f TB free on /media\\n\", $1/1000000000000}'";
      };
    };
  };
}
