{ config, pkgs, inputs, ... }:
{

  home.packages = with pkgs; [
    foot
    libnotify
  ];

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
        radius = 12;
      };

      colors = {
        background = "111111ee";
        text = "e0e0e0ff";
        prompt = "bdbdbdff";
        placeholder = "7a7a7aff";
        input = "e0e0e0ff";
        match = "ffffffff";
        selection = "2a2a2aff";
        selection-text = "ffffffff";
        selection-match = "ffffffff";
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
	      modules-left = [
		"clock"
	      ];
	      modules-center = [
		"niri/workspaces"
	      ];
	      modules-right = [
		"cpu"
		"memory"
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
		format = "󰥔  {:%I:%M %p}";
		tooltip-format = "<big>{:%A, %d %B %Y}</big>\n<tt><small>{calendar}</small></tt>";
		calendar = {
		  mode = "month";
		  weeks-pos = "right";
		  on-scroll = 1;
		  format = {
		    months = "<span color='#ffffff'><b>{}</b></span>";
		    days = "<span color='#c0c0c0'>{}</span>";
		    today = "<span color='#ffffff'><b><u>{}</u></b></span>";
		  };
		};
	      };
	      cpu = {
		interval = 5;
		format = "󰻠  {usage}%";
		tooltip = false;
	      };
	      memory = {
		interval = 10;
		format = "󰍛  {used:0.1f}G";
		tooltip-format = "{used:0.1f}G / {total:0.1f}G used";
	      };
	      pulseaudio = {
		scroll-step = 5;
		format = "{icon}  {volume}%";
		format-muted = "󰝟  muted";
		format-icons = {
		  default = [ "󰕿" "󰖀" "󰕾" ];
		};
		on-click = "pavucontrol";
	      };
	      network = {
		interval = 5;
		format-wifi = "󰖩  {signalStrength}%";
		format-ethernet = "󰈀  {ifname}";
		format-disconnected = "󰖪  offline";
		tooltip-format-wifi = "{essid} ({signalStrength}%) — {ipaddr}";
		tooltip-format-ethernet = "{ifname} — {ipaddr}";
	      };
	      battery = {
		states = {
		  warning = 30;
		  critical = 15;
		};
		format = "{icon}  {capacity}%";
		format-charging = "󰂄  {capacity}%";
		format-plugged = "󰚥  {capacity}%";
		format-icons = [
		  "󰂎" "󰁺" "󰁼" "󰁾" "󰂀" "󰂂"
		];
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
	      border-radius: 18px;
	      font-family: "JetBrainsMono Nerd Font";
	      font-size: 13px;
	      min-height: 0;
	    }

	    window#waybar {
	      background: transparent;
	      color: #f0f0f0;
	    }

	    tooltip {
	      background: rgba(18, 18, 18, 0.94);
	      border-radius: 14px;
	      border: 1px solid rgba(255, 255, 255, 0.08);
	      color: #f0f0f0;
	    }

	    tooltip label {
	      padding: 2px 4px;
	    }

	    #clock,
	    #workspaces,
	    #cpu,
	    #memory,
	    #pulseaudio,
	    #network,
	    #battery,
	    #tray {
	      background: rgba(28, 28, 28, 0.78);
	      border: 1px solid rgba(255, 255, 255, 0.07);
	      border-radius: 18px;
	      color: #e0e0e0;
	      padding: 0 16px;
	      margin-top: 5px;
	      transition:
		background 0.2s ease,
		color 0.2s ease;
	    }

	    #clock {
	      font-weight: 700;
	      color: #ffffff;
	      background: rgba(255, 255, 255, 0.10);
	      border-color: rgba(255, 255, 255, 0.10);
	      letter-spacing: 0.02em;
	    }

	    #clock:hover {
	      background: rgba(255, 255, 255, 0.14);
	    }

	    #workspaces {
	      padding: 0 6px;
	    }

	    #workspaces button {
	      color: #707070;
	      padding: 0 10px;
	      margin: 5px 3px;
	      border-radius: 13px;
	      min-width: 28px;
	      transition:
		background 0.15s ease,
		color 0.15s ease;
	    }

	    #workspaces button:hover {
	      background: rgba(255, 255, 255, 0.09);
	      color: #d0d0d0;
	    }

	    #workspaces button.active {
	      background: rgba(255, 255, 255, 0.18);
	      color: #ffffff;
	      box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.12);
	    }

	    #workspaces button.urgent {
	      background: rgba(255, 255, 255, 0.22);
	      color: #ffffff;
	    }

	    #cpu,
	    #memory,
	    #pulseaudio,
	    #network,
	    #battery {
	      padding: 0 14px;
	    }

	    #cpu:hover,
	    #memory:hover,
	    #pulseaudio:hover,
	    #network:hover,
	    #battery:hover {
	      background: rgba(255, 255, 255, 0.10);
	      color: #ffffff;
	    }

	    #battery.warning {
	      color: #c8c8c8;
	    }

	    #battery.critical {
	      color: #ffffff;
	      background: rgba(255, 255, 255, 0.16);
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
	      background: rgba(255, 255, 255, 0.16);
	    }
	  '';
	};
  
  services.mako = {
	  enable = true;
	  settings = {
	    font = "JetBrainsMono Nerd Font 11";
	    width = 320;
	    height = 80;
	    margin = "14,14,8,14";
	    padding = "14,16";
	    border-size = 1;
	    border-radius = 18;
	    background-color = "#1C1C1CCC";
	    border-color = "#FFFFFF12";
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
	      background-color = "#1C1C1CBF";
	      border-color = "#FFFFFF0A";
	      text-color = "#A0A0A0";
	      default-timeout = 4000;
	    };

	    "urgency=normal" = {
	      background-color = "#1C1C1CCC";
	      border-color = "#FFFFFF12";
	      text-color = "#F0F0F0";
	      default-timeout = 6000;
	    };

	    "urgency=high" = {
	      background-color = "#F0F0F014";
	      border-color = "#FFFFFF30";
	      text-color = "#FFFFFF";
	      border-size = 1;
	      default-timeout = 0;
	    };
	  };
	};
  
}
