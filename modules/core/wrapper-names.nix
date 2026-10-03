{ lib, ... }: {
  flake.modules.wrapper.names = { config, ... }: {
    options.name = lib.mkOption {
      type = lib.types.listOf (lib.types.nullOr lib.types.str);
      apply = lib.remove null;
      description = "list of names for the current package";
    };
    config.name = [
      (config.base.pname or null)
      (config.base.name or null)
      (config.base.meta.mainProgram or null)
    ];
  };
}
