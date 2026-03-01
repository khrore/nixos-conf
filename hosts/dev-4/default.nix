{ mylib, inputs, ... }:
{
  imports = mylib.scanPaths ./. ++ [ ../common/default.nix ];
  environment.systemPackages = [ inputs.agenix.packages.x86_64-linux.default ];

  # Required by gpg
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.pcscd.enable = true;
}
