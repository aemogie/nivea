{ lib, self, ... }: {
  options.flake.nixosConfigurations = lib.mkOption {
    apply = lib.mapAttrs (
      _: m:
      m.extendModules {
        modules = lib.concatLists [
          (lib.attrValues self.modules.generic or { })
          (lib.attrValues self.modules.nixos or { })
        ];
      }
    );
  };

  config.flake.modules.nixos.default = {
    system.stateVersion = "26.05";
    nix.settings.experimental-features = "nix-command flakes";
  };
}
