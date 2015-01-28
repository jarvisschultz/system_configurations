(defcustom zoom-big-size 140
  "Default face height for the `zoom-on' function."
  :type 'int)
(defcustom zoom-small-size 100
  "Default face height for the `zoom-off' function."
  :type 'int)
(defcustom zoom-increment-size 20
  "Default face height change the `zoom-in' and `zoom-out' functions."
  :type 'int)

(defun zoom-on ()
  "Set face height to be `zoom-big-size' for all faces in all frames"
  (interactive)
  (set-face-attribute 'default nil :height zoom-big-size))

(defun zoom-off ()
  "Set face height to be `zoom-small-size' for all faces in all frames"
  (interactive)
  (set-face-attribute 'default nil :height zoom-small-size))

(defun zoom-in ()
  "Increase face height by `zoom-increment-size' for all faces in all frames"
  (interactive)
  (set-face-attribute 'default nil :height
	(+ zoom-increment-size (face-attribute 'default :height nil 'default))))

(defun zoom-out ()
  "Decrease face height by `zoom-increment-size' for all faces in all frames"
  (interactive)
  (set-face-attribute 'default nil :height
	(- zoom-increment-size (face-attribute 'default :height nil 'default))))

(provide 'zoom-fonts)
