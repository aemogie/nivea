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
      options.emacs.systemd = lib'.mkOption {
        type = lib'.types.bool;
        default = true;
        description = "whether to run emacs daemon";
      };

      config.install = lib'.mkIf (config.emacs.enable && parentClass != "wrapper") {
        packages = [ self'.wrappedPackages.emacs ];
        systemd = lib'.mkIf config.emacs.systemd [ self'.wrappedPackages.emacs ];
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

        systemd.user.service.emacs = lib'.mkIf config.makeSystemd {
          Unit = {
            Description = config.base.meta.description;
            X-RestartIfChanged = false;
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
          };
          Install.WantedBy = [ "graphical-session.target" ];
          Service = {
            Type = "notify";
            ExecStart = "${config.wrapperPaths.placeholder} --fg-daemon";
            Restart = "on-failure";
            Slice = "session.slice";
          };
        };
      };
    };

  # standalone package
  perSystem.wrappedPackages.emacs = { pkgs, ... }: {
    base = pkgs.emacs-pgtk;
    features.emacs.enable = true;
  };
}
