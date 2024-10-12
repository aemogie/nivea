(defun bluetooth-connect ()
  "Connect to a bluetooth device"
  (interactive)
  (let* ((devices  (split-string (shell-command-to-string "bluetoothctl devices") "\n" t))
	 (choices  (mapcar (lambda (device)
			     (let* ((parts (split-string device " "))
				    (mac (cadr parts))
				    (name (string-join (cddr parts) " ")))
			       (cons name mac)))
			   devices))
         (selected (completing-read "Select Bluetooth device: " (mapcar #'car choices)))
         (mac      (cdr (assoc selected choices))))
    (when mac
      (message "Attempting to connect to %s (%s)" selected mac)
      (make-process
       :name "bluetoothctl-connect"
       :buffer "*bluetoothctl-output*"
       :command (list "bluetoothctl" "connect" mac)
       :sentinel (lambda (process event)
                   (if (string= event "finished\n")
                       (message "Successfully connected to %s (%s)" selected mac)
		     (message "Error connecting to %s (%s)" selected mac)))))))
