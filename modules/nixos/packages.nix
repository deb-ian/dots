{ config, pkgs, ...}:

{

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     neovim
     curl
     fastfetch
     wget
     distrobox
     gedit

     # Niri
     xwayland-satellite
     ranger
     thunar
     kdePackages.polkit-kde-agent-1
  ];

  users.users.work.packages = with pkgs; [
    ungoogled-chromium
    ];

  programs.kdeconnect.enable = true;

  programs.niri.enable = true;

}
