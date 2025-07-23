{ pkgs, ... }:
{
  services = {
    udisks2.enable = true;
    openssh.enable = true;
    upower.enable = true;
    postgresql = {
      enable = true;
      ensureDatabases = [ "mydatabase" ];
      enableTCPIP = true;
      # port = 5432;
      authentication = pkgs.lib.mkOverride 10 ''
        #...
        #type database DBuser origin-address auth-method
        local all       all     trust
        # ipv4
        host  all      all     127.0.0.1/32   trust
        # ipv6
        host all       all     ::1/128        trust
      '';
      initialScript = pkgs.writeText "backend-initScript" ''
        CREATE ROLE khrore WITH LOGIN CREATEDB;
        CREATE DATABASE demo;
        GRANT ALL PRIVILEGES ON DATABASE demo TO khrore;
      '';
    };
  };
  virtualisation.docker.enable = true;
}
