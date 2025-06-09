{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.home-manager # for home-manager commands
  ];
}
