{
  programs.waybar = {
    enable = true;
    style = builtins.readFile ./style.css;
  };

  xdg.configFile."waybar/config.jsonc".source = ./config.jsonc;
}
