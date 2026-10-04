{ lib, inputs, ... }:
{
  flake.modules.features.river =
    {
      config,
      self',
      parentClass,
      ...
    }:
    {
      options.river = {
        enable = lib.mkEnableOption "river the non-monolithic wayland compositor";
        windowManager = lib.mkOption {
          type = lib.types.enum [ ];
          description = "the window manager for the river compositor";
        };
        systemd = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "whether to use systemd-managed river";
        };
        launch = lib.mkOption {
          type = lib.types.str;
          description = "the initial command launched by river";
        };
      };
      config.install = lib.mkIf (config.river.enable && parentClass != "wrapper") {
        packages = lib.mkIf (!config.river.systemd) [ self'.wrappedPackages.river ];
        systemd = lib.mkIf config.river.systemd [ self'.wrappedPackages.river ];
      };
    };

  flake.modules.wrapper.river =
    { config, pkgs, ... }:
    let
      cfg = config.features.river;
      isRiver = lib.elem "river" config.name;
      systemd-start = pkgs.writeShellApplication {
        name = "update-systemd";
        runtimeInputs = [ pkgs.systemd ];
        text = ''
          systemctl --user import-environment WAYLAND_DISPLAY DISPLAY
          systemd-notify --ready
        '';
      };
      systemd-stop = pkgs.writeShellApplication {
        name = "reset-systemd";
        runtimeInputs = [ pkgs.systemd ];
        text = ''
          systemctl --user unset-environment WAYLAND_DISPLAY DISPLAY
        '';
      };
    in
    {
      config = lib.mkIf (isRiver && cfg.enable) {
        flags."-c" =
          if config.makeSystemd then lib.getExe systemd-start else cfg.launch;
        # ref: https://devork.be/blog/2025/07/river-as-systemd/
        systemd.user.service.river = lib.mkIf config.makeSystemd {
          Unit = {
            Description = config.base.meta.description;
            BindsTo = [ "graphical-session.target" ];
            PropagatesStopTo = [ "graphical-session.target" ];
            Before = [ "graphical-session.target" ];
          };
          Service = {
            Type = "notify"; # we run systemd-notify in the launch script
            NotifyAccess = "all";
            ExecStart = config.wrapperPaths.placeholder;
            Restart = "on-failure";
            RestartSec = 2;
            ExecStopPost = lib.getExe systemd-stop;
            Slice = "session.slice";
          };
        };
        systemd.user.service.${cfg.windowManager} = lib.mkIf config.makeSystemd {
          Unit = {
            After = [ "river.service" ];
            BindsTo = [ "river.service" ];
            PropagatesStopTo = [ "river.service" ];
          };
          Install.WantedBy = [ "river.service" ];
          Service = {
            Type = "oneshot";
            ExecStart = cfg.launch;
            RemainAfterExit = true;
            Slice = "session.slice";
          };
        };
      };
    };

  perSystem.packages.tinyrwm =
    {
      stdenv,
      meson,
      ninja,
      wayland,
      libxkbcommon,
      pkg-config,
      wayland-scanner,
    }:
    stdenv.mkDerivation {
      name = "tinyrwm";
      src = inputs.tinyrwm + /c;
      nativeBuildInputs = [
        meson
        ninja
        pkg-config
        wayland-scanner
      ];
      buildInputs = [
        wayland
        libxkbcommon
      ];
      meta.mainProgram = "tinyrwm";
    };

  flake.modules.features.tinyrwm = { config, self', ... }: {
    options.river.windowManager = lib.mkOption {
      type = lib.types.enum [ "tinyrwm" ];
      default = "tinyrwm";
    };

    config = lib.mkIf (config.river.windowManager == "tinyrwm") {
      river.launch = lib.getExe self'.packages.tinyrwm;
    };
  };

  perSystem.wrappedPackages.river = { pkgs, ... }: {
    base = pkgs.river;
    features.river.enable = true;
  };
}
