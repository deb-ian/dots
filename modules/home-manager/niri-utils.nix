{ config, pkgs, inputs, ... }
{

  home.packages = with pkgs; [
    foot
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
  
  programs.waybar.enable = true;
  programs.mako.enable = true;

}
