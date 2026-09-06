{
  inputs,
  lib,
  self,
  ...
}:
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  options.flake.homeConfigurations = lib.mkOption {
    apply = lib.mapAttrs (
      _: m: {
        imports = [ m ] ++ (lib.attrValues self.homeModules);
      }
    );
  };
  config.flake.homeModules.default = {
    home.stateVersion = "26.05";
  };
  config.flake.nixosModules.home-manager = inputs.home-manager.nixosModules.home-manager;
  config.flake.nixosModules.home-manager-defaults = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}
