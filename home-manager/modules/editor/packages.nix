{ pkgs-unstable, ... }:
{
  home.packages = with pkgs-unstable; [
    # lua
    lua-language-server # lsp
    luajit # just-in-time compiler
    stylua # formatter
    luajitPackages.luacheck # linter

    # bash
    bash-language-server # lsp
    shellcheck # Shell script analysis tool
    shfmt # Shell parser and formatter

    # nu
    nufmt # formater

    # fish
    fish-lsp # lsp

    # yaml
    yaml-language-server

    vscode-langservers-extracted # HTML/CSS/JSON/ESLint language servers extracted from vscode

    # nix
    nil # lsp with features
    nixfmt-rfc-style # formatter

    # LLVM C/C++
    clang_19 # compiler
    lld_19 # linker
    clang-tools # almost all llvm tools
    lldb # debuger
    # vscode-extensions.vadimcn.vscode-lldb # native debug extension for VSCode (need for nvim-dap)

    # CMake system generator
    cmake # app
    neocmakelsp # lsp
    cmake-format # formater
    cmake-lint # linter

    # Ninja build system
    ninja # small and fast build system

    # Make build system
    gnumake # app
    checkmake # linter

    # Rust
    cargo # package manager
    rustc # compiler
    rust-analyzer # lsp
    rustfmt # formatting
    clippy # linter
    bacon # background rust checker

    # JS
    nodejs_23 # JS runtime

    # Python
    # pyright # language server
    ruff # formatter
    basedpyright # type checker
    # ruff-lsp # lsp

    # Markdown
    marksman # lsp
    mdformat # formatter
    glow # previewer
    markdownlint-cli2 # command-line interface for linting

    pandoc # document converter
    hugo # static site generator

    hyprls # hyprland lsp

    # libgcc

    # other stuff
    mold-wrapped # modern fast linker for C/C++/Rust projects
  ];
}
