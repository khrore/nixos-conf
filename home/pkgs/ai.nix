{
  lib,
  pkgs-unstable,
  mylib,
  system,
  ...
}:
let
  # in Macos moved to brew
  linux = lib.optionals (mylib.isLinux system) [
    # Open AI
    pkgs-unstable.codex
    pkgs-unstable.codex-acp
  ];
in
{
  home.packages = [
    # Anthropic
    pkgs-unstable.claude-code

    # Qwen
    pkgs-unstable.qwen-code

    # Google
    pkgs-unstable.gemini-cli

    # Microsoft
    pkgs-unstable.github-copilot-cli

    # Open source
    pkgs-unstable.opencode
  ]
  ++ linux;
}
