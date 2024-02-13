{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) toJSON;
  inherit (lib) mkDefault mkOption mkIf;
  inherit (lib.types) attrs;
  cfg = config.programs.discord;
  pkg = pkgs.discord.override {withOpenASAR = true;};
in {
  options.programs.discord.openasar.config = mkOption {
    type = attrs;
    description = "Configuration for OpenASAR (if it is selected).";
    default = {
      SKIP_HOST_UPDATE = true;
      openasar = {
        # I don't wanna check the actual defaults.
        setup = true;
        quickstart = true;
        cmdPreset = "battery";
        css = cfg.style; # this is here, cz i wanna make it overridable or smth.
      };
    };
  };
  config = mkIf (cfg.enable && cfg.client == "openasar") {
    xdg.configFile."discord/settings.json".text = toJSON cfg.openasar.config;
    programs.discord.launch_command = mkDefault "${pkg}/bin/Discord";
    home.packages = [pkg];
  };
}
