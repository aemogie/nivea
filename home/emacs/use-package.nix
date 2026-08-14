{ lib, config, ... }:
let
  inherit (lib)
    id
    remove
    concatLines
    mapAttrsToList
    optionalString
    types
    mkOption
    mkEnableOption
    literalExpression
    filterAttrs
    ;

  elisp = import ./elisp.nix lib;

  usePackageType = types.submodule (
    {
      config,
      name ? null,
      ...
    }:
    {
      options =
        let
          mkUsePackageOption =
            {
              baseType ? types.attrs,
              mapper ? id,
              ...
            }@args:
            mkOption (
              {
                type = types.nullOr (
                  baseType // { merge = loc: defs: mapper (baseType.merge loc defs); }
                );
                default = null;
              }
              // (removeAttrs args [
                "baseType"
                "mapper"
              ])
            );
        in
        {
          enable = mkEnableOption "use-package configuration for ${name}";
          package = mkOption {
            type = types.functionTo (types.nullOr types.package);
            default = epkgs: epkgs.${name};
            defaultText = literalExpression "epkgs: epkgs.${name}";
            description = "The emacs package to install, or null for a builtin package";
          };

          custom = mkUsePackageOption {
            mapper = elisp.plist;
          };

          extraConfig = mkOption {
            type = types.lines;
            default = "";
          };

          finalConfig = mkOption {
            type = types.str;
            default = elisp.toElisp {
              _printer =
                self:
                let
                  extraConfig = filterAttrs (_: v: v != null) self;
                in
                "(use-package ${name}${
                  if extraConfig == { } then
                    ""
                  else
                    " ${elisp.toElisp (elisp.kwArgs extraConfig)}"
                })"
                + config.extraConfig;
              inherit (config) custom;
            };
            visible = false;
            readOnly = true;
          };
        };
    }
  );
in
{
  options.programs.emacs.lexical-binding =
    (mkEnableOption "lexical-binding for extraConfig")
    // {
      default = true;
    };
  options.programs.emacs.use-package = mkOption {
    type = types.attrsOf usePackageType;
    default = { };
  };

  config.programs.emacs =
    let
      cfg = config.programs.emacs.use-package;
    in
    {
      extraPackages =
        epkgs: remove null (mapAttrsToList (_: { package, ... }: package epkgs) cfg);
      extraConfig =
	let
	  usePackageConfigs = mapAttrsToList (_: { finalConfig, ... }: finalConfig) cfg;
	in
        (optionalString config.programs.emacs.lexical-binding ";; -*- lexical-binding: t; -*-")
        + (if usePackageConfigs == [] then "" else "\n" + (concatLines usePackageConfigs));
    };
}
