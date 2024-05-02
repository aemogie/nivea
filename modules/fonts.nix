{ lib, config, ... }:
{
  options.fonts =
    let
      inherit (lib) mkOption;
      inherit (lib.types) listOf package str;
    in
    {
      packages = mkOption {
        type = listOf package;
        default = [ ];
        description = ''
          Analogous to `fonts.packages` NixOS option.
        '';
      };
      monospace = mkOption { type = str; };
      serif = mkOption { type = str; };
      sans = mkOption { type = str; };
    };
  config = {
    home.packages = config.fonts.packages;
  };
}
