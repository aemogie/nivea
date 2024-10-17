;; TODO: make proper feature
(defun eshell-frame--get-frame-buffers ()
  "Filter buffer-list to exclude the current eshell and other default buffers."
  (let* ((all-buffers (append (frame-parameter nil 'buffer-list)
			      (frame-parameter nil 'buried-buffer-list)))
	  ;; TODO: more proper check
	 (other-buffers
	  (-difference all-buffers (list (current-buffer))))
	 ;; TODO: make defcustom
	 (default-buffers '("*scratch*"
			    "*Messages*" "*Backtrace*"
			    " *Minibuf-0*" " *Minibuf-1*")))
    ;; almost '-difference' but its names not the actual buffer valuesw
    (--filter (not (member (buffer-name it) default-buffers))
	      other-buffers)))


(defun eshell-frame--handle-exit ()
  "The `kill-buffer-hook' handler that checks the filtered buffer-list,
and deletes the frame if empty."
  (when (frame-parameter nil 'eshell-frame)
    (let ((buffers (eshell-frame--get-frame-buffers)))
      (if buffers
          (switch-to-buffer (car buffers))
        (delete-frame)))))

(defun eshell-frame--new-eshell-buffer ()
  "Create a new eshell buffer, without switching to it.
This exists as the `eshell' function causes a foreground buffer
switch, which is not what we need. In addition `eshell-get-buffer'
when creating a new buffer, doesn't enable `eshell-mode'."
  ;; TODO: make defcustom
  (let ((buf (generate-new-buffer "eshell-frame")))
    (with-current-buffer buf
      (add-hook 'kill-buffer-hook #'eshell-frame--handle-exit nil t)
      (eshell-mode))
    buf))

;; entrypoint
(defun eshell-frame ()
  (interactive)
  (let* ((buf (eshell-frame--new-eshell-buffer))
	 (frame (with-current-buffer buf
		 (make-frame '((eshell-frame . t))))))
    frame))
