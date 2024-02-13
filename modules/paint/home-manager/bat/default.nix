{
  lib,
  config,
  ...
}: let
  inherit (builtins) readFile toFile mapAttrs;
  inherit (lib) mkIf mkEnableOption;
  inherit (config.lib.paint.options) mkColorOption;
  inherit (config.lib.paint.misc) replaceVars;
  inherit (config.lib.paint.conversion) rgbToHex;
  inherit (config.paint) core;
  cfg = config.paint.bat;
  # package = config.lib.paint.pkgs.bat;
in {
  options.paint = {
    bat = {
      enable = mkEnableOption "paint.nix bat theming";
      palette = {
        # replace this with actual config values used by tmTheme.
        # actually doable but takes a while, lets start w a simpler one
        rosewater = mkColorOption core.rosewater;
        flamingo = mkColorOption core.flamingo;
        pink = mkColorOption core.pink;
        mauve = mkColorOption core.mauve;
        red = mkColorOption core.red;
        maroon = mkColorOption core.maroon;
        peach = mkColorOption core.peach;
        yellow = mkColorOption core.yellow;
        green = mkColorOption core.green;
        teal = mkColorOption core.teal;
        sky = mkColorOption core.sky;
        sapphire = mkColorOption core.sapphire;
        blue = mkColorOption core.blue;
        lavender = mkColorOption core.lavender;
        text = mkColorOption core.text;
        subtext1 = mkColorOption core.subtext1;
        subtext0 = mkColorOption core.subtext0;
        overlay2 = mkColorOption core.overlay2;
        overlay1 = mkColorOption core.overlay1;
        overlay0 = mkColorOption core.overlay0;
        surface2 = mkColorOption core.surface2;
        surface1 = mkColorOption core.surface1;
        surface0 = mkColorOption core.surface0;
        base = mkColorOption core.base;
        mantle = mkColorOption core.mantle;
        crust = mkColorOption core.crust;
      };
    };
  };
  config.programs.bat = let
    name = "paintnix-custom";
  in
    mkIf (cfg.enable && config.programs.bat.enable) {
      config.theme = name;
      themes.${name}.src = toFile "${name}.tmTheme" (replaceVars (mapAttrs (k: v: "#${rgbToHex v}") cfg.palette) (readFile ./custom.tmTheme));
    };
}
