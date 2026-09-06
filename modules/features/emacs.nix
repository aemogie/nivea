{ lib', ... }: {
  flake.wrapperModules.emacs =
    { config, pkgs, ... }:
    let
      cfg = config.features.emacs;
    in
    {
      options.features.emacs.enable = lib'.mkEnableOption "emacs";
      options.features.emacs.emacsPackages = lib'.mkOption {
        type = lib'.wrappers.types.withPackagesType;
        default = epkgs: [ ];
        description = "emacs packages (eg. magit)";
      };
      config = lib'.mkIf cfg.enable {
        package = pkgs.emacs-pgtk;
        overrides = [
          { data = emacs: emacs.pkgs.withPackages cfg.emacsPackages; }
        ];
      };
    };
  perSystem.wrappedPackages.emacs = {
    features.emacs.enable = true;
  };
}
