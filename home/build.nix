name: path:
{
  lib,
  config,
  options,
  ...
}:
{
  config = {
    users.users.${name} = {
      isNormalUser = true;
      description = "${name}";
      initialPassword = "password";
      extraGroups = [
        "networkmanager"
        "wheel"
        "adbusers"
      ];
    };

    home-manager.users.${name} = {
      imports = [ path ];
      config = {
        nixpkgs.config.allowUnfree = true;

        home = {
          username = name;
          homeDirectory = "/home/${name}";
        };

        systemd.user.startServices = "sd-switch";

        home = {
          inherit (config.system) stateVersion;
        };
      };
    };
  };
}
