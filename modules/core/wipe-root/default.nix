{ lib, ... }: {
  flake.nixosModules.wipe-root =
    { config, utils, ... }:
    let
      fsOption = { config, ... }: {
        options.wipeOnBoot = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "wipe partition on boot";
        };
        config = lib.mkIf config.wipeOnBoot {
          device = lib.mkOptionDefault "none";
          fsType = lib.mkOptionDefault "tmpfs";
        };
      };
      btrfsAssert =
        { config, ... }:
        lib.mkIf (
          if
            config.wipeOnBoot
            && config.fsType == "btrfs"
            && config.subvol == null
            && lib.none (lib.hasPrefix "subvol=") config.options
          then
            throw "wipeOnBoot btrfs filesystem needs a subvolume: ${config.device}"
          else
            true
        ) { };
    in
    {
      options.fileSystems = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule [
            fsOption
            btrfsAssert
          ]
        );
      };
      config =
        let
          btrfsMounts = lib.filterAttrs (
            _: fs: fs.wipeOnBoot && fs.fsType == "btrfs" && fs.subvol != null
          ) config.fileSystems;
          btrfsMounts2 = lib.filterAttrs (
            _: fs:
            fs.wipeOnBoot
            && fs.fsType == "btrfs"
            && fs.subvol == null
            && lib.any (lib.hasPrefix "subvol=") fs.options
          ) config.fileSystems;
        in
        {
          boot.initrd.systemd.services = lib.mapAttrs' (
            _: fs:
            let
              inherit (fs) device;
              devSafe = utils.escapeSystemdPath fs.device;
              subvol = lib.removePrefix "/" (
                if fs.subvol != null then
                  fs.subvol
                else
                  lib.removePrefix "subvol=" (lib.findFirst (lib.hasPrefix "subvol=") fs.options)
              );
              subvolSafe = utils.escapeSystemdPath subvol;
            in
            {
              name = "btrfs-wipe-${devSafe}-${subvolSafe}";
              value = {
                description = "Wipe BTRFS subvol ${subvol} for ${device}";
                requiredBy = [ "initrd.target" ];
                before = [ "sysroot.mount" ];
                requires = [ "${devSafe}.device" ];
                after = [
                  "${devSafe}.device"
                  "local-fs-pre.target"
                ];
                unitConfig.DefaultDependencies = false;
                serviceConfig.Type = "oneshot";
                serviceConfig.ExecStart = "${./btrfs_snapshot.sh} ${device} ${subvol}";
              };
            }
          ) (btrfsMounts // btrfsMounts2);
          boot.initrd.systemd.storePaths = [ { source = ./btrfs_snapshot.sh; } ];
        };
    };
}
