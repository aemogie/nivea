{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (builtins) concatMap attrValues mapAttrs;
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
  system.extraDependencies = [ (inputDrv (removeAttrs inputs [ "self" ])) ];
  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };
}
