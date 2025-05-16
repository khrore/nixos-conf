{
  terminal,
  terminalEditor,
  browser,
  ...
}:
{
  home.sessionVariables = rec {
    TERMINAL = terminal;
    EDITOR = terminalEditor;
    BROWSER = browser;
    XDG_BIN_HOME = "$HOME/.local/bin";
  };
}
