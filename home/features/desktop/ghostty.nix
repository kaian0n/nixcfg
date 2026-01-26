# /home/features/desktop/ghostty.nix
{ config, lib, pkgs, ... }:
with lib;
let
   cfg = config.features.desktop.ghostty;
in {
   options.features.desktop.ghostty.enable = mkEnableOption "enable Ghostty terminal with custom config";

   config = mkIf cfg.enable {
      home.packages = [ pkgs.ghostty ];
      home.file.".config/ghostty/config".text = ''
# Font size
font-size = 11
# Hide mouse while typing
mouse-hide-while-typing = true
# Font family with Nerd icons
font-family = MesloLGS Nerd Font Mono
# Transparent titlebar on macOS
macos-titlebar-style = transparent
# iTerm2 Red Sands palette
theme = Red Sands
# 95% background opacity
background-opacity = 0.95
# Font weight (regular) - replaced with variation
font-variation = wght=400
# Block cursor
cursor-style = block
# Copy shortcut
keybind = ctrl+shift+c=copy_to_clipboard
# Paste shortcut
keybind = ctrl+shift+v=paste_from_clipboard
# Shell integration for OSC sequences
shell-integration = detect
# Window padding horizontal
window-padding-x = 10
# Window padding vertical
window-padding-y = 10
      '';
   };
}
