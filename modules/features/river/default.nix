{ lib, ... }:
{
  flake.wrapperModules.river =
    {
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.features.river;
    in
    {
      options.features.river = {
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

      config = lib.mkIf cfg.enable {
        package = pkgs.river;
        flags."-c" = cfg.windowManagerLaunch;
      };
    };

  perSystem.wrappedPackages.river = {
    features.river.enable = true;
  };
}
