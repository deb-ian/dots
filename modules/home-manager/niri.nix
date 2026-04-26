{ config, pkgs, inputs, ... }:

{

  imports = [
    inputs.noctalia.homeModules.default
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    # Explicitly resolve the warning
    gtk4.theme = null;

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    # Optional: keep or remove (not critical anymore)
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3"; # Makes Qt apps use your GTK theme
    style.name = "adwaita-dark";
  };

  programs.niri = {
    settings = {
        spawn-at-startup = [
          { command = [ "noctalia-shell" ]; }
        ];
        layout = {
          gaps = 12;
        };

        window-rules = [
          {
              geometry-corner-radius = {
              bottom-left = 10.0;
              bottom-right = 10.0;
              top-left = 10.0;
              top-right = 10.0;
            };
              clip-to-geometry = true;
          }
        ];

        binds = {
          # --- App launch ---
          "Mod+T".action.spawn = "alacritty";
          "Mod+E".action.spawn = [ "noctalia-shell" "ipc" "call" "launcher" "toggle" ];
          "Mod+Shift+Slash".action.show-hotkey-overlay = {};

          # --- Session control ---
          "Mod+Shift+E".action.quit = {};
          "Mod+Shift+P".action.spawn = [ "noctalia-shell" "ipc" "call" "sessionMenu" "toggle" ];

          # --- Window focus ---
          "Mod+J".action.focus-column-left = {};
          "Mod+L".action.focus-column-right = {};
          "Mod+Shift+WheelScrollDown".action.focus-column-right = {};
          "Mod+Shift+WheelScrollUp".action.focus-column-left = {};
          "Mod+I".action.focus-window-up = {};
          "Mod+K".action.focus-window-down = {};

          # --- Move windows ---
          "Mod+Shift+J".action.move-column-left = {};
          "Mod+Shift+L".action.move-column-right = {};
          "Mod+Shift+I".action.move-window-up = {};
          "Mod+Shift+K".action.move-window-down = {};

          # --- Layout / window control ---
          "Mod+F".action.maximize-column = {};
          "Mod+V".action.toggle-window-floating = {};
          "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = {};
          "Mod+Q".action.close-window = {};
          "Mod+O".action.toggle-overview = {};
          "Mod+Home".action.focus-column-first = {};
          "Mod+Minus".action.set-column-width =  "-10%";
          "Mod+Equal".action.set-column-width =  "+10%";
          "Mod+Shift+Minus".action.set-window-height = "-10%";
          "Mod+Shift+Equal".action.set-window-height = "+10%";
          "Mod+BracketLeft".action.consume-or-expel-window-left = {};
          "Mod+BracketRight".action.consume-or-expel-window-right = {};
          "Mod+Comma".action.consume-window-into-column = {};
          "Mod+Period".action.expel-window-from-column = {};

          # --- Workspace switching ---
          "Mod+1".action.focus-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+3".action.focus-workspace = 3;
          "Mod+4".action.focus-workspace = 4;
          "Mod+5".action.focus-workspace = 5;
          "Mod+6".action.focus-workspace = 6;
          "Mod+7".action.focus-workspace = 7;
          "Mod+8".action.focus-workspace = 8;
          "Mod+9".action.focus-workspace = 9;
          "Mod+WheelScrollDown".action.focus-workspace-down = {};
          "Mod+WheelScrollUp".action.focus-workspace-up = {};

          # --- Move window to workspace ---
          "Mod+Shift+1".action.move-window-to-workspace = 1;
          "Mod+Shift+2".action.move-window-to-workspace = 2;
          "Mod+Shift+3".action.move-window-to-workspace = 3;
          "Mod+Shift+4".action.move-window-to-workspace = 4;
          "Mod+Shift+5".action.move-window-to-workspace = 5;
          "Mod+Shift+6".action.move-window-to-workspace = 6;
          "Mod+Shift+7".action.move-window-to-workspace = 7;
          "Mod+Shift+8".action.move-window-to-workspace = 8;
          "Mod+Shift+9".action.move-window-to-workspace = 9;
          "Mod+Ctrl+U".action.move-column-to-workspace-down = {};
          "Mod+Ctrl+I".action.move-column-to-workspace-up = {};


          # --- Utility ---
          "Mod+Ctrl+R".action.spawn = [ "systemctl" "--user" "restart" "niri" ];
          #"Mod+Print".action.screenshot-screen = {};
        };
    };
  };

  home.packages = with pkgs; [
    alacritty
#    fuzzel
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "gtk" ];
  };

  programs.noctalia-shell = {
    enable = true;
    settings = {
      bar = {
        position = "top";
        density = "comfortable";
      };
    };
  };

}
