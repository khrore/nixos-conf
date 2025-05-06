{
  programs.firefox = {
    enable = true;
    languagePacks = [
      "en-US"
      "ru"
    ];
    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;
    };
    # profiles = {
    #   ff = {
    #     isDefault = false;
    #     name = "ff";
    #     path = "ff.default";
    #   };
    # };
  };
}
