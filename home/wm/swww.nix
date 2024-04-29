{
  pkgs,
  osConfig,
  ...
}: let
  wallpaper =
    if osConfig.paint.active.isDark
    then ../../assets/catppuccin-wip.png
    else ../../assets/catppuccino-pink.png;
in {
  wayland.windowManager.hyprland.settings.exec-once = ["${pkgs.swww}/bin/swww-daemon"];
  home.activation.swww = {
    before = [];
    after = [];
    data = ''
      ${pkgs.procps}/bin/pgrep -f swww-daemon \
      && ${pkgs.swww}/bin/swww img --transition-type center ${wallpaper} \
      || true
    '';
  };
}
