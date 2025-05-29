{
  pkgs-unstable,
  ...
}:
{
  services.v2ray = {
    enable = true;
    package = pkgs-unstable.v2ray;
    config = builtins.fromJSON (builtins.readFile ./v2ray.json);
  };
}
