{ terminal, browser, terminalEditor,... }: {
  environment.sessionVariables = rec {
    TERMINAL = terminal; 
    EDITOR = terminalEditor;
    BROWSER = browser; 
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [
      "${XDG_BIN_HOME}"
      "${BROWSER}"
      "${EDITOR}"
      "${TERMINAL}"
    ];
  };
}
