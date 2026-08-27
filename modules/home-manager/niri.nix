{ config, lib, pkgs, inputs, ... }:

let
  theme = import ./theme.nix;
in
{

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

    # GTK4/libadwaita apps follow the dconf color-scheme setting above,
    # not gtk4.theme. Setting this to null silences home-manager's
    # "gtk4.theme is ignored" warning without fighting libadwaita.
    gtk4.theme = null;

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    # Note: no gtk4.extraConfig here — dconf color-scheme = "prefer-dark"
    # already covers GTK4/libadwaita apps; setting it again was redundant.
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
        { command = [ "wl-paste" "--type" "text/plain" "--watch" "cliphist" "store" ]; }
        { command = [ "wl-paste" "--type" "image" "--watch" "cliphist" "store" ]; }
      ];

      layout = {
        gaps = 12;

        focus-ring = {
          enable = true;
          width = 2.0;
          active.color = "#${theme.colors.accentBright}";
          inactive.color = "#${theme.colors.border}";
        };

        border = {
          enable = true;
          width = 1.0;
          active.color = theme.colors.borderRgba; # already "rgba(...)", no # prefix
          inactive.color = "#${theme.colors.border}";
        };

        shadow = {
          enable = true;
          softness = 30.0;
          spread = 4.0;
          offset = { x = 0.0; y = 6.0; };
          color = "#000000B0";
        };
      };

      window-rules = [
        {
          # niri requires a genuine float here; theme.radius.sm is a plain
          # int (shared with CSS via toString), so coerce it explicitly.
          geometry-corner-radius =
            let r = theme.radius.sm * 1.0; in
            {
              bottom-left = r;
              bottom-right = r;
              top-left = r;
              top-right = r;
            };
          clip-to-geometry = true;
        }
      ];

      binds =
        let
          mod = "Mod";
          workspaceBinds = lib.listToAttrs (
            lib.concatMap
              (i: [
                {
                  name = "${mod}+${toString i}";
                  value.action.focus-workspace = i;
                }
                {
                  name = "${mod}+Shift+${toString i}";
                  value.action.move-window-to-workspace = i;
                }
              ])
              (lib.range 1 9)
          );
        in
        workspaceBinds // {
          # Apps + Overview
          "Mod+Return".action.spawn = "foot";
          "Mod+E".action.spawn = [ "fuzzel" ];
          "Mod+Shift+Slash".action.show-hotkey-overlay = { };

          # Session Control
          "Mod+Shift+E".action.quit = { };
          "Mod+P".action.spawn = [ "${config.home.homeDirectory}/dots/modules/home-manager/pmenu.sh" ];

          # Window Focus
          "Mod+H".action.focus-column-left = { };
          "Mod+L".action.focus-column-right = { };
          "Mod+Shift+WheelScrollDown".action.focus-column-right = { };
          "Mod+Shift+WheelScrollUp".action.focus-column-left = { };
          "Mod+J".action.focus-window-up = { };
          "Mod+K".action.focus-window-down = { };

          # Window Movement
          "Mod+Shift+H".action.move-column-left = { };
          "Mod+Shift+L".action.move-column-right = { };
          "Mod+Shift+J".action.move-window-up = { };
          "Mod+Shift+K".action.move-window-down = { };

          # Layout and Window Control
          "Mod+F".action.maximize-column = { };
          "Mod+Shift+F".action.fullscreen-window = [ ];
          "Mod+V".action.toggle-window-floating = { };
          "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = { };
          "Mod+Q".action.close-window = { };
          "Mod+Tab".action.toggle-overview = { };
          "Mod+Home".action.focus-column-first = { };
          "Mod+Minus".action.set-column-width = "-10%";
          "Mod+Equal".action.set-column-width = "+10%";
          "Mod+Shift+Minus".action.set-window-height = "-10%";
          "Mod+Shift+Equal".action.set-window-height = "+10%";
          "Mod+BracketLeft".action.consume-or-expel-window-left = { };
          "Mod+BracketRight".action.consume-or-expel-window-right = { };
          "Mod+Comma".action.consume-window-into-column = { };
          "Mod+Period".action.expel-window-from-column = { };

          # Workspace navigation (scroll) + column-to-workspace moves
          "Mod+WheelScrollDown".action.focus-workspace-down = { };
          "Mod+WheelScrollUp".action.focus-workspace-up = { };
          "Mod+Ctrl+Z".action.move-column-to-workspace-down = { };
          "Mod+Ctrl+C".action.move-column-to-workspace-up = { };

          # Utility
          "Print".action.screenshot.show-pointer = false;
          # Clipboard history picker (cliphist kept standalone, no noctalia dependency)
          "Mod+Shift+C".action.spawn = [
            "sh"
            "-c"
            "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"
          ];
          # Clear clipboard: wipes cliphist's history AND the live selection
          # (cliphist wipe alone doesn't touch what's currently on the clipboard).
          "Mod+Shift+X".action.spawn = [
            "sh"
            "-c"
            "cliphist wipe && wl-copy --clear"
          ];
        };
    };
  };

  xdg.portal = {
    enable = true;
    # NOTE: xdg-desktop-portal-gtk does not implement the Screenshot
    # interface. If `Print` (niri's built-in screenshot action) or any
    # screenshot picker isn't working after removing noctalia-shell,
    # add xdg-desktop-portal-gnome (or your compositor's wlroots portal)
    # and route the Screenshot interface to it specifically.
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "gtk" ];
  };

}
