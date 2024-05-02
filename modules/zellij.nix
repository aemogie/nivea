{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.zellij;
in
{
  options.programs.zellij =
    let
      inherit (lib) mkOption;
      inherit (lib.types) attrsOf lines str;
    in
    {
      baseCommand = mkOption {
        type = str;
        default = lib.getExe cfg.package;
        description = ''
          The base command used for various zellij commands. Options can't include subcommands.
          Use this option to enable autostart for your terminal emulator.
        '';
      };
      configs = mkOption {
        type = attrsOf lines;
        default = { };
        description = ''
          programs.zellij.settings is broken, so use this instead.
        '';
        apply = builtins.mapAttrs (
          name: text: rec {
            source = pkgs.writeTextFile {
              inherit text;
              name = "zellij-config-${name}.kdl";
            };
            command = "${cfg.baseCommand} --config ${source}";
          }
        );
      };
      layouts = mkOption {
        type = attrsOf lines;
        default = { };
        description = ''
          Layout files for zellij in KDL format
        '';
        apply = builtins.mapAttrs (
          name: text: rec {
            source = pkgs.writeTextFile {
              inherit text;
              name = "zellij-layout-${name}.kdl";
            };
            command = {
              new-session = "${cfg.baseCommand} --layout ${source}";
              new-tab = "${cfg.baseCommand} action new-tab --layout ${source}";
            };
          }
        );
        example = {
          default =
            #kdl
            ''
              layout {
                pane name="Shell"
              }
            '';
        };
      };
    };

  config =
    let
      layoutFiles = lib.concatMapAttrs (
        name:
        { source, ... }:
        {
          "zellij/layouts/${name}.kdl" = {
            inherit source;
          };
        }
      ) cfg.layouts;
    in
    {
      xdg.configFile =
        layoutFiles
        // lib.optionalAttrs (cfg.configs ? default) {
          "zellij/config.kdl".source = cfg.configs.default.source;
        };
    };
}
