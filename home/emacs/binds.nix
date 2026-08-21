{ lib', ... }:
let
  inherit (lib'.elisp)
    call
    var
    sym
    if'
    fnref
    sane-alist-cons
    ;
  call-interactively = fn: call "call-interactively" (fnref fn);
in
{
  programs.emacs.use-package.meow.enable = true;
  programs.emacs.use-package.meow.custom = {
    meow-use-clipboard = true;
    meow-expand-hint-counts = sane-alist-cons {
      word = 0;
      line = 0;
      block = 0;
      find = 0;
      till = 0;
    };
    meow-global-mode = 1;
  };

  programs.emacs.use-package.meow.bind.meow-normal-state-keymap = {
    # motion cluster
    "n" = "meow-back-word";
    "e" = "meow-next";
    "i" = "meow-prev";
    "a" = "meow-next-word";

    # insert in various ways (shift + motion;
    "N" = "meow-insert";
    "E" = "meow-open-below";
    "I" = "meow-open-above";
    "A" = "meow-append";
    "F" = "meow-change";

    # undo
    "u" = "meow-undo";
    "U" = "meow-undo-in-selection";

    # mutation cluster
    "c" = "meow-yank";
    "C" = "meow-replace";
    "r" = "meow-block"; # replaced with expreg below
    "s" = "meow-line";
    "t" = "meow-kill";
    "y" = "meow-save";

    "g" = "keyboard-quit";
    "<escape>" = "keyboard-quit";

    # search
    "h" = "meow-visit";
    "d" = "meow-search";

    # rare
    "G" = "meow-grab";
    "k" = "meow-till";
    "x" = "meow-join";
  };

  programs.emacs.use-package.meow.bind.meow-motion-state-keymap = {
    "e" = "meow-next";
    "i" = "meow-prev";

    "h" = "meow-visit";
    "d" = "meow-search";

    "<escape>" = "keyboard-quit";
  };
  programs.emacs.use-package.meow.bind.mode-specific-map = {
    # very frequent
    "<SPC>" = "save-buffer";
    "e" = "other-window";
    "E" = "delete-window";

    "t" =
      if' (call "eq" (var "major-mode") (sym "erc-mode"))
        (call-interactively "erc-switch-to-buffer")
        (
          if' (call "project-current" false)
            (call-interactively "project-switch-to-buffer")
            (call-interactively "switch-to-buffer")
        );
    "T" = "switch-to-buffer";

    "s" =
      if' (call "project-current" false) (call-interactively "project-find-file")
        (call-interactively "find-file");
    "S" = "find-file";

    "r" = "kill-buffer";
    "R" = "project-kill-buffers";

    "y" =
      if' (call "project-current" false) (call-interactively "project-compile")
        (call-interactively "compile");
    "Y" = "compile";

    "l" = if' (call "project-current" false) (call-interactively "project-eshell") (
      call-interactively "eshell"
    );
    "L" = "eshell";

    "p" = "project-switch-project";
  };

  programs.emacs.use-package.multiple-cursors = {
    enable = true;
    custom."mc/always-run-for-all" = true;
  };

  programs.emacs.use-package.expreg = {
    enable = true;
    after = [ "meow" ];
    demand = true;
    bind.meow-normal-state-keymap."r" = "expreg-expand";
  };

  programs.emacs.use-package.eglot = {
    enable = true;
    package = null;
    bind.eglot-mode-map = {
      # this is broken in insert mode too
      # "R" = "eglot-rename";
      "M-q" = "eglot-format";
      "M-RET" = "eglot-code-actions";
    };
  };

  programs.emacs.use-package.paredit = {
    enable = true;
    hook = {
      emacs-lisp-mode = "enable-paredit-mode";
      # eval-expression-minibuffer-setup = "enable-paredit-mode";
      ielm-mode = "enable-paredit-mode";
      lisp-mode = "enable-paredit-mode";
      lisp-interaction-mode = "enable-paredit-mode";
      scheme-mode = "enable-paredit-mode";
    };
  };

  # i used to use these at some point, just here for historic reasons
  programs.emacs.use-package.kakoune.enable = false;
  programs.emacs.use-package.disable-mouse = {
    enable = false;
    custom.global-disable-mouse-mode = 0;
  };
}
