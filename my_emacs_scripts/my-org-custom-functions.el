(defun my/org-table-swap-cells (i1 j1 i2 j2)
  "Swap two cells"
  (let ((c1 (org-table-get i1 j1))
	(c2 (org-table-get i2 j2)))
    (org-table-put i1 j1 c2)
    (org-table-put i2 j2 c1)
    (org-table-align)))
	
(defun my/org-table-move-single-cell (direction)
  "Move the current cell in a cardinal direction according to the
  parameter symbol: 'up 'down 'left 'right. Swaps contents of
  adjacent cell with current one."
  (unless (org-at-table-p)
    (error "No table at point"))
  (let ((di 0) (dj 0))
    (cond ((equal direction 'up) (setq di -1))
	  ((equal direction 'down) (setq di +1))
	  ((equal direction 'left) (setq dj -1))
	  ((equal direction 'right) (setq dj +1))
	  (t (error "Not a valid direction, must be up down left right")))
    (let* ((i1 (org-table-current-line))
	   (j1 (org-table-current-column))
	   (i2 (+ i1 di))
	   (j2 (+ j1 dj)))
      (org-table-swap-cells i1 j1 i2 j2)
      (org-table-goto-line i2)
      (org-table-goto-column j2))))

(defun my/org-table-move-single-cell-up ()
  "Move a single cell up in a table; swap with anything in target cell"
  (interactive)
  (org-table-move-single-cell 'up))

(defun my/org-table-move-single-cell-down ()
  "Move a single cell down in a table; swap with anything in target cell"
  (interactive)
  (org-table-move-single-cell 'down))

(defun my/org-table-move-single-cell-left ()
  "Move a single cell left in a table; swap with anything in target cell"
  (interactive)
  (org-table-move-single-cell 'left))

(defun my/org-table-move-single-cell-right ()
  "Move a single cell right in a table; swap with anything in target cell"
  (interactive)
  (org-table-move-single-cell 'right))

(defun my/org-to-html-to-clipboard ()
  "Export region to HTML, and copy it to the clipboard."
  (interactive)
  (org-export-to-file 'html "/tmp/org.html")
  (apply
   'start-process "xclip" "*xclip*"
   (split-string
	 "xclip -verbose -i /tmp/org.html -t text/html -selection clipboard" " ")))

(provide 'my-org-custom-functions)
