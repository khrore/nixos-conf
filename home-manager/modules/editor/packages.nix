{ pkgs-unstable, ... }:
{
  home.packages = with pkgs-unstable; [
    # Nix
    nil # lsp with features
    nixfmt-rfc-style # formatter

    # Lua
    lua-language-server # lsp
    luajit # just-in-time compiler
    stylua # formatter
    luajitPackages.luacheck # linter

    # Python
    python314 # python exec
    # pyright # language server
    ruff # formatter
    basedpyright # lsp + type checker
    # ruff-lsp # lsp

    # TypeScript and JavaScript
    vtsls # lsp
    vscode-js-debug # debugger
    prettierd # formatter daemon

    # Bash
    bash-language-server # lsp
    shellcheck # Shell script analysis tool
    shfmt # Shell parser and formatter

    # Nushell
    nufmt # formater

    # Fish
    fish-lsp # lsp

    # Markdown
    marksman # lsp
    mdformat # formatter
    glow # previewer
    markdownlint-cli2 # command-line interface for linting

    # Yaml
    yaml-language-server # lsp

    # HTML/CSS/JSON/ESLint language servers extracted from vscode
    vscode-langservers-extracted

    # Hyprland
    hyprls # lsp

    # CMake system generator
    cmake # app
    neocmakelsp # lsp
    cmake-format # formater
    cmake-lint # linter

    # Make build system
    gnumake # app
    checkmake # linter
  ];
}
