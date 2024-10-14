{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) toUpper substring stringLength;
  inherit (config.paint.active.ctpCompat) flavor accent;
  inherit (config.paint.active) isDark;

  caps = s: "${toUpper (substring 0 1 s)}${substring 1 (stringLength s) s}";
  dark_str = if isDark then "Dark" else "Light";
in
{
  programs.regreet = {
    enable = true;
    cageArgs = [
      "-s"
      "-d"
    ];
    theme = {
      package = pkgs.catppuccin-gtk.override {
        accents = [ accent ];
        variant = flavor;
      };
      name = "Catppuccin-${caps flavor}-Standard-${caps accent}-${dark_str}";
    };
    iconTheme = {
      package = pkgs.catppuccin-papirus-folders.override {
        accent = accent;
        flavor = flavor;
      };
      name = "Papirus" + (if isDark then "" else "-Dark");
    };
    font = {
      package = pkgs.iosevka-bin.override { variant = "Aile"; };
      name = "Iosevka Aile";
      size = 11;
    };
    cursorTheme = {
      package = pkgs.catppuccin-cursors."${flavor}${dark_str}";
      name = "Catppuccin-${caps flavor}-${dark_str}-Cursors";
    };
    settings = {
      background = {
        path = if isDark then ../assets/catppuccino-many.png else ../assets/catppuccino-green.png;
        fit = "Cover";
      };
      GTK.application_prefer_dark_theme = isDark;
    };
  };
}
