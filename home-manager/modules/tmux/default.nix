{
  terminal,
  pkgs-unstable,
  inputs,
  ...
}:
{
  programs.tmux = {
    enable = true;
    package = pkgs-unstable.tmux;
    baseIndex = 1;
    mouse = true;
    escapeTime = 0;
    keyMode = "vi";
    terminal = "xterm-${terminal}";

    extraConfig = builtins.readFile ./tmux.conf;
  };
  xdg.configFile."tmux/plugins/catppuccin/tmux".source = "${inputs.catppuccin-tmux}";
}
