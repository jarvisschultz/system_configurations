(defun zoom-on ()
  (interactive)
  (set-face-attribute 'default nil :height 140))

(defun zoom-off ()
  (interactive)
  (set-face-attribute 'default nil :height 100))

(provide 'zoom-fonts)
