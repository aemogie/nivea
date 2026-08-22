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
        manual.manpages.enable = false;
      }
    ];
    useUserPackages = true;
    useGlobalPkgs = true;
  };
}
