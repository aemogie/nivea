{
  config,
  options,
  lib,
  pkgs,
  ...
}:
{
  imports = [ (import ./build.nix "aemogie" ./aemogie.nix) ];
  home-manager = {
    sharedModules = [
      {
        programs = {
          bash.enable = true; # for the env vars
          git.enable = true;
        };
        xdg = {
          enable = true;
          userDirs = {
            enable = true;
            createDirectories = true;
          };
        };
        home.packages = [
          pkgs.xdg-utils
          pkgs.xdg-user-dirs
        ];
      }
    ];
    useUserPackages = true;
    useGlobalPkgs = true;
  };
}
