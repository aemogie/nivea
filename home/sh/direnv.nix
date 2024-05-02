{ pkgs, ... }:
{
  programs = {
    git.ignores = [ ".direnv/" ];
    direnv = {
      enable = true;
      package = pkgs.symlinkJoin {
        inherit (pkgs.direnv) meta;
        name = "direnv-nolog";
        paths = [ pkgs.direnv ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/direnv --set DIRENV_LOG_FORMAT ""
        '';
      };
      nix-direnv.enable = true;
    };
  };
}
