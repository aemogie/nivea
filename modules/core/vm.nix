{
  flake.nixosModules.vm = { config, ... }: {
    virtualisation.vmVariant = {
      virtualisation = {
        useDefaultFilesystems = false;
        fileSystems = removeAttrs config.fileSystems [ "/nix/store" ];
        mountHostNixStore = true;
      };
      boot.initrd.systemd.emergencyAccess = true;
      systemd.enableEmergencyMode = true;
    };
  };
}
