{ lib', ... }: {
  flake.modules.features.emacs =
    {
      config,
      pkgs,
      self',
      parentClass,
      ...
    }:
    {
      options.emacs.enable = lib'.mkEnableOption "emacs";
      options.emacs.packages = lib'.mkOption {
        type = lib'.wrappers.types.withPackagesType;
        default = epkgs: [ ];
        description = "emacs packages (eg. magit)";
      };
      options.emacs.init = lib'.mkOption {
        type = lib'.types.lines;
        default = "";
        apply =
          init: epkgs:
          if init != "" then
            epkgs.trivialBuild {
              pname = "default";
              version = "0.1.0";
              src = pkgs.writeText "default.el" ''
                ;; -*- lexical-binding: t; -*-
                ${init}
              '';
              packageRequires = config.emacs.packages epkgs;
            }
          else
            null;
        description = "lisp to run on emacs startup";
      };

      config.install = lib'.mkIf (config.emacs.enable && parentClass != "wrapper") {
        packages = [ self'.wrappedPackages.emacs ];
      };
    };

  flake.modules.wrapper.emacs =
    { config, ... }:
    let
      cfg = config.features.emacs;
      isEmacs = lib'.elem "emacs" config.name;
      packages =
        epkgs: (cfg.packages epkgs) ++ (lib'.remove null [ (cfg.init epkgs) ]);
    in
    {
      config = lib'.mkIf (isEmacs && cfg.enable) {
        overrides = [
          { data = emacs: emacs.pkgs.withPackages packages; }
        ];
      };
    };

  # standalone package
  perSystem.wrappedPackages.emacs = { pkgs, ... }: {
    base = pkgs.emacs-pgtk;
    features.emacs.enable = true;
  };
}
