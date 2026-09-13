{
  flake.modules.nixos.boot = {
    boot.loader.grub.device = "nodev";
  };
}
