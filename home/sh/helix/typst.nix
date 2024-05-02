{
  inputs,
  pkgs,
  config,
  ...
}:
/*
  let
    src = pkgs.fetchFromGitHub {
      owner = "frozolotl";
      repo = "tree-sitter-typst";
      rev = "04462e79b46e0b502597f97cb7aa8e34653ce237";
      sha256 = "sha256-SFp1Kzg1A63Xv5jG7y1A1qljnIbKHxMrWOCJINECTxg=";
    };
    build_grammar = pkgs.callPackage "${inputs.nixpkgs}/pkgs/development/tools/parsing/tree-sitter/grammar.nix" {};
    tree-sitter-typst = build_grammar {
      inherit src;
      language = "typst";
      version = "0";
      generate = false;
    };
  in
*/
{
  home = {
    packages = [ pkgs.typst ];
    sessionVariables = {
      TYPST_FONT_PATHS = pkgs.symlinkJoin {
        name = "typst-ready-fonts";
        paths = config.fonts.packages;
      };
    };
  };
  /*
    xdg.configFile = {
      "helix/runtime/queries/typst" = {
        source = "${tree-sitter-typst}/queries";
        recursive = true;
      };
      "helix/runtime/grammars/typst.so".source = "${tree-sitter-typst}/parser";
    };
     no need for `source` since, we link it directly above.
    programs.helix.languages = {
      language-server.typst-lsp = {
        command = "typst-lsp"; # "${pkgs.typst-lsp}/bin/typst-lsp";
        # TODO: debug this, lsp breaks fsr
        config = {
          exportPdf = "never";
        };
      };
      grammar = [{name = "typst";}];
      language = [
        {
          name = "typst";
          scope = "source.typ";
          roots = [];
          injection-regex = "^typ(st)?$";
          language-servers = ["typst-lsp"];
          file-types = ["typst" "typ"];
          comment-token = "//";
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }
      ];
    };
  */

  programs.helix.languages = {
    language = [
      {
        name = "typst";
        language-servers = [ "tinymist" ];
      }
    ];
    language-server.tinymist.command = "tinymist";
  };
}
