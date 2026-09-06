{ lib, self, ... }: {
  flake.nixosModules.aemogie-user = {
    users.users.aemogie = {
      enable = lib.mkDefault false;
      initialHashedPassword = "";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
    home-manager.users.aemogie = self.homeConfigurations.aemogie;
  };
  flake.homeConfigurations.aemogie = { config, ... }: {
    home.username = lib.mkOptionDefault "aemogie";
    home.homeDirectory = lib.mkOptionDefault "/home/${config.home.username}";
    home.wrappedPackages = wrapped: [
      wrapped.river
    ];
  };
}
