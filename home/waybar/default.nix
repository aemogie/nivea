{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) readFile;
  replaceVars =
    vars:
    lib.replaceStrings (map (k: "@${k}") (builtins.attrNames vars)) (
      map (s: "#${s}") (builtins.attrValues vars)
    );
in
{
  programs.waybar = {
    enable = true;
    settings = [ (import ./config.nix) ];
    style = replaceVars osConfig.paint.active.palette (readFile ./style.css);
    systemd.enable = true;
  };

  # uwsm
  systemd.user.services.waybar.Service.Slice = "background-graphical.slice";
}
