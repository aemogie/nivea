{ lib, self, ... }: {
  flake.modules.generic.features =
    {
      options,
      config,
      _class,
      ...
    }@attrs:
    lib.optionalAttrs (_class != "features") {
      options.features = lib.mkOption {
        type = lib.types.submoduleWith {
          class = "features";
          specialArgs =
            (removeAttrs (config._module.args // attrs) [
              "options"
              "config"
              "_class"
              "lib"
            ])
            // {
              parentClass = _class;
            };
          modules = lib.concatLists [
            (lib.attrValues self.modules.generic)
            (lib.attrValues self.modules.features)
          ];
        };
        default = { };
        description = "a feature system";
      };
      options.featuresThunked = lib.mkOption {
        type = lib.types.deferredModule;
        readOnly = true;
        default = lib.types.deferredModule.merge options.features.loc options.features.definitionsWithLocations;
        description = "thunked feature definitions (for inheritance)";
      };
    };

  flake.modules.generic.wrappers =
    { config, _class, ... }:
    lib.optionalAttrs (_class != "features") {
      module.args.self' = lib.mkAfter (
        final: prev: {
          wrappedPackages = lib.mapAttrs (
            _: base: base.wrap { config.features = _: config.featuresThunked; }
          ) prev.wrappedPackages;
        }
      );
    };

  flake.modules.nixos.hmInheritsOS = { config, ... }: {
    home-manager.sharedModules = [
      { config.features = _: config.featuresThunked; }
    ];
  };
}
