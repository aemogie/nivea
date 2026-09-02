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
          subvol = "/@nivea-root";
          wipeOnBoot = true;
        };
        "/nix/store" = {
          label = "serena";
          fsType = "btrfs";
          subvol = "/@nivea-store";
        };
        "/nix/var/nix" = {
          label = "serena";
          fsType = "btrfs";
          subvol = "/@nivea-meta";
        };
        "/@persist" = {
          label = "serena-persist";
          fsType = "btrfs";
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
