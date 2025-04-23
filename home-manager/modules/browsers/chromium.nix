{
  programs.chromium = {
    enable = true;
    extensions = [
      # FireShot
      { id = "mcbpblocgmgfnpjjppndjkmgjaogfceg"; }

      # uBlock Origin
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }

      # Dark Reader
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; }

      # Guide how to enable catppuccin Dark Reader
      # https://github.com/catppuccin/dark-reader

      # Catppuccin theme
      { id = "bkkmolkhemgaeaeggcmfbghljjjoofoh"; }
    ];
  };
}

