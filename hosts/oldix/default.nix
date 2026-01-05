{
  stateVersion,
  hostname,
  hostConfig,
  ...
}:
{
  imports = [
    ../common/default.nix
    ./disko.nix
    ./hardware-configuration.nix
  ];
}
