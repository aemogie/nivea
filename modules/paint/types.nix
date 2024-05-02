lib:
let
  inherit (import ./conversions.nix lib) coerceToRgb rgbToHex;
  inherit (lib) mkOption types mkIf;
  inherit (builtins)
    mapAttrs
    hasAttr
    all
    attrNames
    ;
in
let
  ctpPalette = [
    "rosewater"
    "flamingo"
    "pink"
    "mauve"
    "red"
    "maroon"
    "peach"
    "yellow"
    "green"
    "teal"
    "sky"
    "sapphire"
    "blue"
    "lavender"
    "text"
    "subtext1"
    "subtext0"
    "overlay2"
    "overlay1"
    "overlay0"
    "surface2"
    "surface1"
    "surface0"
    "base"
    "mantle"
    "crust"
  ];

  requiredPalette = ctpPalette ++ [
    "primary"
    "alternate"
    "error"
    "warning"
    "success"
  ];

  rgbColor = types.mkOptionType {
    name = "RGB Colour";
    check = v: coerceToRgb v != null;
  };

  colorScheme = types.submodule (
    {
      config,
      name ? null,
      ...
    }:
    {
      options = {
        name = mkOption {
          type = types.str;
          default = mkIf (name != null) name;
          description = "The name of the color scheme";
        };
        isDark = mkOption { type = types.bool; };
        ctpCompat = {
          flavor = mkOption {
            type = types.enum [
              "latte"
              "frappe"
              "macchiato"
              "mocha"
            ];
            description = "The flavor to use when used in catppuccin compatibility mode";
          };
          accent = mkOption {
            type = types.enum ctpPalette;
            description = "The accent to use when used in catppuccin compatibility mode";
          };
        };
        generationOrder = mkOption {
          type = types.listOf (types.enum (attrNames config.palette));
          default = requiredPalette ++ (attrNames (removeAttrs config.palette requiredPalette));
          description = "The order the colors should be in, should it matter";
        };
        palette = mkOption {
          type = types.attrsOf rgbColor;
          apply =
            palette:
            let
              verified = all (
                color:
                if !(hasAttr color palette) then
                  throw "Required color ${color} not found in scheme ${config.name}!"
                else
                  true
              ) requiredPalette;
            in
            if verified then
              mapAttrs (_: v: {
                __toString = rgbToHex;
                inherit (coerceToRgb v) r g b;
              }) palette
            else
              throw "Unreachable";
        };
      };
    }
  );
in
{
  inherit
    ctpPalette
    requiredPalette
    rgbColor
    colorScheme
    ;
}
