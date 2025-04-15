{
  services = {
    pipewire = {
      enable = true;
      wireplumber.enable = true;
    };
  };

  programs = {
    sway.enable = true;
    uwsm.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland = {
        enable = true;
      };
    };
  };
}
