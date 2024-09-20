(scroll-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
(tool-bar-mode -1)

(add-to-list 'default-frame-alist '(font . "Iosevka 13"))
(add-to-list 'default-frame-alist '(alpha-background . 80))
(pixel-scroll-precision-mode)

(use-package catppuccin-theme
  :config
  (enable-theme 'catppuccin)
  (when (require 'dbus nil 'noerror)
    (if (eq 2 (caar
               (dbus-call-method
                :session
                "org.freedesktop.portal.Desktop"
                "/org/freedesktop/portal/desktop"
                "org.freedesktop.portal.Settings" "Read"
                "org.freedesktop.appearance" "color-scheme")))
	(catppuccin-load-flavor 'latte)
      (catppuccin-load-flavor 'mocha))
    (dbus-register-signal
     :session
     "org.freedesktop.portal.Desktop"
     "/org/freedesktop/portal/desktop"
     "org.freedesktop.portal.Settings"
     "SettingChanged"
     (lambda (namespace key value)
       (when (and (string= namespace "org.freedesktop.appearance")
		  (string= key "color-scheme"))
	 (if (eq (car value) 2)
	     (catppuccin-load-flavor 'latte)
	   (catppuccin-load-flavor 'mocha)))))))

(setq-default line-spacing (floor (* .75 13)))

(provide 'look)
