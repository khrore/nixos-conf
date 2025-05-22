# Sets the default applications for given mimetypes
let
  browser = "zen-beta.desktop";
in
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # when using home-manager as module, mimetypes located in
      # /nix/store/{current-hash}-home-manager-path/shared/application
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/chrome" = browser;
      "application/x-extension-htm" = browser;
      "application/x-extension-html" = browser;
      "application/x-extension-shtml" = browser;
      "application/xthml+xml" = browser;
      "application/x-extension-xhtml" = browser;
      "application/x-extension-xht" = browser;

      "application/pdf" = browser;
      "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
      "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
      "x-scheme-handler/discord" = "vesktop.desktop";

      "inode/directory" = "yazi.desktop";
    };
  };
}
