{ config, pkgs, inputs, ... }:

{

  imports = [
    inputs.niri.homeModules.niri
    inputs.noctalia.homeModules.default
  ];

  programs.niri = {
    enable = true;
    settings = {
        spawn-at-startup = [];
        binds = {
          "Mod+T".action.spawn = "${pkgs.alacritty}/bin/alacritty";
          "Mod+D".action.spawn = "${pkgs.fuzzel}/bin/fuzzel";
          "Mod+Shift+E".action.quit = true; # Quit Niri
          "Mod+Ctrl+R".action.reload-config = true; # Reload config
          "Mod+Comma".action.show-hotkey-overlay = true;
        };
    };
  };

  environment.systemPackages = with pkgs; [
    #alacritty   # A terminal emulator
    #fuzzel      # An application launcher
    cliphist
    wl-clip-persist # For clipboard management
  ];

  home.packages = with pkgs; [
    alacritty
    fuzzel
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "gtk" ];
  };

  programs.noctalia = {
    enable = true;
  };

}
