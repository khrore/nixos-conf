{ configurationLimit, ... }:
{
  boot.loader = {
    systemd-boot = {
      inherit configurationLimit;
      enable = true;
    };
    efi.canTouchEfiVariables = true;
  };
}
