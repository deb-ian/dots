{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Dev";
      user.email = "157894292+deb-ian@users.noreply.github.com";
      extraConfig = {
        init.defaultBranch = "main";
        safe.directory = "/home/work/dots"; # Keep this so you can rebuild as 'work'
        pull.rebase = true;
      };

      aliases = {
        st = "status";
        co = "checkout";
        br = "branch";
      };
    };
  };
}
