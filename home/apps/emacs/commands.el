(defun bluetooth-connect ()
  "Connect to bluetooth device"
  (interactive)
  (let* ((devices  (split-string (shell-command-to-string "bluetoothctl devices") "\n" t))
         (selected (completing-read "Select Bluetooth device: " devices))
         (mac      (cadr (split-string selected " "))))
    (when mac
      (message "Attempting to connect to %s" selected)
      (make-process
       :name "bluetoothctl-connect"
       :buffer "*bluetoothctl-output*"
       :command (list "bluetoothctl" "connect" mac)
       :sentinel (lambda (process event)
                   (if (string= event "finished\n")
                       (message "Successfully connected to %s" selected)
		     (message "Error connecting to %s" selected)))))))
