{ inputs, pkgs-unstable, ... }:
{
  # download Zen browser
  home.packages = [
    inputs.zen-browser.packages."${pkgs-unstable.stdenv.system}".default
  ];
  # download catppuccin theme
  # IMPORTANT: you need to copy theme to current profile. Dont know how to automate this, profile is generaiting with hash number
  xdg.configFile."../.zen/chrome".source = "${inputs.catppuccin-zen}/themes/Mocha/Blue";
}
