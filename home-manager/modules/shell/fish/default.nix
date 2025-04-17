{
  pkgs-unstable,
  inputs,
  ...
}: {
  programs.fish = {
    enable = true;
    package = pkgs-unstable.fish;
    shellInit =
      builtins.readFile "${inputs.catppuccin-fish}/themes/Catppuccin Mocha.theme"
      // builtins.readFile "./conf.fish";
  };
}
