;; try kakoune.el instead
;; update: it was very barebones
(use-package meow
  :bind (()
	 :map meow-normal-state-keymap
	 ;; motion cluster
	 ("n" . meow-back-word)
	 ("e" . meow-next)
	 ("i" . meow-prev)
	 ("a" . meow-next-word)

	 ;; insert in various ways (shift + motion)
	 ("N" . meow-insert)
	 ("E" . meow-open-below)
	 ("I" . meow-open-above)
	 ("A" . meow-append)
	 ("F" . meow-change)

	 ;; undo
	 ("u" . meow-undo)
	 ("U" . meow-undo-in-selection)

	 ;; mutation cluster
	 ("c" . meow-yank)
	 ("C" . meow-replace)
	 ("r" . meow-block) ;; replaced with expreg below
	 ("s" . meow-line)
	 ("t" . meow-kill)
	 ("y" . meow-save)

	 ("g" . keyboard-quit)
	 ("<escape>" . keyboard-quit)

	 ;; search
	 ("h" . meow-visit)
	 ("d" . meow-search)

	 ;; rare
	 ("G" . meow-grab)
	 ("k" . meow-till)
	 ("x" . meow-join)

	 :map meow-motion-state-keymap
	 ("e" . meow-next)
	 ("i" . meow-prev)

	 ("h" . meow-visit)
	 ("d" . meow-search)

	 ("<escape>" . keyboard-quit)

	 :map mode-specific-map
	 ;; very frequent
	 ("<SPC>" . save-buffer)
	 ("e" .  other-window)
	 ("E" .  delete-window)

	 ("t" . (lambda () (interactive)
		  (if (project-current nil)
		      (call-interactively #'project-find-file)
		    (call-interactively #'find-file))))
	 ("T" . find-file)

	 ("s" . (lambda ()
		  (interactive)
		  (if (eq major-mode 'erc-mode)
		      (call-interactively #'erc-switch-to-buffer)
		    (if (project-current nil)
			(call-interactively #'project-switch-to-buffer)
		      (call-interactively #'switch-to-buffer)))))
	 ("S" . switch-to-buffer)

	 ("r" . (lambda () (interactive)
		  (if (project-current nil)
		      (call-interactively #'project-eshell)
		    (call-interactively #'eshell))))
	 ("R" . eshell)

	 ("y" . (lambda () (interactive)
		  (if (project-current nil)
		      (call-interactively #'project-compile)
		    (call-interactively #'compile))))
	 ("Y" . compile)

	 ("j" . kill-buffer)
	 ("J" . project-kill-buffers)

	 ("p" . project-switch-project))

  :custom
  (meow-use-clipboard t)
  (meow-expand-hint-counts '((word . 0)
			     (line . 0)
			     (block . 0)
			     (find . 0)
			     (till . 0)))
  (meow-global-mode 1))

(use-package multiple-cursors
  :custom (mc/always-run-for-all t))

(use-package expreg
  :bind (:map meow-normal-state-keymap
	      ("r" . expreg-expand)))

(use-package eglot
  :bind (:map eglot-mode-map
	      ("R" . eglot-rename)
	      ("M-q" . eglot-format)
	      ("M-RET" . eglot-code-actions)))
