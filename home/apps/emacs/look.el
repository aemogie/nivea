(scroll-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
(tool-bar-mode -1)

(add-to-list 'default-frame-alist '(font . "Iosevka 14"))
(add-to-list 'default-frame-alist '(alpha-background . 80))
(pixel-scroll-precision-mode)

(setq catppuccin-flavor 'mocha)
(enable-theme 'catppuccin)

(provide 'look)
