{
  modulesPath,
  lib,
  config,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    kernelModules = ["kvm-intel"];

    initrd = {
      availableKernelModules = ["vmd" "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod"];
      kernelModules = [];
    };

    extraModulePackages = [];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };

    "/home" = {
      device = "/dev/disk/by-label/NIXHOME";
      fsType = "ext4";
    };

    "/mnt/windows" = {
      device = "/dev/disk/by-label/WINDOWS";
      fsType = "ntfs-3g";
      options = ["rw"];
    };

    "/mnt/windata" = {
      device = "/dev/disk/by-label/WINDATA";
      fsType = "ntfs-3g";
      options = ["rw"];
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-label/SWAP";}
  ];

  networking.useDHCP = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
