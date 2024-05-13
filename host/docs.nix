{ pkgs, ... }:
{
  documentation = {
    man.generateCaches = true;
    dev.enable = true;
    # nixos.includeAllModules = true;
  };
  environment.systemPackages = [
    pkgs.man-pages
    pkgs.man-pages-posix
  ];
}
