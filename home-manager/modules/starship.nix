{inputs, ...}: {
  programs.starship = {
    enable = true;

    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;

    settings =
      {
        character = {
          success_symbol = "[›](bold green)";
          error_symbol = "[›](bold red)";
        };

        palette = "catppuccin_mocha";
      }
      // builtins.fromTOML (builtins.readFile "${inputs.catppuccin-starship}/themes/mocha.toml");
  };
}
