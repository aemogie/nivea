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
            class = "wrapper";
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

  config.flake.modules.wrapper.base = { config, ... }: {
    # because config.package has a builtin .apply which refers to
    # other options. makes it hard to depend on
    options.base = lib'.mkOption {
      type = lib'.types.package;
      description = "the base package unmodified";
    };
    config.package = config.base;
  };

  config.flake.modules.wrapper.services = {
    options.makeSystemd = lib'.mkOption {
      type = lib'.types.bool;
      default = false; # usually a saner default for top-level flake exports
      description = "whether to build the package for use as a systemd-service";
    };
  };
}
