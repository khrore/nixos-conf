# Setuping network for all apps and services
{
  pkgs-unstable,
  ...
}:
{
  # Setupping proxy and ipv4 to our network
  networking.useNetworkd = true;
  networking.interfaces.enp2s0.ipv4.addresses = [
    {
      address = "130.100.7.69";
      prefixLength = 24;
    }
  ];
  systemd.network.networks.enp2s0.dns = [ "130.100.7.253" ];

  networking.proxy.default = "http://130.100.7.222:1082";

  programs.proxychains = {
    enable = true;
    package = pkgs-unstable.proxychains-ng;
    proxies.prx1 = {
      enable = true;
      type = "socks5";
      host = "130.100.7.222";
      port = 1081;
    };
  };

  # Setupping DNS
  networking.nameservers = [ "130.100.7.253" ];
  services.resolved.enable = true;
}
