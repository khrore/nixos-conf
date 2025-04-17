{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = let
      flakeDir = "~/flake";
    in {
      sw = "nh os switch";
      upd = "nh os switch --update";
      hms = "nh home switch";

      pkgs = "nvim ${flakeDir}/nixos/packages.nix";

      y = "yazi";
      v = "nvim";
      se = "sudoedit";
      microfetch = "microfetch && echo";

      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";

      ".." = "cd ..";
    };
    history.size = 10000;

    initExtra = builtins.readFile ./config.sh;
  };
}
