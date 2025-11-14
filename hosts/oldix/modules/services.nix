{ pkgs, ... }:
{
  services = {
    udisks2.enable = true;
    openssh.enable = true;
    upower.enable = true;
  };
  virtualisation.docker.enable = true;
}
