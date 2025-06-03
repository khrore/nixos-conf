{
  pkgs-unstable,
  ...
}:
{
  services.sing-box = {
    enable = true;
    package = pkgs-unstable.sing-box;
    # TODO: isolate sing-box config to private repo
    settings = builtins.fromJSON (builtins.readFile /home/user/sing-box/sing-box.json);
  };
}
