{
  stateVersion,
  username,
  ...
}:
{
  imports = [
    ./home-manager/modules
    ./home-manager/home-packages.nix
  ];

  home = {
    inherit username stateVersion;
    homeDirectory = "/home/${username}";
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
