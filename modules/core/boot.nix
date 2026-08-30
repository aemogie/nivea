{
  flake.nixosModules.boot = {
    boot.loader.grub.device = "nodev";
  };
}
