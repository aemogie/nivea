{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    optionalString
    recursiveUpdate
    ;
  inherit (lib.types)
    either
    attrs
    str
    lines
    pathInStore
    listOf
    ;
  inherit (builtins) match isAttrs;
  inherit (pkgs) callPackage;
  cfg = config.programs.spicetify;
  jsFile = lib.types.addCheck pathInStore (p: (match ".*\\.js" (baseNameOf p)) != null);
in
{
  options.programs.spicetify = {
    enable = mkEnableOption "spicetify-cli to patch spotify";
    theme = {
      enable = mkEnableOption "custom theme for Spicetify";
      path = mkOption {
        type = pathInStore;
        description = "The path to the spicetify theme folder.";
      };
      colorScheme = mkOption {
        type = either str attrs;
        description = "Either the name of a color scheme builtin to your theme or a custom color scheme.";
      };
      customColorSchemeName = mkOption {
        type = str;
        default = "__custom";
        description = "The internal name used for the custom color scheme.";
      };
      patches = mkOption {
        type = attrs;
        description = "INI entries to add in the [Patch] section of config.";
        default = { };
      };
    };
    extensions = mkOption {
      type = listOf jsFile;
      description = "List of paths to spicetify extension `.js` files.";
      default = [ ];
    };
    custom_apps = mkOption {
      type = listOf jsFile;
      description = "List of paths to spicetify custom app `.js` files.";
      default = [ ];
    };
    config = mkOption rec {
      type = attrs;
      apply = v: recursiveUpdate default v;
      default = {
        Setting = {
          # replaced at compile-time
          spotify_path = "@SPOTIFY_PATH@";
          prefs_path = "@PREFS_PATH@";
          current_theme = optionalString cfg.theme.enable (baseNameOf cfg.theme.path);
          color_scheme = optionalString cfg.theme.enable (
            if isAttrs cfg.theme.colorScheme then cfg.theme.customColorSchemeName else cfg.theme.colorScheme
          );
          inject_theme_js = true;
          inject_css = true;
          replace_colors = true;
          overwrite_assets = false;
          spotify_launch_flags = "";
          check_spicetify_update = false;
        };
        Preprocesses = {
          disable_sentry = true;
          disable_ui_logging = true;
          remove_rtl_rule = true;
          expose_apis = true;
        };
        AdditionalOptions = {
          extensions = map baseNameOf cfg.extensions;
          custom_apps = map baseNameOf cfg.custom_apps;
          sidebar_config = true;
          home_config = true;
          experimental_features = true;
        };
        Patch = cfg.theme.patches;
      };
    };
    extraCommands = mkOption {
      type = lines;
      description = "Extra commands to run after the build.";
      default = "";
    };
  };
  config = {
    # maybe add support for `environment.systemPackages`
    home.packages = [ (callPackage (import ./builder.nix cfg) { }) ];
  };
}
