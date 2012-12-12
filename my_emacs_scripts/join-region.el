;; This is a simple function to combine a region into a single line.
(defun join-region (beg end)
  "keep applying join-line to a region until whole region is
joined into a single line."
  (interactive "r")
  (if mark-active
          (let ((beg (region-beginning))
                        (end (copy-marker (region-end))))
                (goto-char beg)
                (while (< (point) end)
                  (join-line 1))))) 

(provide 'join-region)
