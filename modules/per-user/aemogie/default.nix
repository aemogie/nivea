{ lib, ... }: {
  flake.nixosModules.aemogie-user = {
    users.users.aemogie = {
      enable = lib.mkDefault false;
      initialHashedPassword = "";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
  # this depends on above, so can't be in the same module
  flake.nixosModules.aemogie-config =
    { config, ... }:
    lib.mkIf config.users.users.aemogie.enable {
      # rest
    };
}
