{ pkgs, osConfig, ... }:
let
  wallpaper =
    if osConfig.paint.active.isDark then
      ../../assets/catppuccin-mocha-base.png
    else
      ../../assets/catppuccin-latte-flamingo.png;
  command =
    let
      name = "swww-init-or-update";
      run = pkgs.writeShellApplication {
        inherit name;
        runtimeInputs = [ pkgs.swww ];
        text = ''
          swww query || swww init && swww img --transition-type center ${wallpaper}
        '';
      };
    in
    "${run}/bin/${name}";
in
{
  wayland.windowManager.hyprland.settings.exec-once = [ command ];
  home.activation.swww = {
    before = [ ];
    after = [ ];
    data = command;
  };
}
