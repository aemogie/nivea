(scroll-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
(tool-bar-mode -1)

(add-to-list 'default-frame-alist '(font . "Iosevka 13"))
(add-to-list 'default-frame-alist '(alpha-background . 80))
(pixel-scroll-precision-mode)

(use-package catppuccin-theme)
(use-package auto-dark
  :after catppuccin-theme
  :config
  (setq auto-dark-detection-method 'dbus)
  (setq auto-dark-dark-theme 'catppuccin)
  (setq auto-dark-light-theme 'catppuccin)
  (auto-dark-mode t)
  :hook ((auto-dark-dark-mode . (lambda () (catppuccin-load-flavor 'mocha)))
	 (auto-dark-light-mode . (lambda () (catppuccin-load-flavor 'latte)))))

(setq-default line-spacing (floor (* .75 13)))

(provide 'look)
