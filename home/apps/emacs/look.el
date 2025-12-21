(scroll-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
(tool-bar-mode -1)

(use-package frame
  :custom
  (line-spacing .5)
  (default-frame-alist
   ;; figure out a way to wire in configs.fonts.monospace from nix land
   '((font . "Aporetic Sans Mono 13")
     ;; looks ugly with spacious-padding
     (alpha-background . 70)
     ;; poor mans spacious padding
     (internal-border-width . 24)
     (vertical-scroll-bars . nil)))
  :config
  (modify-all-frames-parameters default-frame-alist))

(use-package pixel-scroll
  :bind
  ([remap scroll-up-command]   . pixel-scroll-interpolate-down)
  ([remap scroll-down-command] . pixel-scroll-interpolate-up)
  :custom
  (pixel-scroll-precision-interpolate-page t)
  :init
  (pixel-scroll-precision-mode 1))

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

(use-package org-modern
  :hook (org-mode (org-agenda-finalize . org-modern-agenda)))

;; (use-package spacious-padding
;;   :config (spacious-padding-mode))
