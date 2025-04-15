{
  inputs,
  pkgs-unstable,
  ...
}: {
  programs.yazi = {
    enable = true;

    # Changing working directory when exiting Yazi
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    enableFishIntegration = true;
    package = pkgs-unstable.yazi;
    theme =
      builtins.fromTOML (builtins.readFile "${inputs.catppuccin-yazi}/themes/mocha/catppuccin-mocha-blue.toml")
      // {
        # manage = {
        #   syntect_theme = "~/.config/bat/themes/catppuccin-mocha.tmTheme";
        # };
      };
    settings = {
      manager = {
        sort_dir_first = true;
      };
    };
  };

  # catppuccin-mocha theme from yazi-flavors
  # Catppuccin-mocha.tmTheme
  # xdg.configFile."yazi/Catppuccin-mocha.tmTheme" = "${inputs.catppuccin-bat}/themes/Catppuccin Mocha.tmTheme";
  # xdg.configFile."yazi/theme.toml".source = "${inputs.catppuccin-yazi}/themes/mocha/catppuccin-mocha-blue.toml";
}
