{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.paint.active.custom.term)
    regular
    bright
    foreground
    background
    ;
in
{
  console.colors = map toString [
    background
    regular.red
    regular.green
    regular.yellow
    regular.blue
    regular.magenta
    regular.cyan
    foreground

    bright.gray
    bright.red
    bright.green
    bright.yellow
    bright.blue
    bright.magenta
    bright.cyan
    bright.white
  ];
  services.gpm.enable = true;

  services.kmscon = {
    enable = false;
    hwRender = true;
    # renders weirdly, maybe it doesnt find the font?
    fonts = [
      {
        # needs the full(?) name, just "Iosevka" doesnt work
        name = "Iosevka Regular";
        package = pkgs.iosevka;
      }
    ];
    extraConfig =
      let
        colors = builtins.mapAttrs (_: c: "${toString c.r},${toString c.g},${toString c.b}") {
          palette-black = regular.gray;
          palette-red = regular.red;
          palette-green = regular.green;
          palette-yellow = regular.yellow;
          palette-blue = regular.blue;
          palette-magenta = regular.magenta;
          palette-cyan = regular.cyan;
          palette-light-grey = regular.white;

          palette-dark-grey = bright.gray;
          palette-light-red = bright.red;
          palette-light-green = bright.green;
          palette-light-yellow = bright.yellow;
          palette-light-blue = bright.blue;
          palette-light-magenta = bright.magenta;
          palette-light-cyan = bright.cyan;
          palette-white = bright.white;

          palette-background = foreground;
          palette-foreground = background;
        };
      in
      lib.generators.toKeyValue { } (
        {
          font-size = 14;
          palette = "custom";
        }
        // colors
      );
  };
}
