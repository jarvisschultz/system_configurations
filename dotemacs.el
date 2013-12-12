(push "~/.emacs.d/" load-path)

;; add marmalade functionality:
(require 'package)
(add-to-list 'package-archives 
    '("marmalade" .
      "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives 
    '("melpa" .
      "http://melpa.milkbox.net/packages/") 'APPEND)
(package-initialize)

;; (require 'ctable)
;; (require 'benchmark-init)
;; (benchmark-init/install)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EMACS PERFORMED CUSTOMIZATIONS ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono-10"))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#3f3f3f" "#cc9393" "#7f9f7f" "#f0dfaf" "#8cd0d3" "#dc8cc3" "#93e0e3" "#dcdccc"])
 '(ansi-term-color-vector ["#3f3f3f" "#cc9393" "#7f9f7f" "#f0dfaf" "#8cd0d3" "#dc8cc3" "#93e0e3" "#dcdccc"])
 '(column-number-mode t)
 '(custom-safe-themes (quote ("3d6b08cd1b1def3cc0bc6a3909f67475e5612dba9fa98f8b842433d827af5d30"
			      "36a309985a0f9ed1a0c3a69625802f87dee940767c9e200b89cdebdb737e5b29" 
			      "71b172ea4aad108801421cc5251edb6c792f3adbaecfa1c52e94e3d99634dee7" 
			      "bf9d5728e674bde6a112979bd830cc90327850aaaf2e6f3cc4654f077146b406" default)))
 '(fci-rule-color "#383838")
 '(highlight-nonselected-windows t)
 '(matlab-comment-line-s "% ")
 '(matlab-comment-on-line-s "% ")
 '(matlab-comment-region-s "% ")
 '(matlab-shell-ask-MATLAB-for-completions nil)
 '(preview-auto-cache-preamble t)
 '(preview-gs-options (quote ("-q" "-dNOSAFER" "-dNOPAUSE" "-DNOPLATFONTS" "-dPrinted" "-dTextAlphaBits=4" "-dGraphicsAlphaBits=4")))
 '(preview-scale-function 1.25)
 '(safe-local-variable-values (quote (
				      (TeX-auto-parse-length . 999999) 
				      (TeX-auto-regexp-list . TeX-auto-full-regexp-list) 
				      (TeX-parse-self . t) (TeX-auto-save . t)
				      (TeX-source-correlate-method . synctex))))
 '(save-place t nil (saveplace))
 '(show-paren-mode t)
 '(warning-suppress-types (quote ((\(quote\ \(\(undo\ discard-info\)\)\)))))
 '(wdired-allow-to-change-permissions t))




;;;;;;;;;;;;;;;;;
;; KEYBINDINGS ;;
;;;;;;;;;;;;;;;;;
;; Bind a new key for changing line wrapping properties:
(define-key global-map [f5] 'toggle-truncate-lines)
(define-key global-map [f6] 'visual-line-mode)
(setq-default truncate-lines t)
(setq truncate-partial-width-windows nil) ;; for vertically-split windows
;; Bind a key for compiling code:
(global-set-key [f12] 'compile)
;; Miscellaneous bindings:
(global-set-key "\M-g" 'goto-line)
(global-set-key [f10] 'shell)
;; add shortcuts for splitting and changing windows
(global-set-key (kbd "M-1") 'delete-other-windows)
(global-set-key (kbd "M-2") 'split-window-vertically)
(global-set-key (kbd "M-3") 'split-window-horizontally)
(global-set-key (kbd "M-4") 'other-window)
(global-set-key (kbd "M-5") 'switch-to-buffer)
;; bind regex forward and backward search to a easier keyboard
;; commands:
(global-set-key (kbd "C-M-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-M-r") 'isearch-backward-regexp)
;; define a key for totally escaping icicles commands
(global-set-key (kbd "C-c C-g") 'top-level)
;; bind key for the new emacs24 function count-words
(global-set-key (kbd "C-c C-=") 'count-words)
;; add a second keybinding for scrolling through errors... don't like
;; the backtick:
(global-set-key (kbd "C-c n") 'next-error)
;; add keybinding for browsing kill ring
(global-set-key (kbd "C-c C-y") 'browse-kill-ring)
;; make hippie-expand my default expansion:
(global-set-key (kbd "M-/") 'hippie-expand)
;; add key for using tag expand:
(global-set-key (kbd "M-RET") 'complete-tag)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; WINDOWS, GRAPHICS AND APPEARANCE SETTINGS ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Turn on window saving mode for restoring window configs:
(winner-mode 1)
;; enable column numbering
(column-number-mode 1)
;; disable startup message
(setq inhibit-startup-message t)
;; set default fill column value
(setq-default fill-column 80)
;; Turn on syntax highlighting
(global-font-lock-mode t)
;; turn off menu bars:
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
;; enable clipboard yanking
(setq x-select-enable-clipboard t)
;; turn on shell auto-coloring by default
(setq ansi-color-for-comint-mode t)
;; add color functionality
(load-theme 'zenburn t)
;; disable scroll bars
(toggle-scroll-bar -1)
(set-scroll-bar-mode nil) 
;; use gutter to display buffer position
(setq-default indicate-buffer-boundaries 'left)
(setq-default indicate-empty-lines +1)

;; Define hooks to set visibility options specific to console or window modes:
(defvar after-make-console-frame-hooks '()
  "Hooks to run after creating a new TTY frame")
(defvar after-make-window-system-frame-hooks '()
  "Hooks to run after creating a new window-system frame")

(defun run-after-make-frame-hooks (frame)
  "Selectively run either 'after-make-console-frame-hooks' or
'after-make-window-system-frame-hooks'"
  (select-frame frame)
  (run-hooks (if window-system
		 'after-make-window-system-frame-hooks
	       'after-make-console-frame-hooks)))

(defun set-my-custom-window-settings ()
  (toggle-scroll-bar -1)
  (set-scroll-bar-mode nil) 
  (set-frame-width (selected-frame) 102)
  (set-frame-height (selected-frame) 48)
)

(defun set-my-custom-terminal-settings ()
  "run any commands specific to no-window mode"
  )

(add-hook 'after-make-frame-functions 'run-after-make-frame-hooks)
(add-hook 'after-init-hook
	  (lambda () (run-after-make-frame-hooks (selected-frame))))
(add-hook 'after-make-window-system-frame-hooks
	  'set-my-custom-window-settings)
(add-hook 'after-make-console-frame-hooks
	  'set-my-custom-terminal-settings)

;;;;;;;;;;;;;;;;;;;;;
;; MOUSE BEHAVIORS ;;
;;;;;;;;;;;;;;;;;;;;;
(setq redisplay-dont-pause t
      scroll-margin 1
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)
(setq mouse-wheel-follow-mouse 't)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MISCELLANEOUS BEHAVIORS OF BUILT IN PACKAGES ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; most modes automatically make RET newline and indent, but for those that
;; don't, let's set it that way
;; (define-key global-map (kbd "RET") 'newline-and-indent)
;; (setq-default indent-tabs-mode t)
;; disable backup files
(setq make-backup-files nil)
;; enable scroll-left command
(put 'scroll-left 'disabled nil)
;; Enter also indents in cc-mode
(defun my-make-CR-do-indent ()
   (define-key c-mode-base-map "\C-m" 'c-context-line-break))
(add-hook 'c-initialization-hook 'my-make-CR-do-indent)
;; Choose default cc-mode styles
(setq c-default-style '((other . "linux")))
(setq c-basic-offset 4)
;; Turn on CamelCase mode by default
(add-hook 'c-mode-common-hook
	  (lambda () (subword-mode 1)))
(add-hook 'c++-mode-common-hook
	  (lambda () (subword-mode 1)))
(add-hook 'python-mode-hook
	  (lambda () (subword-mode 1)))
(add-hook 'prog-mode-hook
	  (lambda () (subword-mode 1)))
(add-hook 'text-mode-hook
	  (lambda () (subword-mode 1)))
;; set the value of the macro ring buffer
(setq kmacro-ring-max 20)
;; enable delete-selection-mode
(delete-selection-mode)
;; add tramp functionality:
(require 'tramp)
(setq tramp-default-method "scp")
;; start server if not already running when using just 'emacs' on
;; command line
(require 'server)
(or (server-running-p)
    (server-start))
;; something keeps resetting the XML indentation settings
(setq nxml-child-indent 2)
;; for narrowing editing to a single region:
(put 'narrow-to-region 'disabled nil)
;; don't want browsing kill ring to mess up my display:
(setq browse-kill-ring-quit-action 'save-and-restore)
;; enable dired+ instead of dired and turn on "a" command
(require 'dired+)
(put 'dired-find-alternate-file 'disabled nil)
(setq dired-omit-files "^\\...+$")
;; add keybinding for activating wdired-mode
(add-hook 'dired-mode-hook 
	  (lambda () (define-key dired-mode-map 
	    (kbd "C-c C-q") 'wdired-change-to-wdired-mode)))
;; enable unzipping within Dired
(eval-after-load "dired-aux"
   '(add-to-list 'dired-compress-file-suffixes 
                 '("\\.zip\\'" ".zip" "unzip")))
;; use ibuffer by default instead of list-buffers
(defalias 'list-buffers 'ibuffer)
;; set abbrev mode settings
(setq save-abbrevs nil)
;; prevent cursor from moving over prompts in minibuffer
(setq minibuffer-prompt-properties 
      (quote (read-only t point-entered 
			minibuffer-avoid-prompt face minibuffer-prompt)))
;; set emacs completions to be case-insensitive
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; OTHER PACKAGE LOADING AND CONFIGURATIONS ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; add miscellaneous packages dir to load path
(add-to-list 'load-path "~/.emacs.d/misc-packages/")
;; Add functionality for expand region:
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key (kbd "C-+") 'er/contract-region)
;; add functionality for art-bollocks mode
;(require 'artbollocks-mode)
;; add functionality for textlint mode
(add-to-list 'load-path "~/.emacs.d/textlint/")
(require 'textlint)
;; fix commenting problems in xml mode
(require 'mz-comment-fix)
(add-to-list 'comment-strip-start-length (cons 'nxml-mode 3))
;; add mathematica mode:
(require 'mathematica)
;; add functionality for magit mode
;; (require 'magit)
;; add my function that joins a region into a single line
(require 'join-region)
;; add my function that opens a file as sudo
(require 'edit-as-root)
(global-set-key (kbd "C-x F") 'my-find-file-as-root)


;; EXEC-PATH-FROM-SHELL PACKAGE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ensure environment variables stay consistent even if launched from a gui
;; button
(require 'exec-path-from-shell)
(add-to-list 'exec-path-from-shell-variables "PYTHONPATH")
(when window-system (exec-path-from-shell-initialize))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; SMARTPARENS MODE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; must be installed via elpa, or (require 'smartmparens)
(show-smartparens-global-mode +1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; AUTOCOMPLTE MODE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Add autocomplete package:
(add-to-list 'load-path "~/.emacs.d/auto-complete-extras/")
(require 'auto-complete-config)
(ac-config-default)
(define-key global-map (kbd "<C-tab>") 'ac-fuzzy-complete)
(auto-complete-mode)
(setq ac-ignore-case nil)
;; enable yasnippet with ac:
(set-default 'ac-sources
             '(ac-source-abbrev
               ac-source-dictionary
               ac-source-yasnippet
               ac-source-words-in-buffer
               ac-source-words-in-same-mode-buffers
               ac-source-semantic))
;; turn on yasnippet by default for all modes
(yas-global-mode)
;; add hook for c-sources in c mode
(require 'ac-c-headers)
(add-hook 'c-mode-common-hook
	  (lambda ()
	    (add-to-list 'ac-sources 'ac-source-c-headers)
	    (add-to-list 'ac-sources 'ac-source-c-header-symbols t)))
;; allow return key to also autocomplete:
(define-key ac-completing-map "\C-m" nil)
(setq ac-use-menu-map t)
(define-key ac-menu-map "\C-m" 'ac-complete)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; ROSEMACS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Add functionality for rosemacs
(add-to-list 'load-path "/home/jarvis/ros/stacks/rosemacs/")
(require 'rosemacs)
(invoke-rosemacs)
;; add a keymap for using rosemacs commands
(global-set-key "\C-x\C-r" ros-keymap)
;; since ROS Groovy, catkin inserts ansi-color sequences into the output of the
;; compilation buffer... let's fix that
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)
;; the way I am doing the following doesn't seem very safe!
(defvar compile-history nil)
(setq compile-history '("cd /home/jarvis/groovyws/ && catkin_make "))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; LATEX ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Add Latex functionality
(add-to-list 'load-path "~/.emacs.d/elpa/auctex-11.87/")
(require 'tex-site)
(require 'my-auctex-plugins.el)
(require 'auctex-latexmk)
(auctex-latexmk-setup)
(setq-default TeX-master nil)
(setq TeX-parse-self t)
(setq TeX-auto-save t)
(setq TeX-electric-sub-and-superscript t)
;; Add reverse LaTeX searching:
(setq TeX-source-correlate-mode t)
(setq TeX-source-correlate-method "synctex")
(setq LaTeX-command "latex -file-line-error -shell-escape")
;; set options for latex compilation
(setq LaTeX-command "latex -file-line-error")
;; turn on reftex by default
(add-hook 'LaTeX-mode-hook 'reftex-mode)
(add-hook 'bibtex-mode-hook 'reftex-mode)
(setq reftex-plug-into-AUCTeX t)
;; make reftex use frametitle and lecture for TOC
(add-hook 'reftex-load-hook
	  (lambda ()
	    (setq reftex-section-levels
		  (cons '("frametitle" . 7) 
			reftex-section-levels))))
;; makes reftex use cleveref for all styles by default:
(defun reftex-format-cref (label def-fmt style)
  (format "\\cref{%s}" label))
(setq reftex-format-ref-function 'reftex-format-cref)
(defun reftex-toggle-cref ()
  "Function to toggle whether reftex should use cref latex package or not"
  (interactive)
  (if (eq reftex-format-ref-function nil)
      (setq reftex-format-ref-function 'reftex-format-cref)
    (setq reftex-format-ref-function nil))
  (message "Set reftex-format-ref-function to %s" reftex-format-ref-function)
)
;; add LaTeX-auto-complete mode
(require 'ac-math)
(add-to-list 'ac-modes 'latex-mode)   ; make auto-complete aware of {{{latex-mode}}}
(defun ac-latex-mode-setup ()         ; add ac-sources to default ac-sources
  (setq ac-sources
     (append '(ac-source-math-unicode ac-source-math-latex ac-source-latex-commands)
               ac-sources))
)
(add-hook 'LaTeX-mode-hook 'auto-complete-mode)
(add-hook 'LaTeX-mode-hook 'ac-latex-mode-setup)
(ac-flyspell-workaround)
;; Binding for running a bash script:
(define-key TeX-mode-map [f11] (lambda() (interactive) (shell-command "./LatexCompile")))
;; binding for my indent function
(add-hook 'LaTeX-mode-hook (lambda () (define-key
					LaTeX-mode-map (kbd "<f9>") 
					'indent-region-as-c)))
;; binding for compiling beamer frames
(add-hook 'LaTeX-mode-hook (lambda () (define-key
					LaTeX-mode-map (kbd "C-M-x") 
					'tex-beamer-frame)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 



;; PYTHON ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; add python functionality
(add-to-list 'load-path "~/.emacs.d/misc-packages/python-mode-6.1.1/")
(add-to-list 'load-path "~/.emacs.d/misc-packages/python-mode-6.1.1/completion/")
(add-to-list 'load-path "~/.emacs.d/misc-packages/python-mode-6.1.1/extensions/")
(setq py-install-directory "~/.emacs.d/misc-packages/python-mode-6.1.1/")
(require 'python-mode)
(require 'column-marker)
;; make python mode recognize _ as a word separator
;; (modify-syntax-entry ?_ "_" py-mode-syntax-table)
(modify-syntax-entry ?_ "_" python-mode-syntax-table)
(add-hook 'python-mode-hook 'highlight-indentation-mode)
;; set docstring formatting options
(add-hook 'python-mode-hook (function 
			     (lambda () (setq py-docstring-style 'django))))
;; enable cython-mode
(require 'cython-mode)
;; elpy configurations
;; (require 'elpy)
(setq elpy-mode nil)
(defun elpy-start ()
  (elpy-enable)
  (message "elpy enabled")
  (setq elpy-rpc-backend "jedi")
  (elpy-use-ipython)
  ;; (elpy-clean-modeline)
  (find-alternate-file (buffer-file-name (current-buffer)))
  )
(defun elpy-stop ()
  (elpy-disable)
  (message "elpy disabled")
  (find-alternate-file (buffer-file-name (current-buffer)))
)
(defun elpy-toggle ()
  "Toggle whether elpy is enabled or not, and set some defaults"
  (interactive)
  (if (eq elpy-mode nil)
      ;; then enable and set vars:
      (elpy-start)
    ;; otherwise disable:
    (elpy-stop)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;; FLYSPELL ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Turn on FlySpell for some things by default
;(add-hook 'c-mode-hook 'flyspell-prog-mode) ;; for individual modes
(setq flyspell-use-meta-tab nil)
(add-hook 'text-mode-hook 'turn-on-flyspell)
(add-hook 'change-log-mode-hook 'turn-on-flyspell)
(add-hook 'tex-mode-hook 'turn-on-flyspell)
(add-hook 'tex-mode-hook (function (lambda () (setq ispell-parser 'tex))))
(add-hook 'texinfo-mode
	  '(lambda () (setq flyspell-generic-check-word-p
			    'texinfo-mode-flyspell-verify)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; MATLAB ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Add matlab-emacs mode
(add-to-list 'load-path "~/src/emacs_stuff/matlab-emacs/")
;(load-library "matlab-load")
(autoload 'matlab-mode "matlab" "Matlab Editing Mode" t)
(add-to-list
 'auto-mode-alist
 '("\\.m$" . matlab-mode))
(setq matlab-indent-function t)
(setq matlab-shell-command "matlab")
(setq matlab-shell-command-switches '("-nodesktop"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; PROCESSING ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Add processing-emacs mode
(add-to-list 'load-path "~/src/emacs_stuff/processing-emacs/")
(autoload 'processing-mode "processing-mode" "Processing mode" t)
(add-to-list 'auto-mode-alist '("\\.pde$" . processing-mode))
(setq processing-location "~/processing-2.0.1/")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; ICICLES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Icicle functionality
(require 'icicles)
(setq icicle-expand-input-to-common-match-flag nil)
(setq icicle-expand-input-to-common-match 2)
(setq icicle-search-replace-common-match-flag nil)
(setq icicle-incremental-completion-flag nil)
(setq icicle-region-background "#4f4f4f")
(setq icicle-image-files-in-Completions 'nil)
;; turn on icicles by default
(icy-mode 1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; BUFFER MOVE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'buffer-move)
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; RECENTF CUSTOMIZATIONS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; use recentf to store a list of recent files across sessions:
(require 'recentf)
(recentf-mode 1)
(setq recentf-last-list '())
(defun recentf-save-if-changes ()
  "If the file list has changed, we will re-save it."
  (unless (equalp recentf-last-list recentf-list)
    (setq recentf-last-list recentf-list)
    (recentf-save-list)))
(run-at-time t 300 'recentf-save-if-changes) ;; run occasionally
(add-to-list 'recentf-exclude "\\.recentf\\'") 
(add-to-list 'recentf-exclude ".*\\.git/.*\\'")
(add-to-list 'recentf-exclude ".*\\.gpg\\'") 
(add-to-list 'recentf-exclude ".*\\.emacs\\.d/elpa.*\\'")
(global-set-key (kbd "C-c f") 'recentf-open-files)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; CEDET MODE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'semantic/bovine/gcc)
;; (setq semantic-default-submodes nil)
(add-to-list 'semantic-default-submodes 'global-semantic-decoration-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)
(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)
(semantic-mode 1)
(setq my-semantic-inhibited-modes '(python-mode latex-mode))
(defun my-inhibited-modes-check ()
  "Check if current buffer's mode is allowed to have cedet run"
  (member major-mode my-semantic-inhibited-modes))
(add-to-list 'semantic-inhibit-functions 'my-inhibited-modes-check)
;; (defun my-c-mode-cedet-hook ()
;;   (semantic-idle-summary-mode 1)
;;   (semantic-mru-bookmark-mode 1)
;;   (semantic-highlight-func-mode 1)
;;   (semantic-decoration-mode 1))
;; ;; (add-hook 'c-mode-common-hook
;; ;; 	  '(lambda () (add-hook 'semantic-init-hook 'my-c-mode-cedet-hook t t)))
;; (add-hook 'c-mode-common-hook 'my-c-mode-cedet-hook)
(semantic-mode 1)
(global-ede-mode 1)
(ede-enable-generic-projects)
(semanticdb-enable-gnu-global-databases 'c-mode)
(semanticdb-enable-gnu-global-databases 'c++-mode)
(setq-mode-local c-mode semanticdb-find-default-throttle
                      '(project local unloaded system recursive))
(setq-mode-local c++-mode semanticdb-find-default-throttle
                      '(project local unloaded system recursive))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
