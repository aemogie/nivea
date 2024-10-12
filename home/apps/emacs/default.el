(require 'binds)
(require 'look)

(use-package eat
  :hook
  (eshell-load . eat-eshell-mode))

(use-package magit
  :config
  (add-to-list 'magit-process-password-prompt-regexps "Enter passphrase for .*:")
  (add-to-list 'magit-process-password-prompt-regexps "Bad passphrase, try again for .*:"))

(use-package vertico :config (vertico-mode))
(use-package marginalia :config (marginalia-mode))

;; i thought `nil` would work, but it doesnt. wonder why
(use-package disable-mouse :config (global-disable-mouse-mode 0))

(use-package org
  :defer t
  :custom (org-log-into-drawer 1))
(use-package nix-mode :mode "\\.nix\\'")
(use-package kotlin-mode :mode "\\.kts?\\'")
