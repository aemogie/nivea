{
  pkgs,
  inputs,
  config,
  ...
}:
{
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  home-manager.sharedModules = [
    { wayland.windowManager.hyprland.package = config.programs.hyprland.finalPackage; }
  ];
}
