{ pkgs, ... }:
{
  documentation = {
    man.cache.enable = true;
    dev.enable = true;
    # nixos.includeAllModules = true;
    nixos.enable = false;
  };
  environment.systemPackages = [
    pkgs.man-pages
    pkgs.man-pages-posix
  ];
}
