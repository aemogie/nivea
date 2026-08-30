{ lib, ... }: {
  flake.nixosConfigurations.serena = lib.nixosSystem {
    modules = [ { networking.hostName = "serena"; } ];
  };
  flake.nixosModules.serena =
    { config, ... }:
    lib.mkIf (config.networking.hostName == "serena") {
      # TODO: serena-specific tweaks
    };
}
