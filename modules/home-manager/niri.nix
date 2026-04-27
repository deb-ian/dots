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

	prefer-no-csd = true;

        spawn-at-startup = [
          { command = [ "noctalia-shell" ]; }
	  { command = [ "wl-paste" "--type" "text/plain" "--watch" "cliphist" "store" ]; }
	  { command = [ "wl-paste" "--type" "image" "--watch" "cliphist" "store" ]; }
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
          # Apps + Overview
          "Mod+Return".action.spawn = "alacritty";
          "Mod+E".action.spawn = [ "noctalia-shell" "ipc" "call" "launcher" "toggle" ];
          "Mod+Shift+Slash".action.show-hotkey-overlay = {};

          # Session Control
          "Mod+Shift+E".action.quit = {};
          "Mod+Shift+P".action.spawn = [ "noctalia-shell" "ipc" "call" "sessionMenu" "toggle" ];

          # Window Focus
          "Mod+H".action.focus-column-left = {};
          "Mod+L".action.focus-column-right = {};
          "Mod+Shift+WheelScrollDown".action.focus-column-right = {};
          "Mod+Shift+WheelScrollUp".action.focus-column-left = {};
          "Mod+J".action.focus-window-up = {};
          "Mod+K".action.focus-window-down = {};

          # Window Movement
          "Mod+Shift+H".action.move-column-left = {};
          "Mod+Shift+L".action.move-column-right = {};
          "Mod+Shift+J".action.move-window-up = {};
          "Mod+Shift+K".action.move-window-down = {};

          # Layout and Window Control
          "Mod+F".action.maximize-column = {};
          "Mod+Shift+F".action.fullscreen-window = [];
          "Mod+V".action.toggle-window-floating = {};
          "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = {};
          "Mod+Q".action.close-window = {};
          "Mod+Tab".action.toggle-overview = {};
          "Mod+Home".action.focus-column-first = {};
          "Mod+Minus".action.set-column-width =  "-10%";
          "Mod+Equal".action.set-column-width =  "+10%";
          "Mod+Shift+Minus".action.set-window-height = "-10%";
          "Mod+Shift+Equal".action.set-window-height = "+10%";
          "Mod+BracketLeft".action.consume-or-expel-window-left = {};
          "Mod+BracketRight".action.consume-or-expel-window-right = {};
          "Mod+Comma".action.consume-window-into-column = {};
          "Mod+Period".action.expel-window-from-column = {};

          # Workspace shit
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
          "Mod+Shift+1".action.move-window-to-workspace = 1;
          "Mod+Shift+2".action.move-window-to-workspace = 2;
          "Mod+Shift+3".action.move-window-to-workspace = 3;
          "Mod+Shift+4".action.move-window-to-workspace = 4;
          "Mod+Shift+5".action.move-window-to-workspace = 5;
          "Mod+Shift+6".action.move-window-to-workspace = 6;
          "Mod+Shift+7".action.move-window-to-workspace = 7;
          "Mod+Shift+8".action.move-window-to-workspace = 8;
          "Mod+Shift+9".action.move-window-to-workspace = 9;
          "Mod+Ctrl+Z".action.move-column-to-workspace-down = {};
          "Mod+Ctrl+C".action.move-column-to-workspace-up = {};

	  # Utility
	  "Mod+Shift+C".action.spawn = [ "noctalia-shell" "ipc" "call" "plugin:clipboard" "toggle" ];
	  "Print".action.spawn = [ "noctalia-shell" "ipc" "call" "plugin:screenshot" "takeScreenshot" "region"  ];
        };
    };
  };

  home.packages = with pkgs; [
    alacritty
    cliphist
    wl-clipboard
    wl-clip-persist
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
        widgets = {
            left = [
              {
                id = "Launcher";
              }
              {
                formatHorizontal = "h:mm AP ddd, MMM dd";
                id = "Clock";
              }
              {
                id = "SystemMonitor";
              }
              {
                id = "MediaMini";
              }
            ];
            center = [
              {
                id = "Workspace";
              }
            ];
            right = [
              {
                id = "Tray";
              }
              {
                id = "NotificationHistory";
              }
              {
                id = "Battery";
              }
              {
                id = "Volume";
              }
              {
                id = "ControlCenter";
              }
            ];
          };
      };
	
      location  = {
      	name = "Chennai";
      };
      
      dock = {
        enabled = false;
      };

      sessionMenu  = {
        largeButtonsLayout = "grid";
        powerOptions = [
            {
              action = "lock";
              enabled = true;
              keybind = "1";
            }
            {
              action = "reboot";
              enabled = true;
              keybind = "4";
            }
            {
              action = "logout";
              enabled = true;
              keybind = "5";
            }
            {
              action = "shutdown";
              enabled = true;
              keybind = "6";
            }
            {
              action = "rebootToUefi";
              enabled = true;
              keybind = "7";
            }
          ];
        };
	
	plugins = {
     	  sources = [
       	    {
               enabled = true;
               name = "Official Noctalia Plugins";
                url = "https://github.com/noctalia-dev/noctalia-plugins";
            }
          ];
          states = {
            clipboard = { enabled = true; };
            Screenshot  = { enabled = true; };
            "polkit-agent" = { enabled= true; };
            "privacy-indicator" = { enabled = true; };
          };
       };
       
       colorSchemes = {
          useWallpaperColors = true;
          darkMode = true;
          generationMethod = "vibrant";
          syncGsettings = true;
       };
       
       notifications = {
         location = "bottom_right";
       };
       
       idle = {
          enabled = true;
          screenOffTimeout = 600;
          lockTimeout = 660;
          suspendTimeout = 1800;
          fadeDuration = 5;
        };
       
       controlCenter = {
         cards = [
              	{
         	  enabled = true;
         	  id = "profile-card";
         	}
         	{
         	  enabled = true;
         	  id = "audio-card";
         	}
         	{
         	  enabled = true;
         	  id = "media-sysmon-card";
         	}
         ];
       };
       	
      };
    };

}
