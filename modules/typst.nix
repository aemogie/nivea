{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.programs.typst =
    let
      inherit (lib) mkEnableOption mkOption mkPackageOption;
      inherit (lib.types) listOf package;
    in
    {
      enable = mkEnableOption "typst";
      package = mkPackageOption pkgs [ "typst" ] { };
      fonts = mkOption {
        type = listOf package;
        default = config.fonts.packages or [ ];
        description = ''
          Fonts to add to the environment variable TYPST_FONT_PATHS.
        '';
      };
    };

  config =
    let
      cfg = config.programs.typst;
      # two `symlinkjoin`s would be cleaner, but...
      wrapped = pkgs.symlinkJoin {
        name = "typst-wrapped";
        paths = cfg.fonts ++ [ cfg.package ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/typst --set TYPST_FONT_PATHS $out
        '';
      };
    in
    # lib.optionalAttrs cfg.enable
    {
      home.packages = [ wrapped ];
    };
}
