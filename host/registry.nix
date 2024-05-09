{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (builtins) concatMap attrValues;
  inherit (lib) concatLines mapAttrsToList;

  # thanks github:tejing1/nixos-config
  collectFlakeInputs =
    {
      inputs ? { },
      outPath,
      ...
    }:
    [ outPath ] ++ concatMap collectFlakeInputs (attrValues inputs);
  cmd = name: input: ''
    cat <<EOF > $out/${name}-inputs
    ${concatLines (collectFlakeInputs input)}
    EOF
  '';
  inputDrv =
    inputs:
    pkgs.runCommand "flake-inputs" { } ''
      mkdir $out
      ${concatLines (mapAttrsToList cmd inputs)}
    '';
in
{
  # add all inputs to closure, to avoid garbage collection
  system.extraDependencies = [ (inputDrv (removeAttrs inputs [ "self" ])) ];

  nix.registry = {
    n.flake = inputs.nixpkgs;
    home-manager.flake = inputs.home-manager;
  };
}
