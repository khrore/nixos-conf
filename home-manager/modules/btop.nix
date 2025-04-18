# A monitor of resources
# replacement of htop/nmon
{ inputs, ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "catppuccin_mocha";
      theme_background = false; # make btop transparent
    };
  };

  xdg.configFile."btop/themes".source = "${inputs.catppuccin-btop}/themes";
}
