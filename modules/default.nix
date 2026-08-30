{ lib, ... }:
let
  # thanks vimjoyer (https://github.com/Goxore/nixconf/blob/main/flake.nix)
  inherit (lib) remove;
  inherit (lib.fileset) toList fileFilter;

  isNixModule = file: file.hasExt "nix" && !lib.hasPrefix "." file.name;

  importTree = path: remove ./default.nix (toList (fileFilter isNixModule path));
in
{
  imports = importTree ./.;
}
