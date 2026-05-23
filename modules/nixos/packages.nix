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
     appimage-run

     # Niri
     xwayland-satellite
     yazi
     thunar
  ];

  users.users.work.packages = with pkgs; [
#    ungoogled-chromium
    ];

  programs.kdeconnect.enable = true;
  
  programs.appimage.enable = true;
  
  programs.appimage.binfmt = true;
  
  programs.niri.enable = true;

}
