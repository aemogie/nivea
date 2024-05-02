{ inputs, pkgs, ... }:
let
  src = pkgs.fetchFromGitHub {
    owner = "nushell";
    repo = "tree-sitter-nu";
    rev = "d89ac1a6e9163902767ef3e53802498630b153b8";
    sha256 = "sha256-xBlPXEUnzJfTZmjVCBLwBS0SKjY0K/yd2+3gHTQn7qY=";
  };
  build_grammar =
    pkgs.callPackage "${inputs.nixpkgs}/pkgs/development/tools/parsing/tree-sitter/grammar.nix"
      { };
  tree-sitter-nu = build_grammar {
    inherit src;
    language = "nu";
    version = "0";
    generate = false;
  };
in
{
  xdg.configFile = {
    "helix/runtime/queries/nu" = {
      source = "${tree-sitter-nu}/queries";
      recursive = true;
    };
    "helix/runtime/grammars/nu.so".source = "${tree-sitter-nu}/parser";
  };

  programs.helix.languages.grammar = [ { name = "nu"; } ];
}
