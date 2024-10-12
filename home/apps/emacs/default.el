(use-package magit
  :config
  (add-to-list 'magit-process-password-prompt-regexps "Enter passphrase for .*:")
  (add-to-list 'magit-process-password-prompt-regexps "Bad passphrase, try again for .*:"))
(use-package envrc
  :hook (after-init . envrc-global-mode))

(use-package vertico :config (vertico-mode))
(use-package marginalia :config (marginalia-mode))
(use-package corfu :config (global-corfu-mode))
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion))))
  (orderless-matching-styles '(orderless-flex orderless-regexp)))

;; i thought `nil` would work, but it doesnt. wonder why
(use-package disable-mouse :config (global-disable-mouse-mode 0))

(use-package org
  :defer t
  :custom (org-log-into-drawer 1))
(use-package nix-mode :mode "\\.nix\\'")
(use-package kotlin-mode :mode "\\.kts?\\'")
