{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      sw = "nh os switch";
      upd = "nh os switch --update";
      hms = "nh home switch";

      y = "yazi";
      v = "nvim";
      se = "sudoedit";
      microfetch = "microfetch && echo";

      ".." = "cd ..";
    };
    history.size = 10000;
  };
}
