{ config, pkgs, inputs, ...}:

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
     p7zip
     uv
     mesa-demos     

     # Niri
     xwayland-satellite
     thunar
     yazi
  ];
  
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
  ];

  users.users.work.packages = with pkgs; [
#    ungoogled-chromium
    ];

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  
#  virtualisation.waydroid = {
#    enable = true;
#    package = pkgs.waydroid-nftables;
#  };
#  networking.nftables.enable = true;

  programs.kdeconnect.enable = true;
  
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  
  programs.niri.package = pkgs.niri-unstable;
  
  programs.niri.enable = true;

}
