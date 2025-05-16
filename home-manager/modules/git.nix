{ pkgs-unstable, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs-unstable.git;
    userName = "khrore";
    userEmail = "super.stas.0978@gmail.com";
    aliases = {
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log";
    };
    extraConfig = {
      # git config --global --add safe.directory /etc/nixos
      safe.dirrectory = "/etc/nixos";
    };
  };
}
