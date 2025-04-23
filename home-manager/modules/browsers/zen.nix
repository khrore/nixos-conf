{ inputs, pkgs-unstable, ... }:
{
  home.packages = [
    inputs.zen-browser.packages."${pkgs-unstable.stdenv.system}".default
    # {
    #   policies = {
    #     DisableAppUpdate = true;
    #     DisableTelemetry = true;
    #     # find more options here: https://mozilla.github.io/policy-templates/
    #   };
    # }
  ];
}
