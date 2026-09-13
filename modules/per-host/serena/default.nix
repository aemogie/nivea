{ lib, ... }: {
  flake.nixosConfigurations.serena = lib.nixosSystem {
    modules = [ { networking.hostName = "serena"; } ];
  };
  flake.modules.nixos.serena =
    { config, ... }:
    lib.mkIf (config.networking.hostName == "serena") {
      users.users.aemogie.enable = true;
    };
}
