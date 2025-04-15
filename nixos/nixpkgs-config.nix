{
  pkgs,
  pkgs-unstable,
  terminal,
  ...
}: {
  # system.extraDependencies = [
  #   factorio.src
  # ];

  environment.systemPackages = [
    pkgs.home-manager # for home-manager commands
    pkgs-unstable.${terminal} # terminal
    # pkgs.factorio-space-age
    # libsForQt5.qt5.qtwayland
    # libsForQt5.qt5.qtbase
  ];
}
