{ config, lib, ... }:
let
  overlayOverlay = final: prev: {
    applyOverlays =
      base: exts:
      let
        exts' = final.composeManyExtensions (map final.toExtension exts);
      in
      final.fix (final.extends exts' base);
    types = prev.types // {
      overlayFor =
        base:
        final.types.mkOptionType {
          name = "overlay";
          merge =
            locs: defs:
            final.applyOverlays (final.const base) (final.options.getValues defs);
        };
    };
  };

  lib' = lib.extend overlayOverlay;
in
{
  options.lib = lib.mkOption {
    type = lib'.types.overlayFor lib;
    default = { };
  };
  config._module.args.lib' = config.lib;
  config.lib = overlayOverlay;
}
