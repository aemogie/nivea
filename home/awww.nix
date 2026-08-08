{
  pkgs,
  lib,
  osConfig,
  config,
  ...
}:
let
  wallpaper =
    if osConfig.paint.active.isDark then
      ../assets/catppuccin-mocha-base.png
    else
      ../assets/catppuccin-latte-flamingo.png;
in
{
  services.awww.enable = true;

  # uwsm
  systemd.user.services.awww.Service = {
    Type = "notify"; # awww-daemon supports it: daemon/src/systemd.rs
    Slice = "background-graphical.slice";
  };
  systemd.user.services.awww-reload = {
    Unit = {
      Description = "awww reload wallpaper";
      Requires = [ "awww.service" ];
      After = [ "awww.service" ];
      X-RestartIfChanged = true;
    };
    # some ordering issue here
    Install.WantedBy = [ "awww.service" ];

    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = lib.escapeShellArgs [
        (lib.getExe config.services.awww.package)
        "img"
        "--transition-type"
        "center"
        "${wallpaper}"
      ];
    };
  };
}
