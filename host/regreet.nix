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
  dark_str = if isDark then "dark" else "light";
in
{
  programs.regreet = {
    enable = true;
    cageArgs = [
      "-s"
      "-d"
    ];
    theme = {
      name = "catppuccin-${flavor}-${accent}-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = [ accent ];
        variant = flavor;
      };
    };
    iconTheme = {
      name = "Papirus-${caps dark_str}";
      package = pkgs.catppuccin-papirus-folders.override {
        accent = accent;
        flavor = flavor;
      };
    };
    font = {
      package = pkgs.iosevka-bin.override { variant = "Aile"; };
      name = "Iosevka Aile";
      size = 11;
    };
    cursorTheme = {
      package = pkgs.catppuccin-cursors."${flavor}${caps accent}";
      name = "catppuccin-${flavor}-${accent}-cursors";
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
