{ lib, ... }:
rec {
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

  # Recursively walk a directory tree, returning { "rel/path" = /abs/nix/path; ... }
  # Skips .gitkeep. Returns {} if dir does not exist.
  scanFiles =
    let
      go =
        prefix: dir:
        let
          entries = builtins.readDir dir;
          names = builtins.attrNames entries;
        in
        builtins.foldl' (
          acc: name:
          let
            type = entries.${name};
            full = dir + "/${name}";
            rel = if prefix == "" then name else "${prefix}/${name}";
          in
          if name == ".gitkeep" then acc
          else if type == "directory" then acc // (go rel full)
          else if type == "regular" then acc // { "${rel}" = full; }
          else acc
        ) { } names;
    in
    dir:
    if builtins.pathExists dir then go "" dir else { };

  # Merge common/ and <platform>/ under baseDir. Platform files override common.
  # Returns a list of { target, subdir } for direct symlink creation via activation.
  linkDotfiles =
    { baseDir, platform }:
    let
      common = scanFiles (baseDir + "/common");
      platformDir = scanFiles (baseDir + "/${platform}");
      commonOnly = lib.filterAttrs (name: _: !(lib.hasAttr name platformDir)) common;
      commonEntries = lib.mapAttrsToList (name: _: { target = name; subdir = "common"; }) commonOnly;
      platformEntries = lib.mapAttrsToList (name: _: { target = name; subdir = platform; }) platformDir;
    in
    commonEntries ++ platformEntries;
}
