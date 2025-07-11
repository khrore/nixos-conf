{
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:
{
  environment.systemPackages = [
    inputs.yazi.packages.${pkgs.system}.default
    inputs.zen-browser.packages."${pkgs.system}".default
    inputs.ghostty.packages.${pkgs.system}.default

    (pkgs-unstable.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true; }) { })
    pkgs.brave # modified chromium
    pkgs.chromium
    pkgs.clang
    pkgs-unstable.sing-box
    pkgs-unstable.fish
  ];
}
