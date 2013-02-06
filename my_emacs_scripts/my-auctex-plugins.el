
;; add a function for formatting c-code within the LaTeX major mode:
(defun indent-region-as-c (beg end)
  "Switch to c-mode, indent the region, then switch back to LaTeX mode."
  (interactive "r")
  (c-mode)
  (indent-region beg end)
  (LaTeX-mode))

;; Define a function for compiling current Beamer frame 
(defun tex-beamer-frame ()
  "Run pdflatex on current frame.  
Frame must be declared as an environment."
  (interactive)
  (let (beg)
    (save-excursion
      (search-backward "\\begin{frame}")
      (setq beg (point))
      (forward-char 1)
      (LaTeX-find-matching-end)
      (TeX-pin-region beg (point))
      (letf (( (symbol-function 'TeX-command-query) (lambda (x) "LaTeX")))
        (TeX-command-region))
      )
    ))

(provide 'my-auctex-plugins.el)
