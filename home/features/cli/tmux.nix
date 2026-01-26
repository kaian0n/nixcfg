# /home/features/cli/tmux.nix
{ config, lib, pkgs, ... }:
with lib;
let
   cfg = config.features.cli.tmux;
in {
   options.features.cli.tmux.enable = mkEnableOption "enable tmux (replaces zellij in bindings)";

   config = mkIf cfg.enable {
      programs.tmux = {
         enable = true;
         terminal = "tmux-256color";
         mouse = true;
         keyMode = "vi";
         escapeTime = 0;
         historyLimit = 100000;
         extraConfig = ''
            # ---- Red Sands-ish status ----
            set -g status-style "bg=#772822,fg=#FDF0D5"
            set -g message-style "bg=#E9B489,fg=#772822"
            set -g pane-border-style "fg=#772822"
            set -g pane-active-border-style "fg=#E9B489"

            # Better splits + copy
            bind -n C-s setw synchronize-panes
            bind | split-window -h -c "#{pane_current_path}"
            bind - split-window -v -c "#{pane_current_path}"
            bind-key -T copy-mode-vi y send -X copy-selection-and-cancel

            # Sensible defaults
            set -g renumber-windows on
            set -g base-index 1
            setw -g pane-base-index 1
         '';
      };

      # Ensure terminfo is present for tmux-256color (some themes depend on it)
      home.packages = [ pkgs.ncurses ];
   };
}
