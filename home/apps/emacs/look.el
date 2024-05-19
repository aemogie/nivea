(scroll-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
(tool-bar-mode -1)

(add-to-list 'default-frame-alist '(font . "Iosevka 13"))
(add-to-list 'default-frame-alist '(alpha-background . 80))
(pixel-scroll-precision-mode)

(setq catppuccin-flavor 'mocha)
(enable-theme 'catppuccin)

(setq-default line-spacing (floor (* .75 13)))

(provide 'look)
