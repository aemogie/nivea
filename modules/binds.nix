{ lib, ... }@args:
{
  options.binds = {
    layouts = lib.mkOption {
      # action = key, not the other way around
      type = lib.types.attrsOf lib.types.anything;
      default = {
        move = {
          left = "h";
          down = "j";
          up = "k";
          right = "l";
        };
        simple = {
          copy = "y";
          paste = "p";
          delete = "d";
          change = "c";
        };
        wm.mod = "super";
      };
    };
  };

  # if we're an hm module in nixos, just inherit the nixos ones
  config.binds = lib.mkIf (args ? osConfig) args.osConfig.binds;
}
