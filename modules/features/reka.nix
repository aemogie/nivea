{
  inputs,
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
      };
      options.river.reka.emacs = lib.mkOption {
        type = lib.types.package;
        default = self'.wrappedPackages.emacs.wrap {
          features._internal.emacs.forReka = true;
        };
        description = "default emacs package to use";
      };

      config = lib.mkIf (cfg.windowManager == "reka") {
        emacs.systemd = lib.mkDefault false;
        river.launch = lib.getExe cfg.reka.emacs;
      };
    };

  flake.modules.features.emacs-reka =
    { config, self', ... }:
    {
      options._internal.emacs.forReka = lib.mkEnableOption "build emacs to run with reka";
      config = lib.mkIf config._internal.emacs.forReka {
        emacs.systemd = lib.mkForce false;
        emacs.init = lib.mkBefore ''
          (require 'reka)
          (reka-enable)
        '';
        emacs.packages = emacsPackages: [
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

    wrappedPackages.reka = { pkgs, ... }: {
      base = pkgs.river;
      features.river = {
        enable = true;
        systemd = false;
        windowManager = "reka";
      };
    };
  };
}
