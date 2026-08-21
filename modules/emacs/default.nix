{ lib', config, ... }:
let
  inherit (lib')
    mapAttrs
    filterAttrs
    remove
    types
    mkOption
    mkEnableOption
    elisp
    extenderModule
    hm
    ;
in
{
  config.lib' = final: prev: { elisp = import ./elisp.nix prev; };

  options.programs.emacs.lexical-binding =
    (mkEnableOption "lexical-binding for extraConfig")
    // {
      default = true;
    };
  options.programs.emacs.use-package = mkOption {
    type = types.attrsOf (
      types.submodule [
        (import ./use-package.nix)
        extenderModule
      ]
    );
    default = { };
  };

  config.programs.emacs =
    let
      cfg = filterAttrs (_: m: m.enable) config.programs.emacs.use-package;
      cfgWithDeps = mapAttrs (
        _: v: hm.dag.entryAfter (if v.after == null then [ ] else v.after.xs) v
      ) cfg;
      cfgSorted =
        (hm.dag.topoSort cfgWithDeps).result
          or (abort "use-package.after: cyclic dependency detected");
    in
    {
      extraPackages =
        epkgs: remove null (map ({ data, ... }: data.package epkgs) cfgSorted);
      extraConfig =
        let
          body = map ({ data, ... }: data.fullConfig) cfgSorted;
        in
        elisp.toElisp (elisp.eval body config.programs.emacs.lexical-binding);
    };
}
