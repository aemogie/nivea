{ lib, ... }:
{
  paint._custom.term =
    scheme:
    let
      # TODO: export lib
      inherit (import ../types.nix lib) rgbColor;
      inherit (lib) mkOption;
      mkColOption =
        default:
        mkOption {
          type = rgbColor;
          inherit default;
        };
      inherit (scheme.palette)
        base
        text
        surface2
        subtext0
        surface1
        subtext1
        red
        green
        yellow
        blue
        pink
        teal
        ;

      # TODO: add rgb/hsv colour manipulation
      submodule =
        overrides:
        lib.types.submodule {
          options = {
            gray = mkColOption (overrides.gray or (if scheme.isDark then surface2 else subtext0));
            red = mkColOption (overrides.red or red);
            green = mkColOption (overrides.green or green);
            yellow = mkColOption (overrides.yellow or yellow);
            blue = mkColOption (overrides.blue or blue);
            magenta = mkColOption (overrides.magenta or pink);
            cyan = mkColOption (overrides.cyan or teal);
            white = mkColOption (overrides.white or (if scheme.isDark then subtext0 else surface2));
          };
        };
    in
    {
      background = mkColOption base;
      foreground = mkColOption text;
      regular = mkOption {
        type = submodule { };
        description = "the normal colours used by terminals";
        default = { };
      };
      bright = mkOption {
        type = submodule {
          gray = if scheme.isDark then surface1 else subtext1;
          white = if scheme.isDark then subtext1 else surface1;
        };
        description = "the bright/bold colours used by terminals";
        default = { };
      };
      dim = mkOption {
        type = submodule { };
        description = "the dim colours used by terminals";
        default = { };
      };
    };
}
