
(defun my/find-file-as-root ()
  "Like `find-file, but automatically edit the file with
root-privileges (using tramp/sudo), if the file is not writable by
user."
  (interactive)
  (let ((file (read-file-name "Edit as root: ")))
    (unless (file-writable-p file)
      (setq file (concat "/sudo:root@localhost:" file)))
    (find-file file)))

(defun my/find-alternative-file-with-sudo ()
  (interactive)
  (let ((fname (or buffer-file-name
				 dired-directory)))
    (when fname
      (if (string-match "^/sudo:root@localhost:" fname)
		(setq fname (replace-regexp-in-string
					  "^/sudo:root@localhost:" ""
					  fname))
		(setq fname (concat "/sudo:root@localhost:" fname)))
      (find-alternate-file fname))))

(provide 'edit-as-root)
