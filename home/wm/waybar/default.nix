{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (builtins) readFile mapAttrs;
  inherit (config.lib.paint.misc) replaceVars;
  # move to module, and replace core w more specific options else
  inherit (config.paint) core;
  bgalpha = 0.75;
in {
  imports = [./config.nix];
  programs.waybar = {
    enable = true;
    # package = pkgs.waybar.override {
    #   withMediaPlayer = true;
    # };
    # is ugly, replace
    style = replaceVars ((mapAttrs (_: v: "${toString v.r},${toString v.g},${toString v.b}") core) // {inherit bgalpha;}) (readFile ./style.css);
  };

  wayland.windowManager.hyprland.settings = {
    exec-once = [(lib.getExe config.programs.waybar.package)];
    layerrule = [
      "blur,^waybar$"
      "ignorealpha ${toString (bgalpha - 0.1)},^waybar$"
    ];
  };
}
