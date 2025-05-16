{ pkgs-unstable, ... }:
{
  services.hyprpolkitagent = {
    enable = true;
    package = pkgs-unstable.hyprpolkitagent;
  };
}
