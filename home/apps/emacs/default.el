(require 'vertico)
(require 'marginalia)
(require 'disable-mouse)
(require 'nix-mode)
(require 'catppuccin-theme)

(require 'meow-setup)
(require 'look)


; (global-disable-mouse-mode)

(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))

; minibuf
(vertico-mode)
(marginalia-mode)
