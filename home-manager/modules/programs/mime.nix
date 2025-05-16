# Sets the default applications for given mimetypes
# Example:
# {
#   "application/pdf" = "firefox.desktop";
#   "image/png" = [
#     "sxiv.desktop"
#     "gimp.desktop"
#   ];
# }
{
  xdg.mime = {
    enable = true;
  };
}
