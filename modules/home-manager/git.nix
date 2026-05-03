{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Dev";
      user.email = "157894292+deb-ian@users.noreply.github.com";
    
      init.defaultBranch = "main";
      safe.directory = "/home/work/dots"; # Keep this so you can rebuild as 'work'
      pull.rebase = true;
    
      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        ps = "push";
      };
   };
 };
}
