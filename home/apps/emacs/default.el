(require 'vertico)
(require 'marginalia)
(require 'disable-mouse)
(require 'nix-mode)
(require 'catppuccin-theme)

(require 'meow-setup)
(require 'look)


; (global-disable-mouse-mode)

(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))
(add-hook 'eshell-load-hook #'eat-eshell-mode)
(add-to-list 'magit-process-password-prompt-regexps
	     "^\\(Enter \\)?[Pp]assphrase\\( for \\(RSA \\)?.*\\)?: ?$")

; minibuf
(vertico-mode)
(marginalia-mode)
