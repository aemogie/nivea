{ lib, ... }: {
  flake.modules.features.documentation = {
    options.documentation.module.enable = lib.mkEnableOption "module documentation";
  };
  flake.modules.nixos.documentation = { config, ... }: {
    documentation.nixos.enable = config.features.documentation.module.enable;
  };
  flake.modules.homeManager.documentation = { config, ... }: {
    manual.manpages.enable = config.features.documentation.module.enable;
  };
}
