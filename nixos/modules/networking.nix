# Setuping network for all apps and services
{
  config,
  pkgs-unstable,
  ...
}: {
  # Setupping proxy and ipv4 to our network
  networking.interfaces.enp2s0.ipv4.addresses = [
    {
      address = "130.100.7.83";
      prefixLength = 24;
    }
  ];

  networking.proxy.allProxy = "http://130.100.7.222:1082";
  services.syncthing.all_proxy = "http://130.100.7.222:1082";
  programs.proxychains = {
    enable = true;
    package = pkgs-unstable.proxychains-ng;
    proxies.prx1 = {
      enable = true;
      type = "http";
      host = "130.100.7.222";
      port = 1082;
    };
  };

  # boot.extraModulePackages = [config.boot.kernelPackages.wireguard];

  # networking.wg-quick.interfaces.wg0.configFile = "/home/user/Downloads/v/VPNTYPE-FRA6.conf";
  #
  # Setupping DNS
  networking.nameservers = ["130.100.7.253" "8.8.8.8" "8.8.4.4" "1.1.1.1" "1.0.0.1"];
  networking.resolvconf.enable = true;
}
