{ lib', withSystem, ... }:
{
  config.flake.modules.generic.args = { config, ... }: {
    options.module.args = lib'.mkOption {
      type = lib'.types.lazyAttrsOf (lib'.types.overlayFor { });
      default = { };
    };
    config._module.args = config.module.args;
  };
  config.flake.modules.generic.self' =
    { pkgs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system or null;
    in
    {
      module.args.self' = lib'.mkIf (system != null) (
        withSystem system (args: args.self')
      );
    };
}
