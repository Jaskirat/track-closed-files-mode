;;; track-closed-files.el --- Keep track of recently closed files

;; Author: Jaskirat Singh <me@jaskirat.info>
;; URL: http://github.com/jaskirat/track-closed-files-mode
;; Version: 0.1

;;Summary:
;;Open recently closed files similar to Ctrl-Shift-T functionality
;;available in most of the modern browsers.

;;Credits:
;;Stolen and adapted from http://stackoverflow.com/a/2227692/42368

(defvar closed-files (list)
  "This list keeps track of files that were recently closed")

;;;###autoload
(defun track-closed-file ()
  "Add closed file to closed-files var"
  (and  buffer-file-name
        (message buffer-file-name)
        (or (delete buffer-file-name closed-files) t)
        (add-to-list 'closed-files buffer-file-name)))

;;;###autoload
(defun recently-closed-files ()
  "Choose file from recently closed files"
  (interactive)
  (find-file (ido-completing-read "Recently Closed->" closed-files)))

;;;###autoload
(defun restore-closed-file ()
  "Restore most recently closed file"
  (interactive)
  (let ((recent (pop closed-files)))
    (if  recent
        (and (message recent) (find-file recent))
      (message "No files were closed recently!"))))

;;;###autoload
(define-minor-mode track-closed-files-mode
  "Minor mode to automatically keep track of files being closed and optionally restore recently closed files."
  :init-value nil
  :global t
  
  (if track-closed-files-mode
      ;;activate     
      (progn
        (add-hook 'kill-buffer-hook 'track-closed-file)
        (message "Track closed files mode enabled!"))
    ;;deactivate
    (progn
      (remove-hook 'kill-buffer-hook 'track-closed-file)
      (message "Track closed files mode disabled!"))))

;;Keybinding to display recently closed files
(global-set-key (kbd "C-S-y") 'recently-closed-files)

;;Keybinding to open most recently closed file
(global-set-key (kbd "C-S-t") 'restore-closed-file)

(provide 'track-closed-files)
;;; track-closed-files.el ends here
