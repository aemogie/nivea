{
  pkgs,
  config,
  ...
}:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
}
