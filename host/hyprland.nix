{
  pkgs,
  config,
  ...
}:
{
  programs.hyprland = {
    enable = true;
  };
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
