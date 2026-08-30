{ lib, ... }:
{
  flake.nixosModules.serena-hardware =
    { config, ... }:
    lib.mkIf (config.networking.hostName == "serena") {
      boot.initrd.availableKernelModules = [
        "vmd"
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "sd_mod"
      ];
      boot.kernelModules = [ "kvm-intel" ];

      nixpkgs.hostPlatform = "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = true;
      hardware.enableRedistributableFirmware = true;
    };
}
