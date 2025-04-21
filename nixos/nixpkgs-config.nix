{
  pkgs,
  pkgs-unstable,
  terminal,
  ...
}:
{
  environment.systemPackages = [
    pkgs.home-manager # for home-manager commands
    pkgs-unstable.${terminal} # terminal
    pkgs-unstable.wireguard-tools
  ];
}
