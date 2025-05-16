{ pkgs-unstable, ... }:
{
  programs.starship = {
    enable = true;
    package = pkgs-unstable.starship;

    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;

    settings = {
      character = {
        success_symbol = "[›](bold green)";
        error_symbol = "[›](bold red)";
      };
    };
  };
}
