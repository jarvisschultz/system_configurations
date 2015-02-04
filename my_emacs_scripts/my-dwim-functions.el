(defun my-occur-dwim ()
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


(defun my-dwim-entire-line-function (function)
  "call FUNCTION using region if it is active, otherwise use current line as
region"
  (if (region-active-p)
	(funcall function (region-beginning) (region-end))
	;; else
	(funcall function (point-at-bol) (point-at-eol))))

(defun my-comment-dwim ()
  "call `comment-dwim' using utility function
`my-dwim-entire-line-function'... automatically choose region if
not active"
  (interactive)
  (my-dwim-entire-line-function 'comment-or-uncomment-region))

(provide 'my-dwim-functions)
