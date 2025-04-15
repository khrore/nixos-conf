{pkgs-unstable, ...}: {
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

    # fish
    fish-lsp # lsp

    # yaml
    yaml-language-server

    # nix
    nil # lsp with features
    statix # lints
    alejandra # formatter

    # GNU C/C++
    # gcc
    # gdb

    # LLVM C/C++
    clang_19 # compiler
    lld_19 # linker
    clang-tools # almost all llvm tools
    lldb # debuger

    # CMake system generator
    cmake # app
    cmake-language-server # lsp
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
    # rustup # toolchain installer
    rust-analyzer # lsp
    rustfmt # formatting
    clippy # linter
    wasm-pack # utility that builds rust-generated WebAssembly package
    cargo-generate # tool to generate a new Rust project by leveraging a pre-existing git repository as a template

    # JS
    nodejs_23 # JS runtime

    # Python
    pyright # language server
    yapf # formatter
    pylint # linter

    # Markdown
    marksman # lsp
    mdformat # formatter
    vale # linter
    glow # previewer

    pandoc # document converter
    hugo # static site generator

    libgcc

    # other stuff
    mold-wrapped # modern fast linker for C/C++/Rust projects
  ];
}
