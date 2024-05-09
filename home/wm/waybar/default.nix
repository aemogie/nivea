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
    package = pkgs.waybar.override {
      swaySupport = false;
      hyprland = config.wayland.windowManager.hyprland.finalPackage;
    };
    settings = [ (import ./config.nix) ];
    style = replaceVars osConfig.paint.active.palette (readFile ./style.css);
  };

  wayland.windowManager.hyprland.settings = {
    exec-once = [ (lib.getExe config.programs.waybar.package) ];
  };
}
