{
  # Creating a user and giving it needed privileges
  username,
  pkgs-unstable,
  ...
}:
{
  users.users.${username}.packages = [
    # Rust/C/C++
    pkgs-unstable.clang
    pkgs-unstable.lldb

    # Nix
    pkgs-unstable.nil # lsp with features
    pkgs-unstable.nixfmt-rfc-style # formatter

    # Lua
    pkgs-unstable.lua-language-server # lsp
    pkgs-unstable.luajit # just-in-time compiler
    pkgs-unstable.stylua # formatter
    pkgs-unstable.luajitPackages.luacheck # linter

    # Python
    pkgs-unstable.python314 # python exec
    pkgs-unstable.ruff # formatter
    pkgs-unstable.basedpyright # lsp + type checker
    pkgs-unstable.python313Packages.debugpy

    # TypeScript and JavaScript
    pkgs-unstable.vtsls # lsp
    pkgs-unstable.vscode-js-debug # debugger
    pkgs-unstable.prettierd # formatter daemon

    # Bash
    pkgs-unstable.bash-language-server # lsp
    pkgs-unstable.shellcheck # Shell script analysis tool
    pkgs-unstable.shfmt # Shell parser and formatter

    # Go
    pkgs-unstable.delve

    # Nushell
    pkgs-unstable.nufmt # formater

    # Fish
    pkgs-unstable.fish-lsp # lsp

    # Markdown
    pkgs-unstable.marksman # lsp
    pkgs-unstable.mdformat # formatter
    pkgs-unstable.markdownlint-cli2 # command-line interface for linting
    pkgs-unstable.glow # previewer

    # Yaml
    pkgs-unstable.yaml-language-server # lsp

    # HTML/CSS/JSON/ESLint language servers extracted from vscode
    pkgs-unstable.vscode-langservers-extracted

    # Hyprland
    pkgs-unstable.hyprls # lsp

    # CMake system generator
    pkgs-unstable.cmake # app
    pkgs-unstable.neocmakelsp # lsp
    pkgs-unstable.cmake-format # formater
    pkgs-unstable.cmake-lint # linter

    # Make build system
    pkgs-unstable.gnumake # app
    pkgs-unstable.checkmake # linter
  ];
}
