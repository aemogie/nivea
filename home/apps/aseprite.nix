{
  pkgs,
  osConfig,
  lib,
  ...
}:
let
  inherit (lib) concatLines concatMapAttrs;
  inherit (builtins) attrValues mapAttrs;
in
{
  home.packages = [ pkgs.aseprite-unfree ];
  wayland.windowManager.hyprland.settings.windowrulev2 = [ "tile,class:Aseprite" ];
  nixpkgs.config.permittedInsecurePackages = [ "python-2.7.18.6" ];
  xdg.configFile =
    let
      gplHeader = name: ''
        GIMP Palette
        Channels: RGBA
        #Name: ${name}
        0   0   0   0 transparent
      '';
      gplBody =
        { generationOrder, palette, ... }:
        concatLines (
          map (
            name:
            let
              c = palette.${name};
            in
            "${toString c.r} ${toString c.g} ${toString c.b} 255 ${name}"
          ) generationOrder
        );
    in
    lib.concatMapAttrs (name: scheme: {
      "aseprite/palettes/${name}.gpl".text = (gplHeader name) + (gplBody scheme);
    }) osConfig.paint.schemes;
}
