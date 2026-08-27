{ config, pkgs, inputs, ... }:
let
  theme = import ./theme.nix;
  colors = theme.colors;
  radius = theme.radius;
in
{
  home.packages = with pkgs; [
    foot
    libnotify
    swaybg
    networkmanager
    cliphist # backs the wl-paste watchers + Mod+Shift+C picker in niri.nix
    wl-clipboard # provides wl-paste / wl-copy used by the same bindings
  ];

  home.file.".config/foot/foot.ini".text = ''
    font=JetBrainsMono Nerd Font:size=11
    letter-spacing=-0.4
    pad=5x5

    [colors-dark]
    alpha=0.8
    blur=true

    [cursor]
    style=beam
    blink=yes

    [mouse]
    hide-when-typing=yes
  '';

  home.file.".config/waybar/memory.sh" = {
    text = ''
      #!/usr/bin/env bash
      total=$(awk '/MemTotal/{print $2}' /proc/meminfo)
      avail=$(awk '/MemAvailable/{print $2}' /proc/meminfo)
      buffers=$(awk '/Buffers/{print int($2/1024/1024)}' /proc/meminfo)
      cached=$(awk '/^Cached/{print int($2/1024/1024)}' /proc/meminfo)
      swaptotal=$(awk '/SwapTotal/{print $2}' /proc/meminfo)
      swapfree=$(awk '/SwapFree/{print $2}' /proc/meminfo)
      used=$(( (total - avail) / 1024 / 1024 ))
      pct=$(( (total - avail) * 100 / total ))
      swapused=$(( (swaptotal - swapfree) / 1024 / 1024 ))
      printf '{"text":"%sG","percentage":%s,"tooltip":"Used: %sG\\nBuffers: %sG\\nCached: %sG\\nSwap: %sG"}' \
        "$used" "$pct" "$used" "$buffers" "$cached" "$swapused"
    '';
    executable = true;
  };

  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        terminal = "foot";
        layer = "overlay";
        width = 40;
        lines = 10;
        horizontal-pad = 18;
        vertical-pad = 14;
        inner-pad = 10;
        font = "JetBrainsMono Nerd Font:size=11";
      };

      border = {
        width = 2;
        radius = radius.md; # was hardcoded 14; now sourced from theme
      };

      colors = {
        background = "${colors.base}";
        text = "${colors.text}ff";
        prompt = "bdbdbdff";
        placeholder = "7a7a7aff";
        input = "${colors.text}ff";
        match = "ffffffff";
        selection = "${colors.surface}";
        selection-text = "ffffffff";
        selection-match = "bdbdbdff";
        border = "4a4a4aff";
      };
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 42;
        margin-top = 10;
        margin-left = 14;
        margin-right = 14;
        spacing = 8;

        modules-left = [ "clock" ];
        modules-center = [ "niri/workspaces" ];
        modules-right = [
          "group/hardware"
          "pulseaudio"
          "network"
          "battery"
          "tray"
        ];

        "niri/workspaces" = {
          disable-scroll = true;
          on-click = "activate";
        };

        clock = {
          format = "󰥔 {:%I:%M %p}";
          tooltip-format = "<big>{:%A, %d %B %Y}</big>\n<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            weeks-pos = "left";
            on-scroll = 1;
            format = {
              months = "<span color='#ffffff'><b>{}</b></span>";
              days = "<span color='#c0c0c0'>{}</span>";
              today = "<span color='#ffffff'><b><u>{}</u></b></span>";
            };
          };
        };

        "group/hardware" = {
          orientation = "horizontal";
          drawer = {
            transition-duration = 300;
            click-to-reveal = true;
          };
          modules = [ "cpu" "custom/memory" ];
        };

        cpu = {
          interval = 5;
          format = "󰻠 {usage}%";
          tooltip = false;
        };

        "custom/memory" = {
          exec = "~/.config/waybar/memory.sh";
          return-type = "json";
          interval = 10;
          format = "󰍛 {}";
        };

        pulseaudio = {
          scroll-step = 5;
          format = "{icon} {volume}%";
          format-muted = "󰝟 muted";
          format-icons.default = [ "󰕿" "󰖀" "󰕾" ];
          on-click = "pavucontrol";
        };

        network = {
          interval = 5;
          format-wifi = "󰖩 {signalStrength}% ; ↑{bandwidthUpBytes} ; ↓{bandwidthDownBytes}";
          format-ethernet = "󰈀 ↑{bandwidthUpBytes}/s ↓{bandwidthDownBytes}/s";
          format-disconnected = "󰖪 offline";
          tooltip-format-wifi = "{essid} ({signalStrength}%) — {ipaddr}";
          tooltip-format-ethernet = "{ifname} — {ipaddr}";
          on-click = "foot -e nmtui";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-icons = [ "󰂎" "󰁺" "󰁼" "󰁾" "󰂀" "󰂂" ];
          tooltip-format = "{timeTo} — {capacity}%";
        };

        tray = {
          icon-size = 16;
          spacing = 8;
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: ${toString radius.md}px;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
        color: #${colors.textBright};
      }

      tooltip {
        background: ${colors.baseRgba};
        border-radius: ${toString radius.lg}px;
        border: 1px solid ${colors.borderRgba};
        color: #${colors.textBright};
      }

      tooltip label {
        padding: 2px 4px;
      }

      #clock,
      #workspaces,
      #cpu,
      #custom-memory,
      #pulseaudio,
      #network,
      #battery,
      #tray {
        background: ${colors.baseRgba};
        border: 1px solid ${colors.borderRgba};
        color: #${colors.text};
        padding: 0 16px;
        margin-top: 5px;
        transition: background 0.2s ease, color 0.2s ease;
      }

      #clock {
        font-weight: 700;
        color: #${colors.textBright};
        border-radius: ${toString radius.lg}px;
        letter-spacing: 0.02em;
      }

      #clock:hover {
        background: ${colors.surfaceRgba};
      }

      #workspaces {
        padding: 0 6px;
      }

      #workspaces button {
        color: #${colors.textMuted};
        padding: 0 10px;
        margin: 5px 3px;
        border-radius: ${toString radius.sm}px;
        min-width: 28px;
        transition: background 0.15s ease, color 0.15s ease;
      }

      #workspaces button:hover {
        background: ${colors.surfaceRgba};
        color: #d0d0d0;
      }

      #workspaces button.active {
        background: #${colors.accent};
        color: #${colors.textBright};
      }

      #workspaces button.urgent {
        background: #${colors.urgent};
        color: #${colors.textBright};
      }

      #cpu,
      #custom-memory,
      #pulseaudio,
      #network,
      #battery {
        padding: 0 14px;
      }

      #cpu:hover,
      #custom-memory:hover,
      #pulseaudio:hover,
      #network:hover,
      #battery:hover {
        background: ${colors.surfaceRgba};
        color: #${colors.textBright};
      }

      #battery.warning {
        color: #${colors.textBright};
      }

      #battery.critical {
        color: #${colors.textBright};
        background: #${colors.urgent};
        animation: battery-blink 1.2s ease-in-out infinite alternate;
      }

      @keyframes battery-blink {
        from { opacity: 1; }
        to   { opacity: 0.6; }
      }

      #tray {
        padding: 0 10px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        background: #${colors.urgent};
      }
    '';
  };

  services.mako = {
    enable = true;
    settings = {
      font = "JetBrainsMono Nerd Font 11";
      width = 320;
      margin = "14,14,8,14";
      padding = "14,16";
      border-size = 1;
      border-radius = radius.lg; # was hardcoded 18; now sourced from theme
      background-color = "#${colors.base}";
      border-color = "#${colors.border}";
      text-color = "#F0F0F0";
      progress-color = "over #FFFFFF1A";
      default-timeout = 6000;
      ignore-timeout = 0;
      layer = "overlay";
      anchor = "top-right";
      sort = "-time";
      max-visible = 5;
      max-icon-size = 20;

      "urgency=low" = {
        background-color = "#${colors.base}";
        border-color = "#FFFFFF0A";
        text-color = "#A0A0A0";
        default-timeout = 4000;
      };

      "urgency=normal" = {
        background-color = "#${colors.base}";
        border-color = "#${colors.border}";
        text-color = "#F0F0F0";
        default-timeout = 6000;
      };

      "urgency=high" = {
        background-color = "#${colors.urgent}22";
        border-color = "#${colors.urgent}88";
        text-color = "#FFFFFF";
        border-size = 1;
        default-timeout = 0;
      };
    };
  };

  systemd.user.services.swaybg = {
    Unit = {
      Description = "Wallpaper daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.swaybg}/bin/swaybg -i ${config.home.homeDirectory}/Pictures/Wallpapers/man.jpg -m fill";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
