# home/features/desktop/hyprland.nix
{
   config,
   lib, ...
}:
with lib; let
   cfg = config.features.desktop.hyprland;
in {
   options.features.desktop.hyprland.enable = mkEnableOption "hyprland window manager";
   config = mkIf cfg.enable {
      wayland.windowManager.hyprland = {
         enable = true;
         settings = {
            "$mainMod" = "SUPER";
            "$terminal" = "kitty";
            xwayland = {
               force_zero_scaling = true;
            };
            exec-once = [
               "waybar"
               "hyprpaper"
               "hyprpaper-random"
               "hypridle"
               "wl-paste --type text --watch cliphist store"
               "wl-paste --type image --watch cliphist store"
               "wl-paste -p -t text --watch clipman store -P --histpath=\"~/.local/share/clipman-primary.json\""
               "xwaylandvideobridge"
            ];
            env = [
               "XCURSOR_SIZE,32"
               "GTK_THEME,Dracula"
               "HYPRCURSOR_THEME,Bibata-Modern-Ice"
               "WLR_NO_HARDWARE_CURSORS,1"
            ];
            input = {
               kb_layout = "us";
               kb_variant = "";
               kb_model = "";
               kb_options = "ctrl:nocaps";
               kb_rules = "";
               follow_mouse = 1;
               sensitivity = 0;
               touchpad = {
                  natural_scroll = true;
               };
            };
            general = {
               gaps_in = 5;
               gaps_out = 5;
               border_size = 1;
               "col.active_border" = "rgba(9742b5ee) rgba(9742b5ee) 45deg";
               "col.inactive_border" = "rgba(595959aa)";
               layout = "dwindle";
            };
            decoration = {
               rounding = 8;
               active_opacity = 0.9;
               inactive_opacity = 0.5;
               drop_shadow = true;
               shadow_range = 60;
               shadow_render_power = 3;
               "col.shadow" = "rgba(1E202966)";
               blur = {
                  enabled = true;
                  size = 3;
                  passes = 3;
               };
            };
            animations = {
               enabled = true;
               bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
               animation = [
                  "windows, 1, 7, myBezier"
                  "windowsOut, 1, 7, default, popin 80%"
                  "border, 1, 10, default"
                  "borderangle, 1, 8, default"
                  "fade, 1, 7, default"
                  "workspaces, 1, 6, default"
               ];
            };
            dwindle = {
               pseudotile = true;
               preserve_split = true;
            };
            master = {
               new_is_master = true;
            };
            gestures = {
               workspace_swipe = false;
            };
            windowrule = [
               "float, class:file_progress"
               "float, class:confirm"
               "float, class:dialog"
               "float, class:download"
               "float, class:notification"
               "float, class:error"
               "float, class:splash"
               "float, class:confirmreset"
               "float, title:Open File"
               "float, title:branchdialog"
               "float, Lxappearance"
               "float, Wofi"
               "float, dunst"
               "animation none,Wofi"
               "float,viewnior"
               "float,feh"
               "float, class:pavucontrol-qt"
               "float, class:pavucontrol"
               "float, file-roller"
               "fullscreen, class:wlogout"
               "float, title:wlogout"
               "fullscreen, title:wlogout"
               "float, class:mpv"
               "idleinhibit focus, class:mpv"
               "idleinhibit fullscreen, firefox"
               "opacity 1.0 override, class:mpv"
               "float, title:^(Media viewer)$"
               "float, title:^(Volume Control)$"
               "float, title:^(Picture-in-Picture)$"
               "size 800 600, title:^(Volume Control)$"
               "move 75 44%, title:^(Volume Control)$"
               "float,title:^(floating-pomodoro)$"
               "size 250 50, title:^(floating-pomodoro)$"
               "move 12 100%-150,title:^(floating-pomodoro)$"
               "pin,title:^(floating-pomodoro)$"
               "float, initialTitle:.*streamlabs.com.*"
               "pin, initialTitle:.*streamlabs.com.*"
               "size 800 400, initialTitle:.*streamlabs.com.*"
               "move 100%-820 102, initialTitle:.*alert-box.*"
               "move 100%-820 512, initialTitle:.*chat-box.*"
               "opacity 0.5 override, initialTitle:.*streamlabs.com.*"
               "idleinhibit focus, initialTitle:.*streamlabs.com.*"
               "noanim, initialTitle:.*streamlabs.com.*"
               "noborder, initialTitle:.*streamlabs.com.*"
               "noshadow, initialTitle:.*streamlabs.com.*"
               "noblur, initialTitle:.*streamlabs.com.*"
               "opacity 0.0 override, class:^(xwaylandvideobridge)$"
               "noanim, class:^(xwaylandvideobridge)$"
               "noinitialfocus, class:^(xwaylandvideobridge)$"
               "maxsize 1 1, class:^(xwaylandvideobridge)$"
               "noblur, class:^(xwaylandvideobridge)$"
               "nofocus, class:^(xwaylandvideobridge)$"
            ];
            windowrulev2 = [
               "workspace 1, class:(Emacs)"
               "workspace 3, class:(brave-browser)"
               "opacity 1.0, class:(brave-browser)"
               "workspace 4, class:(com.obsproject.Studio)"
            ];
            bind = [
               "$mainMod, return, exec, $terminal -e zellij-ps"
               "$mainMod, t, exec, $terminal -e fish -c 'neofetch; exec fish'"
               "$mainMod SHIFT, e, exec, $terminal -e zellij_nvim"
               "$mainMod, n, exec, $terminal -e nvim"
               "$mainMod, o, exec, thunar"
               "$mainMod, Escape, exec, wlogout -p layer-shell"
               "$mainMod, Space, togglefloating"
               "$mainMod, q, killactive"
               "$mainMod, M, exit"
               "$mainMod, F, fullscreen"
               "$mainMod, V, togglefloating"
               "$mainMod, D, exec, wofi --show drun --allow-images"
               "$mainMod SHIFT, S, exec, bemoji"
               "$mainMod, P, exec, wofi-pass"
               "$mainMod SHIFT, P, pseudo"
               "$mainMod, J, togglesplit"
               "$mainMod, left, movefocus, l"
               "$mainMod, right, movefocus, r"
               "$mainMod, up, movefocus, u"
               "$mainMod, down, movefocus, d"
               "$mainMod, h, movefocus, l"
               "$mainMod, l, movefocus, r"
               "$mainMod, k, movefocus, u"
               "$mainMod, j, movefocus, d"
               "$mainMod, 1, workspace, 1"
               "$mainMod, 2, workspace, 2"
               "$mainMod, 3, workspace, 3"
               "$mainMod, 4, workspace, 4"
               "$mainMod, 5, workspace, 5"
               "$mainMod, 6, workspace, 6"
               "$mainMod, 7, workspace, 7"
               "$mainMod, 8, workspace, 8"
               "$mainMod, 9, workspace, 9"
               "$mainMod, 0, workspace, 10"
               "$mainMod SHIFT, 1, movetoworkspace, 1"
               "$mainMod SHIFT, 2, movetoworkspace, 2"
               "$mainMod SHIFT, 3, movetoworkspace, 3"
               "$mainMod SHIFT, 4, movetoworkspace, 4"
               "$mainMod SHIFT, 5, movetoworkspace, 5"
               "$mainMod SHIFT, 6, movetoworkspace, 6"
               "$mainMod SHIFT, 7, movetoworkspace, 7"
               "$mainMod SHIFT, 8, movetoworkspace, 8"
               "$mainMod SHIFT, 9, movetoworkspace, 9"
               "$mainMod SHIFT, 0, movetoworkspace, 10"
               "$mainMod, mouse_down, workspace, e+1"
               "$mainMod, mouse_up, workspace, e-1"
            ];
            bindm = [
               "$mainMod, mouse:272, movewindow"
               "$mainMod, mouse:273, resizewindow"
            ];
         };
      };
   };
}
