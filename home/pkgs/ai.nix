{
  lib,
  pkgs-unstable,
  mylib,
  system,
  ...
}:
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

    # Open AI
    pkgs-unstable.codex
    pkgs-unstable.codex-acp

    # Open source
    pkgs-unstable.opencode
  ];
}
