# /home/features/desktop/theme.nix
{ config, lib, pkgs, ... }:
with lib;
let
   cfg = config.features.desktop.theme;
in {
   options.features.desktop.theme.enable = mkEnableOption "Red Sands theme pack (GTK/Qt/icons/cursor)";

   config = mkIf cfg.enable {
      # Icon + Qt style packages to make the theme cohesive
      home.packages = with pkgs; [
         papirus-icon-theme
         adwaita-qt
         adwaita-qt6
         # qgnomeplatform-qt6  # REMOVED: causes failing build and is deprecated behind 'adwaita' platform theme
      ];

      gtk = {
         enable = true;

         # Base: Adwaita Dark; we layer Red Sands CSS over it
         theme.name = "Adwaita-dark";

         iconTheme = {
            name = "Papirus-Dark";
         };

         # >>> Cursor: DMZ-Black (black pointer with white border)
         cursorTheme = {
            name = "DMZ-Black";
            package = pkgs.vanilla-dmz;
            size = 32;
         };

         # Red Sands accent + surfaces (GTK 3)
         gtk3.extraCss = ''
            @define-color rs_bg #1f1917;
            @define-color rs_panel #772822;
            @define-color rs_sand #E9B489;
            @define-color rs_text #FDF0D5;
            @define-color rs_accent #C7522A;

            window, .background, .view, .box, .toolbar, .menubar, .popover, .dialog {
               background-color: @rs_bg;
               color: @rs_text;
            }

            headerbar, .titlebar, .menubar, .sidebar, .path-bar {
               background-color: @rs_panel;
               color: @rs_text;
            }

            button, .button, entry, spinbutton, combobox, selection, .badge {
               background-color: @rs_sand;
               color: #772822;
               border-color: alpha(#000, 0.15);
            }

            button:hover, .button:hover {
               background-color: shade(@rs_sand, 1.06);
            }

            button:active, .button:active, entry:focus, spinbutton:focus, combobox:focus {
               border-color: @rs_accent;
               box-shadow: 0 0 0 2px alpha(@rs_accent, 0.25);
            }

            selection, text selection {
               background-color: @rs_accent;
               color: @rs_text;
            }

            scrollbar, trough, scale {
               background-color: alpha(@rs_panel, 0.6);
            }

            tooltip {
               background-color: @rs_panel;
               color: @rs_text;
               border: 1px solid alpha(@rs_accent, 0.3);
            }
         '';

         # Red Sands accent + surfaces (GTK 4 / Libadwaita)
         gtk4.extraCss = ''
            @define-color rs_bg #1f1917;
            @define-color rs_panel #772822;
            @define-color rs_sand #E9B489;
            @define-color rs_text #FDF0D5;
            @define-color rs_accent #C7522A;

            window, .background, .view, .box, .toolbar, .popover, .dialog, .card {
               background-color: @rs_bg;
               color: @rs_text;
            }

            headerbar, .titlebar, .sidebar, .navigation-sidebar, menubar {
               background-color: @rs_panel;
               color: @rs_text;
            }

            button, entry, spinbutton, combobox, switch, .statuspage {
               background-color: @rs_sand;
               color: #772822;
               border-color: alpha(#000, 0.15);
            }

            button:hover {
               background-color: shade(@rs_sand, 1.06);
            }

            button:checked, entry:focus-within, spinbutton:focus-within, combobox:focus-within {
               border-color: @rs_accent;
               box-shadow: 0 0 0 2px alpha(@rs_accent, 0.25);
            }

            selection, text selection, .accent  {
               background-color: @rs_accent;
               color: @rs_text;
            }

            slider, scrollbar, scale, progressbar {
               background-color: alpha(@rs_panel, 0.6);
            }

            tooltip, .tooltip {
               background-color: @rs_panel;
               color: @rs_text;
               border: 1px solid alpha(@rs_accent, 0.3);
            }
         '';
      };

      # Ensure Wayland/X also pick up the cursor (and export XCURSOR_* env)
      home.pointerCursor = {
         name = "DMZ-Black";
         package = pkgs.vanilla-dmz;
         size = 32;
         gtk.enable = true;
         x11.enable = true;
      };

      qt = {
         enable = true;

         # New: use the Adwaita platform theme (recommended; 'gnome' is deprecated)
         platformTheme = {
            name = "adwaita";
            package = pkgs.adwaita-qt6;
         };

         # Keep Adwaita Dark for Qt apps to match GTK
         style = {
            name = "adwaita-dark";
            package = pkgs.adwaita-qt6;
         };
      };

      # Keep GNOME/Libadwaita aligned with the same palette & cursor
      dconf.settings = {
         "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            gtk-theme = "Adwaita-dark";
            icon-theme = "Papirus-Dark";
            cursor-theme = "DMZ-Black";
         };
      };
   };
}
