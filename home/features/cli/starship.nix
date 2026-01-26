# /home/features/cli/starship.nix
{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.features.cli.starship;
in {
  options.features.cli.starship.enable = mkEnableOption "enable starship prompt";

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      package = pkgs.starship;
      # We init Starship ourselves in zsh.nix (to skip local tty cleanly).
      enableZshIntegration = false;
    };

    # macOS-style Starship config ported as valid TOML
    home.file.".config/starship.toml".text = ''
# ~/.config/starship.toml

# Palette:
# Red-Orange: #C7522A
# Sand:       #E9B489
# Off-White:  #FDF0D5
# Red Sands BG: #772822

format = """
[░▒▓](#E9B489)\
[  ](bg:#E9B489 fg:#772822)\
[](bg:#E9B489 fg:#E9B489)\
$directory\
[](fg:#E9B489 bg:#E9B489)\
$git_branch\
$git_status\
$nodejs\
$rust\
$golang\
$php\
$time\
[ ](fg:#E9B489)\
\n$character"""

[directory]
style = "fg:#772822 bg:#E9B489"
format = "[ $path ]($style)"
truncation_length = 3
truncation_symbol = "…/"

[directory.substitutions]
"Documents" = "󰈙 "
"Downloads" = " "
"Music"     = " "
"Pictures"  = " "

[git_branch]
symbol = ""
style  = "bg:#E9B489"
format = '[[ $symbol $branch ](fg:#772822 bg:#E9B489)]($style)'

[git_status]
style  = "bg:#E9B489"
format = '[[($all_status$ahead_behind )](fg:#772822 bg:#E9B489)]($style)'

[nodejs]
symbol = ""
style  = "bg:#E9B489"
format = '[[ $symbol ($version) ](fg:#772822 bg:#E9B489)]($style)'

[rust]
symbol = ""
style  = "bg:#E9B489"
format = '[[ $symbol ($version) ](fg:#772822 bg:#E9B489)]($style)'

[golang]
symbol = ""
style  = "bg:#E9B489"
format = '[[ $symbol ($version) ](fg:#772822 bg:#E9B489)]($style)'

[php]
symbol = ""
style  = "bg:#E9B489"
format = '[[ $symbol ($version) ](fg:#772822 bg:#E9B489)]($style)'

[time]
disabled    = false
time_format = "%R"
style       = "bg:#E9B489"
format      = '[[  $time ](fg:#772822 bg:#E9B489)]($style)'

[character]
success_symbol = "[❯](#E9B489)"
error_symbol   = "[❯](#C7522A)"
'';
  };
}
