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
    exec-once = [ "${pkgs.awww}/bin/awww-daemon" ];
    exec = [
      "${pkgs.writeShellScript "awww-switch" ''
        ${pkgs.awww}/bin/awww img --transition-type center ${wallpaper}
      ''}"
    ];
  };
}
