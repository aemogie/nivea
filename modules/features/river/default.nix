{ lib, ... }:
{
  flake.modules.features.river =
    { ... }:
    {
      options.river = {
        enable = lib.mkEnableOption "the river window manager";
        windowManager = lib.mkOption {
          type = lib.types.enum [ ];
          description = "the window manager for the river compositor";
        };
        windowManagerLaunch = lib.mkOption {
          type = lib.types.str;
          description = "the initial command launched by river";
        };
      };
    };

  flake.modules.wrapper.river =
    { config, ... }:
    let
      cfg = config.features.river;
      isRiver = lib.elem "river" config.name;
    in
    {
      config = lib.mkIf (isRiver && cfg.enable) {
        flags."-c" = cfg.windowManagerLaunch;
      };
    };

  perSystem.wrappedPackages.river = { pkgs, ... }: {
    base = pkgs.river;
    features.river.enable = true;
  };
}
