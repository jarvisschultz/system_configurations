;; (push "~/.emacs.d/" load-path)

;; add miscellaneous packages dir to load path
(add-to-list 'load-path "~/.emacs.d/misc-packages/")

;; add marmalade functionality:
(require 'package)
;; (add-to-list 'package-archives
;; 	     '("marmalade" .
;; 	       "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
	     '("melpa-stable" .
	       "http://stable.melpa.org/packages/") 'APPEND)
(add-to-list 'package-archives
             '("elpy" .
	       "http://jorgenschaefer.github.io/packages/") 'APPEND)
(package-initialize)

;; tools for benchmarking startup:
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
;; shorten goto-line (breaks things like goto-column):
(global-set-key "\M-g" 'goto-line)
;; ergonomics bindings:
(require 'god-mode)
(global-set-key [f2] 'god-local-mode)
(global-set-key [f7] 'kill-ring-save)
(global-set-key [f8] 'yank)
(global-set-key [f9] 'yank-pop)
(global-set-key [f10] 'find-file)
(global-set-key [f11] 'repeat)
(global-set-key [f12] 'compile)
;; add shortcuts for splitting and changing windows
(require 'switch-window)
(global-set-key (kbd "M-1") 'delete-other-windows)
(global-set-key (kbd "M-2") 'split-window-vertically)
(global-set-key (kbd "M-3") 'split-window-horizontally)
(global-set-key (kbd "M-4") 'switch-window)
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
;; add keybindings for windmove
(windmove-default-keybindings 'meta)


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
;; set all themes to safe
(setq custom-safe-themes t)
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

;; activate my zoom commands:
(require 'zoom-fonts)

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
;; (defun my-make-CR-do-indent ()
;;    (define-key c-mode-base-map "\C-m" 'c-context-line-break))
(add-hook 'c-initialization-hook 'electric-indent-mode)
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
;; (setq tramp-persistency-file-name nil)
;; (setq password-cache nil)
;; (setq password-cache-expiry 16)
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
(setq diredp-hide-details-initially-flag nil)
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
;; turn on global-auto-revert mode
(global-auto-revert-mode 1)
;; turn on markdown mode for certain files
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode)) ;; gfm = github-flavored



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; OTHER PACKAGE LOADING AND CONFIGURATIONS ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Add functionality for expand region:
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key (kbd "C-+") 'er/contract-region)
;; default keybindings for multiple cursors:
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
;; add functionality for art-bollocks mode
;(require 'artbollocks-mode)
;; add functionality for textlint mode
;; (add-to-list 'load-path "~/.emacs.d/textlint/")
;; (require 'textlint)
;; fix commenting problems in xml mode
(require 'mz-comment-fix)
(add-to-list 'comment-strip-start-length (cons 'nxml-mode 3))
;; add mathematica mode:
(require 'mathematica)
;; add my function that joins a region into a single line
(require 'join-region)
;; add my function that opens a file as sudo
(require 'edit-as-root)
(global-set-key (kbd "C-x F") 'my-find-file-as-root)
;; enable fancy-narrow from elpa
(fancy-narrow-mode 1)
;; customize ace-jump-mode from elpa
(define-key global-map (kbd "s-a") 'ace-jump-mode)



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
(require 'auto-complete-config)
(ac-config-default)
(define-key global-map (kbd "<C-tab>") 'ac-fuzzy-complete)
(auto-complete-mode)
(setq ac-ignore-case nil)
(ac-flyspell-workaround)
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
(require 'my-auctex-plugins)
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
;; allow reftex-view-crossref (C-c &) to follow cref macros:
(setq reftex-view-crossref-extra '(("\\[c|C]ref" "\\label{%s}" 0)))
;; makes reftex use cleveref for all styles by default:
(defun reftex-format-cref (label def-fmt style)
  (format "\\cref{%s}" label))
(setq reftex-format-ref-function nil)
(defun reftex-toggle-cref ()
  "Function to toggle whether reftex should use cref latex package or not"
  (interactive)
  (if (eq reftex-format-ref-function nil)
      (progn
	(setq reftex-format-ref-function 'reftex-format-cref)
	;; disable reftex asking if I want to use things like \autoref, or \vref.
	(setq reftex-ref-macro-prompt nil))
    (progn
      (setq reftex-format-ref-function nil)
      (setq reftex-ref-macro-prompt t)))
  (message "Set reftex-format-ref-function to %s" reftex-format-ref-function))
;; turn on cref by default:
(reftex-toggle-cref)
;; prevent reftex from scanning pgf files (.pstex_t) was there by default:
(eval-after-load "reftex-vars"
  '(progn
     (add-to-list 'reftex-no-include-regexps "\\.pgf\\'")))
;; add LaTeX-auto-complete mode
(require 'auto-complete-auctex)
;; binding for compiling beamer frames
(add-hook 'LaTeX-mode-hook (lambda () (define-key
					LaTeX-mode-map (kbd "C-M-x")
					'tex-beamer-frame)))
;; move by blank lines in LaTeX-mode:
(add-hook 'LaTeX-mode-hook (lambda ()
			     (progn
			       (define-key LaTeX-mode-map
				 (kbd "<C-down>") 'skip-to-next-blank-line)
				 (define-key LaTeX-mode-map
				   (kbd "<C-up>") 'skip-to-previous-blank-line))))
;; turn on auto-fill for LaTeX mode:
(add-hook 'LaTeX-mode-hook 'auto-fill-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 



;; PYTHON ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; jedi configurations:
(add-hook 'python-mode-hook 'jedi:setup)
(add-hook 'jedi-mode-hook 'jedi-direx:setup)
(setq jedi:complete-on-dot t)
;; make python mode recognize _ as a word separator
(add-hook 'python-mode-hook (function 
			     (lambda () (modify-syntax-entry ?_ "_" python-mode-syntax-table))))
(add-hook 'python-mode-hook 'highlight-indentation-mode)
;; set docstring formatting options
(add-hook 'python-mode-hook (function 
			     (lambda () (setq py-docstring-style 'django))))
;; (add-hook 'python-mode-hook (function
;; 			     (lambda () (local-set-key (kbd "RET") 'newline-and-indent))))
(add-hook 'python-mode-hook (function
			     (lambda () (local-set-key (kbd "C-c #") 'comment-region))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;; FLYSPELL ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Turn on FlySpell for some things by default
;(add-hook 'c-mode-hook 'flyspell-prog-mode) ;; for individual modes
(setq flyspell-use-meta-tab nil)
(add-hook 'text-mode-hook 'turn-on-flyspell)
(add-hook 'change-log-mode-hook 'turn-on-flyspell)
(add-hook 'nxml-mode-hook 'turn-off-flyspell)
(add-hook 'LaTeX-mode-hook 'turn-on-flyspell)
(add-hook 'LaTeX-mode-hook (function (lambda () (setq ispell-parser 'tex))))
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



;; ;; ICICLES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Icicle functionality
;; (require 'icicles)
;; (setq icicle-expand-input-to-common-match-flag nil)
;; (setq icicle-expand-input-to-common-match 2)
;; (setq icicle-search-replace-common-match-flag nil)
;; (setq icicle-incremental-completion-flag nil)
;; (setq icicle-region-background "#4f4f4f")
;; (setq icicle-image-files-in-Completions 'nil)
;; ;; turn on icicles by default
;; (icy-mode 1)
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; IDO  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(ido-mode 1) ;; turn on ido mode
(setq ido-everywhere t)
(ido-ubiquitous-mode 1) ;; replace stock completion with ido in most places
(setq ido-enable-flex-matching t)
(flx-ido-mode 1) ;; flexible matching
(global-set-key (kbd "M-x") 'smex) ;; for M-x
(projectile-global-mode t) ;; searching project dirs (including git repos)
;; change projectile to use my utags script instead of ctags
(setq projectile-tags-command "utags %s")
;; set the value of tags-table-list to be safe as long as it is a string
(defun list-of-stringsp (val)
  "test whether each element in list is a string"
  (setq foo t)
  (if (listp val)
      (let (x)
	(setq x val)
	(while x
	  (if (stringp (pop x))
	      ()
	    (setq foo nil))))
    (setq foo nil))
  foo)
(put 'tags-table-list 'safe-local-variable #'list-of-stringsp)
(put 'tags-file-name 'safe-local-variable #'stringp)
;; going to simply run helm default configuration here (don't think I want helm
;; on, but some functions are nice):
(require 'helm-config)
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
;; (run-at-time t 300 'recentf-save-if-changes) ;; run occasionally
(add-hook 'server-visit-hook 'recentf-save-if-changes)
(add-to-list 'recentf-exclude "\\.recentf\\'")
(add-to-list 'recentf-exclude ".*\\.git/.*\\'")
(add-to-list 'recentf-exclude ".*\\.gpg\\'")
(add-to-list 'recentf-exclude ".*\\.ido\\.last\\'")
(add-to-list 'recentf-exclude ".*\\.emacs\\.d/elpa.*\\'")
(add-to-list 'recentf-exclude ".*\\.emacs\\.d/session.*\\'")
(add-to-list 'recentf-exclude ".*TAGS.*\\'")
(add-to-list 'recentf-exclude ".*\\.pgf\\'")
(add-to-list 'recentf-exclude "/tmp.*\\'")
(add-to-list 'recentf-exclude ".*\\.gmm\\'") ;; gmail messages
(global-set-key (kbd "C-c f") 'recentf-open-files)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; edit-server ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; allows emacs to edit html entries from chrome using the "Edit with Emacs"
;; chrome extension.
(when (locate-library "edit-server")
  (require 'edit-server)
  (setq edit-server-new-frame nil)
  (edit-server-start))
;; read on http://www.emacswiki.org/emacs/Edit_with_Emacs that the following was
;; required to work with gmail. Actually it seems that the gmail-message-mode
;; was sufficient https://github.com/Bruce-Connor/gmail-mode/
;; (autoload 'edit-server-maybe-dehtmlize-buffer "edit-server-htmlize" "edit-server-htmlize" t)
;; (autoload 'edit-server-maybe-htmlize-buffer   "edit-server-htmlize" "edit-server-htmlize" t)
;; (add-hook 'edit-server-start-hook 'edit-server-maybe-dehtmlize-buffer)
;; (add-hook 'edit-server-done-hook  'edit-server-maybe-htmlize-buffer)
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
;; (global-ede-mode 1)
;; (ede-enable-generic-projects)
(semanticdb-enable-gnu-global-databases 'c-mode)
(semanticdb-enable-gnu-global-databases 'c++-mode)
(setq-mode-local c-mode semanticdb-find-default-throttle
                      '(project local unloaded system recursive))
(setq-mode-local c++-mode semanticdb-find-default-throttle
                      '(project local unloaded system recursive))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



