(use-package eat
  :hook
  (eshell-load . eat-eshell-mode)
  (eshell-load . eat-eshell-visual-command-mode))

(use-package tramp
  :custom
  (password-cache t "Enable password cache")
  (password-cache-expiry (* 5 60) "Set expiry to 5 mins (same as sudo)"))

(use-package eshell
  :requires tramp
  :custom
  (eshell-modules-list
   '(;; eshell-alias
     ;; eshell-banner
     eshell-basic
     eshell-cmpl
     eshell-dirs
     ;; eshell-extpipe
     eshell-glob
     eshell-hist ;; TODO: replace with eshell-atuin
     eshell-ls
     eshell-pred ;; NOTE: looks useful, maybe learn? if not get rid of it
     eshell-prompt
     eshell-script ;; sure??? sounds dumb tho
     eshell-term
     eshell-unix
     eshell-tramp
     ;; eshell-smart ;; it's awful... IMHO!!!
     ))
  :config
  (defun eshell/c ()
    "Alias to clear screen+scrollback"
    (eshell/clear t))
  (defun eshell/ff (&rest files)
    "Alias to find-file that supports wildcards"
    (-map #'find-file-noselect (-flatten files))))
