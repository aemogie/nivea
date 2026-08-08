{
  pkgs,
  config,
  osConfig,
  lib,
  ...
}:
let
  recursiveToString = lib.mapAttrsRecursiveCond (set: !(set ? __toString)) (
    _: toString
  );
  makeColorScheme =
    {
      regular,
      bright,
      background,
      foreground,
      ...
    }:
    {
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
in
{
  programs.foot = {
    enable = true;
    settings =
      let
        font.name = config.fonts.monospace;
        font.size = 13;
        darkScheme = recursiveToString osConfig.paint.dark.custom.term;
        lightScheme = recursiveToString osConfig.paint.light.custom.term;
      in
      {
        main.font = "${font.name}:size=${toString font.size}";
        main.line-height = font.size * 1.75;

        cursor.style = "beam";

        colors-dark = makeColorScheme darkScheme;
        colors-light = makeColorScheme lightScheme;
        main.initial-color-theme =
          if osConfig.paint.active.isDark then "dark" else "light";
      };
  };

  systemd.user.services.foot-reload =
    let
      root =
        if config.programs.foot.server.enable then
          [ "foot.service" ]
        else
          [ config.wayland.systemd.target ];
    in
    {
      Unit = {
        Description = "foot reload colorscheme";
        Requires = root;
        After = root;
        X-RestartIfChanged = true;
      };
      Install.WantedBy = root;

      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = lib.escapeShellArgs [
          (lib.getExe' pkgs.procps "pkill")
          "-xHf"
          "/nix/store/[^-]+-foot-[0-9\\.]+/bin/foot"
          (if osConfig.paint.active.isDark then "-USR1" else "-USR2")
        ];
      };
    };
}
