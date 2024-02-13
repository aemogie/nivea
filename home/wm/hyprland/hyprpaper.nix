{
  pkgs,
  lib,
  ...
}: let
  wallpaper = ../../../assets/home.png;
in {
  wayland.windowManager.hyprland.settings.exec-once = [(lib.getExe pkgs.hyprpaper)];
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload=${wallpaper}
    wallpaper=,${wallpaper}
  '';
}
