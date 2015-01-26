(defun occur-dwim ()
  "Call `occur' with a sane default. If region active, choose it; otherwise, use symbol at point"
  (interactive)
  (push (if (region-active-p)
            (buffer-substring-no-properties
             (region-beginning)
             (region-end))
          (thing-at-point 'symbol))
        regexp-history)
  (call-interactively 'occur))


(provide 'occur-dwim)
