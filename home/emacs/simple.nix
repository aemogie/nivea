{ lib', ... }:
let
  inherit (lib'.elisp)
    call
    var
    fnref
    defun
    when
    sym
    cons
    sane-alist-cons
    ;
  forModeExternal = mode: {
    enable = true;
    inherit mode;
  };
  forModeBuiltin = mode: {
    enable = true;
    package = null;
    inherit mode;
  };
in
{
  programs.emacs.use-package.magit = {
    enable = true;
    config' = [
      (call "add-to-list" (sym "magit-process-password-prompt-regexps")
        "Enter passphrase for .*:"
      )
      (call "add-to-list" (sym "magit-process-password-prompt-regexps")
        "Bad passphrase, try again for .*:"
      )
    ];
  };

  programs.emacs.use-package.envrc = {
    enable = true;
    hook.after-init = "envrc-global-mode";
  };

  programs.emacs.use-package.project = {
    enable = true;
    package = null;
    custom.project-compilation-buffer-name-function = fnref "project-prefixed-buffer-name";
  };
  programs.emacs.use-package.autorevert = {
    enable = true;
    package = null;
    custom.global-auto-revert-mode = true;
  };

  programs.emacs.use-package.elisp-mode = {
    enable = true;
    package = null;
    custom.safe-local-variable-values = [ (cons (sym "lexical-scoping") true) ];
  };

  programs.emacs.use-package.org = {
    enable = true;
    package = null;
    defer = true;
    custom.org-log-into-drawer = 1;
  };

  programs.emacs.use-package.kotlin-mode = forModeExternal "\\.kts?\\'";

  programs.emacs.use-package.geiser-guile = {
    enable = true;
    custom.geiser-guile-load-init-file = true;
  };
  programs.emacs.use-package.guix = {
    enable = true;
    after = [ "geiser-guile" ];
    hook.scheme-mode = "guix-devel-mode";
    custom.global-guix-prettify-mode = true;
  };

  programs.emacs.use-package.eglot = {
    enable = true;
    package = null;
    preface = defun {
      name = "format-when-eglot";
      body = when (call "eglot-managed-p") (call "eglot-format-buffer");
    };
    hook.before-save = "format-when-eglot";
  };

  # ts-mode
  programs.emacs.use-package.html-ts-mode = forModeBuiltin "\\.html\\'";
  programs.emacs.use-package.css-mode = forModeBuiltin {
    "\\.css\\'" = "css-ts-mode";
  };
  programs.emacs.use-package.js = forModeBuiltin {
    "\\(\\.js[mx]\\|\\.har\\)\\'" = "js-ts-mode";
  };
  programs.emacs.use-package.rust-ts-mode = forModeBuiltin "\\.rs\\'";
  programs.emacs.use-package.c-ts-mode = {
    enable = true;
    package = null;
    custom.major-mode-remap-alist = call "append" (sane-alist-cons {
      "c-mode" = sym "c-ts-mode";
      "c++-mode" = sym "c++-ts-mode";
      "c-or-c++-mode" = sym "c-or-c++-ts-mode";
    }) (var "major-mode-remap-alist");
  };
  programs.emacs.use-package.json-ts-mode = forModeBuiltin "\\.json\\'";
  programs.emacs.use-package.sh-script = {
    enable = true;
    package = null;
    custom.major-mode-remap-alist = call "append" (sane-alist-cons {
      "sh-mode" = sym "bash-ts-mode";
    }) (var "major-mode-remap-alist");
  };
  programs.emacs.use-package.toml-ts-mode = forModeBuiltin "\\.toml\\'";
  programs.emacs.use-package.yaml-ts-mode = forModeBuiltin "\\.ya?ml\\'";
  programs.emacs.use-package.typst-ts-mode = forModeBuiltin "\\.typ\\'";
  programs.emacs.use-package.nix-ts-mode = forModeExternal "\\.nix\\'";

  programs.emacs.use-package.ox-typst = {
    enable = true;
    after = [ "typst-ts-mode" ];
  };

  programs.emacs.use-package.erc = {
    enable = true;
    package = null;
    custom = {
      erc-hide-list = [
        "JOIN"
        "PART"
        "QUIT"
      ];
      erc-log-channels-directory = "~/.emacs.d/erc";
      erc-save-buffer-on-part = true;
      erc-log-insert-log-on-open = true;
      erc-log-write-after-send = true;
      erc-log-write-after-insert = true;
      erc-modules = map sym [
        "log"
        "autojoin"
        "button"
        "completion"
        "fill"
        "imenu"
        "irccontrols"
        "list"
        "match"
        "menu"
        "move-to-prompt"
        "netsplit"
        "networks"
        "readonly"
        "ring"
        "stamp"
        "track"
      ];
    };
  };
}
