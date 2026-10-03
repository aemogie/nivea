{
  lib,
  flake-parts-lib,
  inputs,
  ...
}:
{
  disabledModules = [
    (inputs.flake-parts + /modules/packages.nix)
  ];
  options.perSystem = flake-parts-lib.mkPerSystemOption (
    { pkgs, ... }: {
      options.packages = lib.mkOption {
        type = lib.types.lazyAttrsOf (
          lib.types.coercedTo (lib.types.functionTo lib.types.package) (
            f: pkgs.callPackage f { }
          ) lib.types.package
        );
      };
    }
  );

  options.flake.packages = lib.mkOption {
    type = lib.types.attrsWith {
      elemType = lib.types.lazyAttrsOf lib.types.package;
      lazy = true;
      placeholder = "system";
    };
    default = { };
    description = "packages";
  };
  config.transposition.packages = { };
}
