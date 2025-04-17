{
  programs.chromium = {
    enable = true;
    extensions = [
      # Dark Reader
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; }
      
      # FireShot
      { id = "mcbpblocgmgfnpjjppndjkmgjaogfceg"; }

      # uBlock Origin
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
    ];
  };
}