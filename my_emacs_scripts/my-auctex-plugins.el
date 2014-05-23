
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


;; Functions for skipping around by blank lines. Useful for modes where
;; paragraph definitions are annoying.
(defun skip-to-next-blank-line ()
  "Skip to next blank line"
  (interactive)
  (let ((inhibit-changing-match-data t))
    (skip-syntax-forward " >")
    (unless (search-forward-regexp "^\\s *$" nil t)
      (goto-char (point-max)))))
(defun skip-to-previous-blank-line ()
  "Skip to previous blank line"
  (interactive)
  (let ((inhibit-changing-match-data t))
    (skip-syntax-backward " >")
    (unless (search-backward-regexp "^\\s *$" nil t)
      (goto-char (point-min)))))



(provide 'my-auctex-plugins)
