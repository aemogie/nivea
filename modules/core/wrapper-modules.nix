{
  self,
  inputs,
  flake-parts-lib,
  lib',
  ...
}:
{
  config.lib.wrappers = inputs.wrapper-modules.lib;
  options.flake.wrapperModules = lib'.mkOption {
    type = lib'.types.lazyAttrsOf lib'.types.deferredModule;
    default = { };
    description = "an unevaluated reusable wrapper module";
  };
  options.perSystem = flake-parts-lib.mkPerSystemOption (
    { pkgs, ... }: {
      options.wrappedPackages = lib'.mkOption {
        type = lib'.types.lazyAttrsOf (
          lib'.wrappers.types.subWrapperModuleWith {
            modules = (lib'.attrValues self.wrapperModules) ++ [
              lib'.wrappers.modules.default
              { inherit pkgs; }
            ];
          }
        );
        apply = lib'.mapAttrs (_: v: v.wrapper);
        default = { };
        description = "wrapped packages";
      };
    }
  );
  options.flake.wrappedPackages = lib'.mkOption {
    type = lib'.types.attrsWith {
      elemType = lib'.types.lazyAttrsOf lib'.types.package;
      lazy = true;
      placeholder = "system";
    };
    default = { };
    description = "wrapped packages";
  };
  config.transposition.wrappedPackages = { };
}
