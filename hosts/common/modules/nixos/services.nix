{ pkgs, ... }:
{
  services = {
    udisks2.enable = true;
    openssh.enable = true;
  };
  virtualisation.docker.enable = true;
}
