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
  ];

  users.users.work.packages = with pkgs; [
    kdePackages.kate
    brave
    ];

#   users.users.main-dev.packages = with pkgs; [
#     kdePackages.kate
#     chromium
#     ];

}
