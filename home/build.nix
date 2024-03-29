name: path: {
  lib,
  config,
  options,
  ...
}: {
  config = {
    users.users.${name} = {
      isNormalUser = true;
      description = "${name}";
      initialPassword = "password";
      extraGroups = ["networkmanager" "wheel" "adbusers"];
      shell = config.home-manager.users.${name}.home.loginShell.package;
    };

    home-manager.users.${name} = {
      imports = [path];
      options.home.loginShell = {
        package = (options.users.users.type.getSubOptions []).shell;
        args = lib.mkOption {
          type = with lib.types; listOf str;
          default = ["-c"];
          description = "Arguments to the login shell, so that the next argument is evaluated.";
        };
        cmd = lib.mkOption {
          type = with lib.types; listOf str;
          readOnly = true;
          default = with config.home-manager.users.${name}.home.loginShell;
            ["${package}${package.shellPath}"] ++ args;
        };
      };
      config = {
        nixpkgs.config.allowUnfree = true;

        home = {
          username = name;
          homeDirectory = "/home/${name}";
        };

        systemd.user.startServices = "sd-switch";

        home = {inherit (config.system) stateVersion;};
      };
    };
  };
}
