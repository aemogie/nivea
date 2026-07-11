{ pkgs, lib, osConfig, config, ... }:
let
  wallpaper =
    if osConfig.paint.active.isDark then
      ../../assets/catppuccin-mocha-base.png
    else
      ../../assets/catppuccin-latte-flamingo.png;
in
{
  services.awww.enable = true;

  systemd.user.services.awww-reload = {
    Unit = {
      Description = "awww reload wallpaper";
      After = [ "awww.service" ];
      X-RestartIfChanged = true;
    };

    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = lib.escapeShellArgs [
        (lib.getExe config.services.awww.package)
	"img" "--transition-type" "center"
	(toString wallpaper)
      ];
      Environment = [
        "PATH=$PATH:${lib.makeBinPath [ config.services.awww.package ]}"
      ];
    };
  };  
}
