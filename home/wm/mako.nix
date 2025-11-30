{ osConfig, config, ... }:
let
  inherit (osConfig.paint.active.palette)
    base
    text
    primary
    alternate
    ;
in
{
  services.mako.enable = true;
  services.mako.settings = {
    background-color = "#${base}80";
    text-color = "#${text}FF";
    progress-color = "source #${alternate}80";
    font = "${config.fonts.sans} 12";
    border-radius = 5;
    border-color = "#${primary}FF";
    border-size = 2;
    padding = 10;
    margin = 10;
    outer-margin = 20; # from hyprland config. move to global option
    default-timeout = 5000;
  };
  wayland.windowManager.hyprland.settings.layerrule = [
    "blur,^notifications$"
    "ignorealpha 0.5,^notifications$"
  ];
}
