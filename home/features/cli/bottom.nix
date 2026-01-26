# /home/features/cli/bottom.nix
{ config, lib, pkgs, ... }:
with lib;
let
   cfg = config.features.cli.bottom;
in {
   options.features.cli.bottom.enable = mkEnableOption "enable bottom process viewer";

   config = mkIf cfg.enable {
      home.packages = [ pkgs.bottom ];

      home.file.".config/bottom/bottom.toml".text = ''
[styles.tables]
headers = { color = "#E9B489" }

[styles.cpu]
all_entry_color = "#e6af00"
avg_entry_color = "#ba0000"
cpu_core_colors = ["#ff3f00", "#e6af00", "#00ba00", "#0072ff", "#ba00ba", "#00baba", "#bababa", "#ba0000", "#ff3f00", "#e6af00", "#00ba00", "#0072ff", "#ba00ba", "#00baba", "#bababa", "#ba0000"]

[styles.memory]
ram_color = "#C7522A"
cache_color = "#FDF0D5"
swap_color = "#C7522A"
arc_color = "#E9B489"
gpu_colors = ["#ff3f00", "#e6af00", "#00ba00", "#C7522A"]

[styles.network]
rx_color = "#E9B489"
tx_color = "#C7522A"
rx_total_color = "#E9B489"
tx_total_color = "#C7522A"

[styles.temp]
temp_color = "#C7522A"

[styles.disk]
disk_color = "#E9B489"

[styles.widgets]
border_color = "#C7522A"
selected_border_color = "#C7522A"
text = { color = "#E9B489" }
selected_text = { color = "#772822", bg_color = "#E9B489" }
widget_title = { color = "#E9B489" }

[styles.graphs]
graph_color = "#E9B489"

[styles.battery]
high_battery_color = "#E9B489"
medium_battery_color = "#FDF0D5"
low_battery_color = "#C7522A"
      '';
   };
}
