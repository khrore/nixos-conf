{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}: let
  shellAliases = {
    v = "nvim";
    vdiff = "nvim -d";
  };
in {
  programs.neovim = {
    enable = true;
    package = pkgs-unstable.neovim-unwrapped;

    viAlias = true;
    vimAlias = true;

    # These environment variables are needed to build and run binaries
    # with external package managers like mason.nvim.
    #
    # LD_LIBRARY_PATH is also needed to run the non-FHS binaries downloaded by mason.nvim.
    # it will be set by nix-ld, so we do not need to set it here again.
    extraWrapperArgs = with pkgs; [
      # LIBRARY_PATH is used by gcc before compilation to search directories
      # containing static and shared libraries that need to be linked to your program.
      "--suffix"
      "LIBRARY_PATH"
      ":"
      "${lib.makeLibraryPath [stdenv.cc.cc zlib]}"

      # PKG_CONFIG_PATH is used by pkg-config before compilation to search directories
      # containing .pc files that describe the libraries that need to be linked to your program.
      "--suffix"
      "PKG_CONFIG_PATH"
      ":"
      "${lib.makeSearchPathOutput "dev" "lib/pkgconfig" [stdenv.cc.cc zlib]}"
    ];

    # Currently we use lazy.nvim as neovim's package manager, so comment this one.
    #
    # related project:
    #  https://github.com/b-src/lazy-nix-helper.nvim
    # plugins = with pkgs.vimPlugins; [
    # search all the plugins using https://search.nixos.org/packages
    # LazyVim
    # telescope-fzf-native-nvim
    # nvim-treesitter.withAllGrammars
    # catppuccin-nvim
    # gruvbox-nvim
    # trouble-nvim
    # telescope-nvim
    # nvim-lspconfig
    # lualine-nvim
    # mason-nvim
    # ];
  };

  xdg.configFile."nvim/lua".source = ./config/lua;
  xdg.configFile."nvim/init.lua".source = ./config/init.lua;
  home.shellAliases = shellAliases;
  # programs.nushell.shellAliases = shellAliases;
}
