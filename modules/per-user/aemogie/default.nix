{ lib, self, ... }: {
  flake.modules.nixos.aemogie-user = {
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

    features.river.enable = true;
    features.emacs.enable = true;
    features.emacs.init = ''(message "hello from %s" "${toString ./.}")'';
  };
}
