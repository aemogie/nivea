(require 'vertico)
(require 'marginalia)
(require 'disable-mouse)
(require 'nix-mode)
(require 'meow-setup)
(require 'magit)
(require 'eat)

(require 'look)

(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))
(add-hook 'eshell-load-hook #'eat-eshell-mode)
(add-to-list 'magit-process-password-prompt-regexps
	     "^\\(Enter \\)?[Pp]assphrase\\( for \\(RSA \\)?.*\\)?: ?$")

(vertico-mode)
(marginalia-mode)
