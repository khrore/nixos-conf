# Atuin replaces your existing shell history with a SQLite database,
# and records additional context for your commands.
# Additionally, it provides optional and fully encrypted
# synchronisation of your history between machines, via an Atuin server.
{ pkgs-unstable, ... }:
{
  programs.atuin = {
    enable = true;
    package = pkgs-unstable.atuin;

    enableZshIntegration = true;
    enableNushellIntegration = true;
    enableFishIntegration = true;

    settings = builtins.fromTOML (builtins.readFile ./config.toml);
  };
}
