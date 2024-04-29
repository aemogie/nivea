{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.paint.active.palette) base text surface2 subtext0 surface1 subtext1 red green yellow blue pink teal overlay0;
  inherit (config.paint.active) isDark;

  _ = [
    "1e1e2e" # base      # bg_default, black
    "585b70" # surface2  # red

    "bac2de" # subtext1  # green
    "a6adc8" # subtext0  # yellow

    "f38ba8" # red       # blue,
    "f38ba8" #           # magenta

    "a6e3a1" # green     # cyan, underline
    "a6e3a1" #           # white, default

    "f9e2af" # yellow    # dimmed
    "f9e2af" #           # bold (black, red)

    "89b4fa" # blue      #
    "89b4fa" #           # bold (green, yellow)

    "f5c2e7" # pink      #
    "f5c2e7" #           # bold (blue, magenta)

    "94e2d5" # teal      #
    "94e2d5" #           # bold (cyan, white)
  ];
in {
  console.colors = map toString [
    base #   black, background
    red #    red
    green #  green
    yellow # yellow
    blue #   blue,
    pink #   magenta
    teal #   cyan
    text #   white, foreground

    # bold
    base #   black, background
    red #    red
    green #  green
    yellow # yellow
    blue #   blue,
    pink #   magenta
    teal #   cyan
    text #   white, foreground
  ];
  services.gpm.enable = true;

  services.kmscon = {
    enable = true;
    hwRender = true;
    # renders weirdly, maybe it doesnt find the font?
    fonts = [
      {
        # needs the full(?) name, just "Iosvka" doesnt work
        name = "Iosevka Regular";
        package = pkgs.iosevka;
      }
    ];
    extraConfig = let
      colors = builtins.mapAttrs (_: c: "${toString c.r},${toString c.g},${toString c.b}") {
        palette-black =
          if isDark
          then surface1
          else surface2;
        palette-red = red;
        palette-green = green;
        palette-yellow = yellow;
        palette-blue = blue;
        palette-magenta = pink;
        palette-cyan = teal;
        palette-light-grey =
          if isDark
          then subtext1
          else subtext0;

        palette-dark-grey =
          if isDark
          then surface2
          else surface1;
        palette-light-red = red;
        palette-light-green = green;
        palette-light-yellow = yellow;
        palette-light-blue = blue;
        palette-light-magenta = pink;
        palette-light-cyan = teal;
        palette-white =
          if isDark
          then subtext0
          else subtext1;

        palette-background = base;
        palette-foreground = text;
      };
    in
      lib.generators.toKeyValue {} (
        {
          font-size = 14;
          palette = "custom";
        }
        // colors
      );
  };
}
