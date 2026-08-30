{ lib, ... }:
{
  flake.nixosModules.serena-filesystem =
    { config, ... }:
    lib.mkIf (config.networking.hostName == "serena") {
      fileSystems = {
        "/boot" = {
          label = "serena-boot";
          fsType = "vfat";
        };
        "/" = {
          label = "serena";
          fsType = "btrfs";
          options = [ "subvol=/@nivea-root" ];
        };
        "/nix/store" = {
          label = "serena";
          fsType = "btrfs";
          options = [ "subvol=/@nivea-store" ];
        };
        "/nix/var/nix" = {
          label = "serena";
          fsType = "btrfs";
          options = [ "subvol=/@nivea-meta" ];
        };
        "/@persist" = {
          label = "serena-persist";
          fsType = "btrfs";
          mountPoint = "/@persist";
        };
      };

      swapDevices = [ ];

      virtualisation.vmVariant.virtualisation.qemu.drives = [
        {
          name = "serena-persist";
          file = ''"''$(dirname "$NIX_DISK_IMAGE")/persist.qcow2"'';
        }
      ];
    };
}
