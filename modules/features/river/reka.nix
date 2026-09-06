{
  inputs,
  withSystem,
  lib,
  ...
}:
{
  flake.wrapperModules.river =
    { self', config, ... }:
    let
      cfg = config.features.river;
    in
    {
      options.features.river.windowManager = lib.mkOption {
        type = lib.types.enum [ "reka" ];
        default = "reka";
      };
      options.features.river.reka.emacs = lib.mkOption {
        type = lib.types.package;
        default = self'.wrappedPackages.emacs;
        description = "default emacs package to use";
      };
      config = lib.mkIf (cfg.windowManager == "reka") {
        features.river.windowManagerLaunch = lib.getExe (
          cfg.reka.emacs.wrap { features.emacs.packages.reka = true; }
        );
      };
    };

  flake.wrapperModules.emacs-reka =
    {
      pkgs,
      config,
      ...
    }:
    let
      # fork of https://code.tvl.fyi/tree/tools/emacs-pkgs/reka/default.nix
      libreka =
        epkgs:
        pkgs.rustPlatform.buildRustPackage {
          name = "libreka";
          src = inputs.reka;
          nativeBuildInputs = [ pkgs.pkg-config ];
          buildInputs = [
            epkgs.emacs
            pkgs.libxkbcommon
          ];
          cargoLock.lockFile = inputs.reka + /Cargo.lock;

          postInstall = ''
            mkdir -p $out/share/emacs/site-lisp
            ln -s $out/lib/libreka.so $out/share/emacs/site-lisp/libreka.so
          '';
        };
      reka-el =
        epkgs:
        epkgs.trivialBuild {
          pname = "reka";
          version = "0.1.0";
          src = inputs.reka + /lisp;
          packageRequires = [ (libreka epkgs) ];
        };
    in
    {
      options.features.emacs.packages.reka =
        lib.mkEnableOption "reka window manager (only. to be used alongside river compositor)";
      config = lib.mkIf config.features.emacs.packages.reka {
        features.emacs.init = ''
          (use-package reka :config (reka-enable))
        '';
        features.emacs.emacsPackages = epkgs: [ (reka-el epkgs) ];
      };
    };
}
