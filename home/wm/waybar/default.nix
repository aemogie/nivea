{
  config,
  osConfig,
  lib,
  ...
}: let
  inherit (builtins) readFile;
  replaceVars = vars: lib.replaceStrings (map (k: "@${k}@") (builtins.attrNames vars)) (map toString (builtins.attrValues vars));
in {
  imports = [./config.nix];
  programs.waybar = {
    enable = true;
    style = replaceVars osConfig.paint.active.palette (readFile ./style.css);
  };

  wayland.windowManager.hyprland.settings = {
    exec-once = [(lib.getExe config.programs.waybar.package)];
  };
}
