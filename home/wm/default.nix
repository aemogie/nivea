{ pkgs, ... }:
{
  imports = [
    ./hyprland
    ./awww.nix
    ./mako.nix
    ./swaylock.nix
  ];

  home = {
    packages = [
      pkgs.wl-clipboard # wl-copy/wl-paste
      pkgs.xdg-utils
      pkgs.xdg-user-dirs
    ];
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
    };
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
