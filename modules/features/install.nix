{ lib, ... }: {
  flake.modules.features.install = { ... }: {
    options.install = {
      enable = lib.mkEnableOption "installing packages through features" // {
        default = true;
      };
      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        apply = map (p: if p ? wrap then p.wrap { makeSystemd = false; } else p);
        default = [ ];
        description = "list of packages to be installed";
      };
      systemd = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        apply = map (p: if p ? wrap then p.wrap { makeSystemd = true; } else p);
        default = [ ];
        description = "list of packages providing services to be installed";
      };
    };
  };

  # packages
  flake.modules.homeManager.packages =
    { config, ... }:
    lib.mkIf config.features.install.enable {
      home.packages = config.features.install.packages;
      systemd.user.packages = config.features.install.systemd;
    };
  flake.modules.nixos.packages =
    { config, ... }:
    lib.mkIf config.features.install.enable {
      environment.systemPackages = config.features.install.packages;
      systemd.packages = config.features.install.systemd;
    };
  flake.modules.wrappers.packages =
    { config, ... }:
    lib.mkIf config.features.install.enable {
      runtimePkgs = config.features.install.packages;
    };
}
