{ pkgs-unstable, terminalEditor, ... }:
{
  programs.nushell = {
    enable = true;
    package = pkgs-unstable.nushell;

    configFile.source = ./config.nu;
  };
}
