{ config, pkgs, ... }:

{

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {

    work = {
      isNormalUser = true;
      description = "work";
      group = "users";
      home = "/home/work";
      extraGroups = [ "networkmanager" "wheel" "podman"];
    };
/*
    main-dev = {
      isNormalUser = true;
      description = "Main";
      group = "users";
      extraGroups = [ "networkmanager" "wheel" ];
    };*/

  };

}
