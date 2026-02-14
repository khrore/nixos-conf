{ mylib, ... }:
{
  imports = mylib.scanPaths ./. ++ [ ../common/default.nix ];
}
