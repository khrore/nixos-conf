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

    # Open source
    pkgs-unstable.opencode
  ];
}
