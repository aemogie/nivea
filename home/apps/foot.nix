{
  config,
  osConfig,
  lib,
  ...
}:
let
  recursiveToString = lib.mapAttrsRecursiveCond (set: !(set ? __toString)) (_: toString);
  inherit (recursiveToString osConfig.paint.active.custom.term)
    regular
    bright
    background
    foreground
    ;
in
{
  wayland.windowManager.hyprland.settings.misc.swallow_regex = "^(foot)$";
  programs.foot = {
    enable = true;
    # breaks with login script, idk why
    # - found out why. systemd sessionvariables are seperate from login ones. ofcourse they are
    # moved enough variables to systemd sessionVariables to make this work
    server.enable = true;
    settings = {
      main =
        let
          font.name = config.fonts.monospace;
          font.size = 13;
          line-height = font.size * 1.75;
        in
        {
          font = "${font.name}:size=${toString font.size}";
          inherit line-height;
        };
      cursor.style = "beam";

      # TODO: print OSC automatically, or make a shell script that does
      # $r, $g, $b are two digit hex. 
      # echo -ne "\e]4;$idx;rgb:$r/$g/$b\e\\"
      # echo -ne "\e]10;rgb:$r/$g/$b\e\\"
      # echo -ne "\e]11;rgb:$r/$g/$b\e\\"
      colors = {
        alpha = "0.7";
        background = background;
        foreground = foreground;
        bright0 = bright.gray;
        bright1 = bright.red;
        bright2 = bright.green;
        bright3 = bright.yellow;
        bright4 = bright.blue;
        bright5 = bright.magenta;
        bright6 = bright.cyan;
        bright7 = bright.white;
        regular0 = regular.gray;
        regular1 = regular.red;
        regular2 = regular.green;
        regular3 = regular.yellow;
        regular4 = regular.blue;
        regular5 = regular.magenta;
        regular6 = regular.cyan;
        regular7 = regular.white;
        # TODO: figure out dim
      };
    };
  };
}
