{ config, pkgs, ...}:

{

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim
     curl
     fastfetch
     wget
     distrobox

     # Niri
     cliphist
     wl-clip-persist
     xwayland-satellite
  ];

  users.users.work.packages = with pkgs; [
    kdePackages.kate
    brave
    ];

  programs.kdeconnect.enable = true;

  programs.niri.enable = true;

}
