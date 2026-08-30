{ lib, self, ... }: {
  options.flake.nixosConfigurations = lib.mkOption {
    apply = lib.mapAttrs (
      _: m:
      m.extendModules {
        modules = lib.attrValues self.nixosModules;
      }
    );
  };
  config.flake.nixosModules.default = {
    system.stateVersion = "26.05";
  };
}
