{pkgs, ...}: {
  home.packages = [pkgs.aseprite-unfree];
  wayland.windowManager.hyprland.settings.windowrulev2 = ["tile,class:Aseprite"];
  nixpkgs.config.permittedInsecurePackages = ["python-2.7.18.6"];
}
