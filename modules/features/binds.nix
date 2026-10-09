{ lib, ... }: {
  flake.modules.features.binds = {
    options.binds.enable =
      lib.mkEnableOption "enable unified binding management"
      // {
        default = true;
      };
  };
}
