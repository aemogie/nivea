{
  inputs,
  lib,
  self,
  ...
}:
{
  options.flake.homeConfigurations = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    apply = lib.mapAttrs (
      _: m: {
        imports = lib.concatLists [
          (lib.attrValues self.modules.generic or { })
          (lib.attrValues self.modules.homeManager or { })
          [ m ]
        ];
      }
    );
  };

  config.flake.modules.homeManager.default = {
    home.stateVersion = "26.05";
  };

  # add it into nixos auto-imports
  config.flake.modules.nixos.home-manager =
    inputs.home-manager.nixosModules.home-manager;
  config.flake.modules.nixos.home-manager-defaults = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}
