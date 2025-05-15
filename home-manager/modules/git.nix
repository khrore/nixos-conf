{ pkgs-unstable, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs-unstable.git;
    userName = "khrore";
    userEmail = "super.stas.0978@gmail.com";
  };
}
