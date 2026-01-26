# /home/features/desktop/wayland.nix
{ config, lib, pkgs, ... }:
with lib;
let
   cfg = config.features.desktop.wayland;
in {
   options.features.desktop.wayland = {
      enable = mkEnableOption "wayland extra tools and config";

      weatherLocation = mkOption {
         type = types.str;
         default = "auto";
         example = "Boise,US-ID";
         description = "Location string passed to wttrbar (use 'auto' for IP-based).";
      };

      weatherUnit = mkOption {
         type = types.str;
         default = "metric";
         example = "imperial";
         description = "Units for wttrbar: 'metric' or 'imperial'.";
      };
   };

   config = mkIf cfg.enable {
      services.blueman-applet.enable = true;

      programs.waybar = {
         enable = true;

         style = ''
            /* ===== Red Sands Waybar palette ===== */
            :root {
               --rs-bg: #1f1917;
               --rs-panel: #772822;
               --rs-sand: #E9B489;
               --rs-accent: #C7522A;
               --rs-fg: #FDF0D5;
            }

            * {
               border: none;
               border-radius: 0;
               font-family: FiraCode Nerd Font;
               font-weight: bold;
               font-size: 16px;
               min-height: 0;
            }

            window#waybar {
               background: transparent;
               color: var(--rs-fg);
            }

            tooltip {
               background: var(--rs-panel);
               border-radius: 10px;
               border-width: 1px;
               border-style: solid;
               border-color: color-mix(in srgb, var(--rs-accent) 35%, transparent);
               color: var(--rs-fg);
            }

            #workspaces button {
               padding: 5px;
               color: color-mix(in srgb, var(--rs-fg) 40%, var(--rs-panel));
               margin-right: 5px;
               background: var(--rs-panel);
            }

            #workspaces button.active {
               color: #772822;
               background: var(--rs-sand);
               border-radius: 10px;
            }

            #workspaces button.focused {
               color: var(--rs-fg);
               background: color-mix(in srgb, var(--rs-accent) 65%, var(--rs-panel));
               border-radius: 10px;
            }

            #workspaces button.urgent {
               color: var(--rs-fg);
               background: var(--rs-accent);
               border-radius: 10px;
            }

            #workspaces button:hover {
               background: color-mix(in srgb, var(--rs-sand) 80%, var(--rs-panel));
               color: #772822;
               border-radius: 10px;
            }

            #custom-language,
            #custom-updates,
            #custom-caffeine,
            #custom-weather,
            #window,
            #clock,
            #battery,
            #pulseaudio,
            #network,
            #workspaces,
            #tray,
            #backlight {
               background: var(--rs-panel);
               color: var(--rs-fg);
               padding: 0px 10px;
               margin: 3px 0px;
               margin-top: 10px;
               border: 1px solid color-mix(in srgb, var(--rs-accent) 25%, transparent);
            }

            #tray {
               border-radius: 10px;
               margin-right: 10px;
            }

            #workspaces {
               border-radius: 10px;
               margin-left: 10px;
               padding-right: 0px;
               padding-left: 5px;
            }

            #custom-caffeine {
               color: var(--rs-sand);
               border-radius: 10px 0px 0px 10px;
               border-right: 0px;
               margin-left: 10px;
            }

            #custom-language {
               color: var(--rs-accent);
               border-left: 0px;
               border-right: 0px;
            }

            #custom-updates {
               color: var(--rs-sand);
               border-left: 0px;
               border-right: 0px;
            }

            #window {
               border-radius: 10px;
               margin-left: 60px;
               margin-right: 60px;
            }

            #clock {
               color: #772822;
               background: var(--rs-sand);
               border-radius: 10px 0px 0px 10px;
               margin-left: 0px;
               border-right: 0px;
            }

            #network {
               color: var(--rs-fg);
               border-left: 0px;
               border-right: 0px;
            }

            #pulseaudio {
               color: var(--rs-fg);
               border-left: 0px;
               border-right: 0px;
            }

            #pulseaudio.microphone {
               color: var(--rs-sand);
               border-left: 0px;
               border-right: 0px;
            }

            #battery {
               color: var(--rs-fg);
               border-radius: 0 10px 10px 0;
               margin-right: 10px;
               border-left: 0px;
            }

            #custom-weather {
               border-radius: 0px 10px 10px 0px;
               border-right: 0px;
               margin-left: 0px;
               color: var(--rs-fg);
            }
         '';

         # ✅ Correct Waybar config shape: a list of bar objects. Also 'mode' (not 'mod').
         settings = [
            {
               layer = "top";
               position = "top";
               mode = "dock";
               exclusive = true;
               passthrough = false;
               height = 40;

               "modules-left" = [ "clock" "custom/weather" "hyprland/workspaces" ];
               "modules-center" = [ "hyprland/window" ];
               "modules-right" = [ "tray" ];

               "hyprland/window" = {
                  format = "👉 {}";
                  separate-outputs = true;
               };

               "hyprland/workspaces" = {
                  disable-scroll = true;
                  all-outputs = true;
                  on-click = "activate";
                  format = " {name} {icon} ";
                  on-scroll-up = "hyprctl dispatch workspace e+1";
                  on-scroll-down = "hyprctl dispatch workspace e-1";
                  format-icons = {
                     "1" = ""; "2" = ""; "3" = ""; "4" = "";
                     "5" = ""; "6" = ""; "7" = "";
                  };
                  persistent_workspaces = {
                     "1" = [ ]; "2" = [ ]; "3" = [ ]; "4" = [ ];
                  };
               };

               "custom/weather" = {
                  format = "{}°";
                  tooltip = true;
                  interval = 3600;
                  exec = "wttrbar --location ${cfg.weatherLocation} --unit ${cfg.weatherUnit}";
                  "return-type" = "json";
               };

               tray = {
                  "icon-size" = 13;
                  spacing = 10;
               };

               clock = {
                  format = " {:%R  %m/%d}";
                  "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
               };
            }
         ];
      };

      home.packages = with pkgs; [
         grim
         hyprlock
         qt6.qtwayland
         slurp
         waypipe
         wf-recorder
         wl-mirror
         wl-clipboard
         wlogout
         wtype
         ydotool
         wttrbar
         hyprpaper
         hypridle
         cliphist
         bemoji
         wofi-pass
      ];
   };
}
