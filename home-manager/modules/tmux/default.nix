{
  terminal,
  pkgs-unstable,
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
    disableConfirmationPrompt = true;
    extraConfig = builtins.readFile ./tmux.conf;
  };
}
