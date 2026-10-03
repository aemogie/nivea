{
  inputs,
  withSystem,
  lib,
  ...
}:
{
  flake.modules.features.reka =
    { self', config, ... }:
    let
      cfg = config.river;
    in
    {
      options.river.windowManager = lib.mkOption {
        type = lib.types.enum [ "reka" ];
        default = "reka";
      };
      options.river.reka.emacs = lib.mkOption {
        type = lib.types.package;
        default = self'.wrappedPackages.emacs;
        description = "default emacs package to use";
      };

      config = lib.mkIf (cfg.windowManager == "reka") {
        river.windowManagerLaunch = lib.getExe (
          cfg.reka.emacs.wrap { features.emacs.packages.reka = true; }
        );
      };
    };

  flake.modules.features.emacs-reka =
    { config, self', ... }:
    {
      options.emacs.packages.reka =
        lib.mkEnableOption "reka window manager (only. to be used alongside river compositor)";
      config = lib.mkIf config.emacs.packages.reka {
        emacs.init = ''
          (use-package reka :config (reka-enable))
        '';
        emacs.emacsPackages = emacsPackages: [
          (self'.packages.emacs-reka.override { inherit emacsPackages; })
        ];
      };
    };

  # fork of https://code.tvl.fyi/tree/tools/emacs-pkgs/reka/default.nix
  perSystem = { self', ... }: {
    packages.libreka =
      {
        pkgs,
        emacs ? pkgs.emacs-nox,
        rustPlatform,
        pkg-config,
        libxkbcommon,
      }:
      rustPlatform.buildRustPackage {
        name = "libreka";
        src = inputs.reka;
        nativeBuildInputs = [ pkg-config ];
        buildInputs = [
          emacs
          libxkbcommon
        ];
        cargoLock.lockFile = inputs.reka + /Cargo.lock;

        postInstall = ''
          mkdir -p $out/share/emacs/site-lisp
          ln -s $out/lib/libreka.so $out/share/emacs/site-lisp/libreka.so
        '';
      };
    packages.emacs-reka =
      { emacsPackages, ... }:
      emacsPackages.trivialBuild {
        pname = "reka";
        version = "0.1.0";
        src = inputs.reka + /lisp;
        packageRequires = [
          (self'.packages.libreka.override { inherit (emacsPackages) emacs; })
        ];
      };
  };
}
