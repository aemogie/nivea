{ lib', ... }: {
  flake.modules.wrapper.emacs =
    { config, pkgs, ... }:
    let
      cfg = config.features.emacs;
      isEmacs = lib'.elem "emacs" config.name;
      init =
        epkgs:
        epkgs.trivialBuild {
          pname = "init";
          version = "0.1.0";
          src = pkgs.writeText "default.el" cfg.init;
          packageRequires = cfg.emacsPackages epkgs;
        };
    in
    {
      options.features.emacs.enable = lib'.mkEnableOption "emacs";
      options.features.emacs.emacsPackages = lib'.mkOption {
        type = lib'.wrappers.types.withPackagesType;
        default = epkgs: [ ];
        description = "emacs packages (eg. magit)";
      };
      options.features.emacs.init = lib'.mkOption {
        type = lib'.types.lines;
        default = "";
        description = "lisp to run on emacs startup";
      };
      config = lib'.mkIf (isEmacs && cfg.enable) {
        overrides = [
          { data = emacs: emacs.pkgs.withPackages (epkgs: [ (init epkgs) ]); }
        ];
      };
    };

  # standalone package
  perSystem.wrappedPackages.emacs = { pkgs, ... }: {
    base = pkgs.emacs-pgtk;
    features.emacs.enable = true;
  };
}
