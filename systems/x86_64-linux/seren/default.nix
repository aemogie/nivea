{pkgs, ...}: {
  imports = [./hardware.nix];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = with pkgs; [
    neovim
    firefox
  ];

  system.stateVersion = "23.11";
}
