(require 'meow-setup)
(require 'look)

(use-package nix-mode :mode "\\.nix\\'")

(use-package eat
  :hook
  (eshell-load . eat-eshell-mode))

(use-package magit
  :config
  (add-to-list 'magit-process-password-prompt-regexps
	       "^\\(Enter \\)?[Pp]assphrase\\( for \\(RSA \\)?.*\\)?: ?$"))

(use-package vertico :config (vertico-mode))
(use-package marginalia :config (marginalia-mode))

;; i thought `nil` would work, but it doesnt. wonder why
(use-package disable-mouse :config (global-disable-mouse-mode 0))
