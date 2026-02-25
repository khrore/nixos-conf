{
  pkgs-unstable,
  ...
}:
{
  home.packages = [
    # Qwen
    pkgs-unstable.qwen-code

    # Microsoft
    pkgs-unstable.github-copilot-cli

    # Open source
    pkgs-unstable.opencode
  ];
}
