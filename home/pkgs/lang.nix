{
  lib,
  pkgs-unstable,
  mylib,
  system,
  ...
}:
let
  # Hyprland-specific tools (Linux only)
  linuxTools = lib.optionals (mylib.isLinux system) [
    pkgs-unstable.hyprls
    # pkgs-unstable.marksman
  ];
in
{
  home.packages = [
    # C/C++ stuff
    pkgs-unstable.clang
    pkgs-unstable.lldb

    # Nix
    pkgs-unstable.nil
    pkgs-unstable.nixfmt
    pkgs-unstable.statix
    pkgs-unstable.nixd

    # Lua
    pkgs-unstable.lua-language-server
    pkgs-unstable.luajit
    pkgs-unstable.stylua
    pkgs-unstable.luajitPackages.luacheck

    # Python
    pkgs-unstable.python313
    pkgs-unstable.ruff
    pkgs-unstable.basedpyright
    pkgs-unstable.python313Packages.debugpy

    # TypeScript and JavaScript
    pkgs-unstable.vtsls
    pkgs-unstable.vscode-js-debug
    pkgs-unstable.prettierd

    # Bash
    pkgs-unstable.bash-language-server
    pkgs-unstable.shellcheck
    pkgs-unstable.shfmt

    # Go
    pkgs-unstable.delve

    # Nushell
    pkgs-unstable.nufmt

    # Fish
    pkgs-unstable.fish-lsp

    # Markdown
    pkgs-unstable.mdformat
    pkgs-unstable.markdownlint-cli2
    pkgs-unstable.glow

    # Yaml
    pkgs-unstable.yaml-language-server

    # HTML/CSS/JSON/ESLint
    pkgs-unstable.vscode-langservers-extracted

    # CMake
    pkgs-unstable.cmake
    pkgs-unstable.neocmakelsp
    pkgs-unstable.cmake-format
    pkgs-unstable.cmake-lint

    # Make
    pkgs-unstable.gnumake
    pkgs-unstable.checkmake

    # JSON
    pkgs-unstable.formatjson5

    # General
    pkgs-unstable.tree-sitter
  ]
  ++ linuxTools;
}
