# a cat clone with syntax highlighting and Git integration.
{ inputs, ... }: {
  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
      theme = "catppuccin-mocha";
    };
    themes = {
      catppuccin-mocha = {
        src = "${inputs.catppuccin-bat}/themes";
        file = "Catppuccin Mocha.tmTheme";
      };
    };
  };
}