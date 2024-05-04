{ config, lib, ... }:
let
  inherit (import ./types.nix lib) colorScheme;
  inherit (lib) mkOption types;
  inherit (builtins) attrNames;

  cfg = config.paint;
  mkSchemeOption =
    { ... }@attrs:
    let
      byName = types.enum (attrNames cfg.schemes);
    in
    mkOption {
      type = types.either byName colorScheme;
      apply =
        v:
        if byName.check v then
          cfg.schemes.${v}
        else if colorScheme.check v then
          v
        else
          throw "Unreachable";
    }
    // attrs;
in
{
  options.paint = {
    active = mkSchemeOption {
      description = "Color scheme to be used by default";
      default = cfg.light;
    };
    light = mkSchemeOption {
      description = "Color scheme to be used if an application explicitly requests for a light mode";
      default = "catppuccin_latte";
    };
    dark = mkSchemeOption {
      description = "Color scheme to be used if an application explicitly requests for a dark mode";
      default = "catppuccin_mocha";
    };
    schemes = mkOption {
      type = types.attrsOf colorScheme;
      description = "An attribute set of color schemes";
      default = {
        catppuccin_latte = ./catppuccin_latte.nix;
        catppuccin_mocha = ./catppuccin_mocha.nix;
      };
    };
  };
}
