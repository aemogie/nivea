{
  self,
  inputs,
  flake-parts-lib,
  lib',
  ...
}:
{
  config.lib.wrappers = inputs.wrapper-modules.lib;
  options.perSystem = flake-parts-lib.mkPerSystemOption (
    { pkgs, ... }: {
      options.wrappedPackages = lib'.mkOption {
        type = lib'.types.lazyAttrsOf (
          lib'.wrappers.types.subWrapperModuleWith {
            modules = lib'.concatLists [
              (lib'.attrValues self.modules.generic or { })
              (lib'.attrValues self.modules.wrapper or { })
              [
                lib'.wrappers.modules.default
                lib'.wrappers.modules.systemd
                { inherit pkgs; }
              ]
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
