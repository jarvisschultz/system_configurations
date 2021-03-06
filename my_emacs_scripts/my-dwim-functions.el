(defun my/occur-dwim ()
  "Call `occur' with a sane default. If region active, choose it; otherwise, use
symbol at point"
  (interactive)
  (let ((occur-dwim-candidate
  	(if (region-active-p)
  	  (buffer-substring-no-properties
  		(region-beginning)
  		(region-end))
  	  (thing-at-point 'symbol))))
  	(if (stringp occur-dwim-candidate)
  	  (push occur-dwim-candidate regexp-history)
	  nil))
  (call-interactively 'occur))


(defun my/dwim-entire-line-function (function)
  "call FUNCTION using region if it is active, otherwise use current line as
region"
  (if (region-active-p)
	(funcall function (region-beginning) (region-end))
	;; else
	(funcall function (point-at-bol) (point-at-eol))))


(defun my/comment-dwim ()
  "call `comment-dwim' using utility function
`my/dwim-entire-line-function'... automatically choose region if
not active"
  (interactive)
  (my/dwim-entire-line-function 'comment-or-uncomment-region))


(defun my/delete-nonmatch-isearch ()
  "Delete the failed portion of the search string, or the last char if successful."
  (interactive)
  (with-isearch-suspended
      (setq isearch-new-string
            (substring
             isearch-string 0 (or (isearch-fail-pos) (1- (length isearch-string))))
            isearch-new-message
            (mapconcat 'isearch-text-char-description isearch-new-string ""))))


(defun my/fill-paragraph-dwim ()
  "Like `fill-paragraph', but unfill if used twice."
  (interactive)
  (let ((fill-column
         (if (eq last-command 'my/fill-paragraph-dwim)
             (progn (setq this-command nil)
                    (point-max))
           fill-column)))
    (call-interactively #'fill-paragraph)))


(defun my/dired-open-file-dwim ()
  "In dired, open the file named on this line."
  (interactive)
  (let* ((file (dired-get-filename nil t)))
    (message "Opening %s..." file)
    (call-process "xdg-open" nil 0 nil file)
    (message "Opening %s done" file)))

(provide 'my-dwim-functions)
