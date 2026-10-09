{ lib, ... }:
let
  genElisp =
    f: lib.concatMapAttrsStringSep "\n" (k: v: if k == "!" then v else f k v);
in
{
  flake.modules.features.emacs-keymaps =
    let
      setKey =
        keymap: key: definition:
        "(keymap-set ${keymap} \"${key}\" ${definition})";
      flattenKeymap = keymap: keys: genElisp (setKey keymap) keys;
    in
    { config, ... }: {
      options.emacs.keymaps = lib.mkOption {
        # KEYMAP -> KEY -> ELISP DEFINITION
        type = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf lib.types.lines);
        default = { };
        description = "the bindings to be used within emacs";
      };
      config.emacs.init = lib.mkIf config.binds.enable (
        genElisp flattenKeymap config.emacs.keymaps
      );
    };

  flake.modules.features.emacs-setopt = { config, ... }: {
    options.emacs.setopt = lib.mkOption {
      # VARIABLE -> ELISP VALUE
      type = lib.types.lazyAttrsOf lib.types.lines;
      default = { };
      description = "the options to be set within emacs";
    };
    config.emacs.init = genElisp (
      var: val: "(setopt ${var} ${val})"
    ) config.emacs.setopt;
  };
}
