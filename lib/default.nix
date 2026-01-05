{ lib, ... }:
{
  scanPaths =
    path:
    builtins.map (f: (path + "/${f}")) (
      builtins.attrNames (
        lib.attrsets.filterAttrs (
          path: _type:
          (_type == "directory") # include directories
          || (
            (path != "default.nix") # ignore default.nix
            && (lib.strings.hasSuffix ".nix" path) # include .nix files
          )
        ) (builtins.readDir path)
      )
    );

  # Platform detection helpers
  isDarwin = system: (builtins.match ".*-darwin" system) != null;
  isLinux = system: (builtins.match ".*-linux" system) != null;
}
