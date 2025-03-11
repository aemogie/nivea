{ pkgs, osConfig, ... }:
let
  wallpaper =
    if osConfig.paint.active.isDark then
      ../../assets/catppuccin-mocha-base.png
    else
      ../../assets/catppuccin-latte-flamingo.png;
in
{
  wayland.windowManager.hyprland.settings = {
    exec-once = [ "${pkgs.swww}/bin/swww-daemon" ];
    exec = [
      "${pkgs.writeShellScript "swww-switch" ''
        ${pkgs.swww}/bin/swww img --transition-type center ${wallpaper}
      ''}"
    ];
  };
}
