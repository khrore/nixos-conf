{
  pkgs-unstable,
  ...
}:
{
  services.sing-box = {
    enable = true;
    package = pkgs-unstable.sing-box;
    settings = builtins.fromJSON (builtins.readFile ./sing-box.json);
  };
}
