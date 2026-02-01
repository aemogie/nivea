(use-package magit
  :config
  (add-to-list 'magit-process-password-prompt-regexps "Enter passphrase for .*:")
  (add-to-list 'magit-process-password-prompt-regexps "Bad passphrase, try again for .*:"))
(use-package envrc
  :hook (after-init . envrc-global-mode))
(use-package project
  :custom
  ;; those usually go in the project root right?
  (project-vc-extra-root-markers '("COPYING" "LICENSE"))
  (project-compilation-buffer-name-function #'project-prefixed-buffer-name))

(use-package vertico :config (vertico-mode))
(use-package marginalia :config (marginalia-mode))
(use-package corfu :config (global-corfu-mode))
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion))))
  (orderless-matching-styles '(orderless-flex orderless-regexp)))

(use-package disable-mouse :config (global-disable-mouse-mode 0))
(use-package paredit
  :hook ((emacs-lisp-mode . enable-paredit-mode)
	 (eval-expression-minibuffer-setup . enable-paredit-mode)
	 (ielm-mode . enable-paredit-mode)
	 (lisp-mode . enable-paredit-mode)
	 (lisp-interaction-mode . enable-paredit-mode)
	 (scheme-mode . enable-paredit-mode)))
(use-package rainbow-delimiters
  :hook (prog-mode))
(use-package compile
  :hook
  (compilation-filter . ansi-color-compilation-filter)
  (compilation-filter . ansi-osc-compilation-filter))

(use-package elisp-mode
  :custom (safe-local-variable-values '((lexical-scoping . t))))
(use-package org
  :defer t
  :custom (org-log-into-drawer 1))
(use-package kotlin-mode :mode "\\.kts?\\'")
(use-package geiser-guile
  :custom (geiser-guile-load-init-file t))
(use-package guix
  :after geiser-guile
  :hook (scheme-mode . guix-devel-mode)
  :config (guix-prettify-global-mode))
(use-package eglot
  :preface
  (defun format-when-eglot ()
    (when (eglot-managed-p) (eglot-format-buffer)))
  :hook (before-save . format-when-eglot))

;; ts-mode

(use-package treesit
  :custom
  (treesit-font-lock-level 4))

(use-package html-ts-mode :mode "\\.html\\'") ;; crashes emacs
(use-package css-mode :mode ("\\.css\\'" . css-ts-mode))
(use-package js :mode ("\\(\\.js[mx]\\|\\.har\\)\\'" . js-ts-mode))
(use-package rust-ts-mode :mode "\\.rs\\'")
(use-package c-ts-mode
  :init
  (add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
  (add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
  (add-to-list 'major-mode-remap-alist '(c-or-c++-mode . c-or-c++-ts-mode)))
(use-package json-ts-mode :mode "\\.json\\'")
(use-package sh-script
  :init (add-to-list 'major-mode-remap-alist '(sh-mode . bash-ts-mode)))
(use-package toml-ts-mode :mode "\\.toml\\'")
(use-package yaml-ts-mode :mode "\\.ya?ml\\'")
(use-package typst-ts-mode :mode "\\.typ\\'")
(use-package nix-ts-mode
  :mode "\\.nix\\'"
  ;:config (nix-prettify-global-mode)
  )

(use-package erc
  :custom
  (erc-hide-list '("JOIN" "PART" "QUIT"))
  (erc-log-channels-directory "~/.emacs.d/erc")
  (erc-save-buffer-on-part t)
  (erc-log-insert-log-on-open t)
  (erc-log-write-after-send t)
  (erc-log-write-after-insert t)
  (erc-modules
   '(log autojoin button completion fill imenu irccontrols list match
	 menu move-to-prompt netsplit networks readonly ring stamp
	 track)))
