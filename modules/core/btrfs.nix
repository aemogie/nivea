{ lib, ... }:
let
  module = { config, ... }: {
    options.subvol = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "the btrfs subvolume to mount";
    };
    config.options = lib.mkIf (config.fsType == "btrfs" && config.subvol != null) [
      "subvol=${config.subvol}"
    ];
  };
in
{
  flake.nixosModules.btrfs = {
    options.fileSystems = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule [ module ]);
    };
  };
}
