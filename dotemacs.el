
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SETUP MELPA/PACKAGE.EL ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
;; add org-mode packages:
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(package-initialize)

;; tools for benchmarking startup:
;; (require 'ctable)
;; (require 'benchmark-init)
;; (benchmark-init/install)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EMACS PERFORMED CUSTOMIZATIONS ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; put all of emacs' customizations in a separate file
(setq custom-file "~/.emacs.d/custom.el")
;; load custom file... if it doesn't exist, don't throw an error
(load custom-file 'noerror)



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
;; (require 'god-mode)
;; (global-set-key [f2] 'god-local-mode)
;; (global-set-key [f7] 'kill-ring-save)
;; (global-set-key [f8] 'yank)
;; (global-set-key [f9] 'yank-pop)
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



;;;;;;;;;;;;;;;;;;;;;;;;
;; MY CUSTOM SETTINGS ;;
;;;;;;;;;;;;;;;;;;;;;;;;
;; my dwim keybindings:
(require 'my-dwim-functions)
(global-set-key (kbd "M-s o") 'my/occur-dwim)
(global-set-key (kbd "M-;") 'my/comment-dwim)
;; (define-key isearch-mode-map (kbd "<backspace>") 'my/delete-nonmatch-isearch)
(global-set-key [remap fill-paragraph] #'my/fill-paragraph-dwim)
;; add a function for re-setting variables that come from the environment:
(require 'my-update-environment)
;; add functions for shifting individual cells in org tables:
(require 'my-org-custom-functions)
(add-hook 'org-mode-hook
 '(lambda ()
    (local-set-key (kbd "M-s-<up>") 'my/org-table-move-single-cell-up)
    (local-set-key (kbd "M-s-<down>") 'my/org-table-move-single-cell-down)
    (local-set-key (kbd "M-s-<left>") 'my/org-table-move-single-cell-left)
    (local-set-key (kbd "M-s-<right>") 'my/org-table-move-single-cell-right)))



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
(load-theme 'tangotango t)
(when (require 'highlight-indentation nil 'noerror)
  (set-face-background 'highlight-indentation-face "#778899")
  (set-face-background 'highlight-indentation-current-column-face "#2f4f4f"))
;; disable scroll bars
(toggle-scroll-bar -1)
(set-scroll-bar-mode nil) 
;; use gutter to display buffer position
(setq-default indicate-buffer-boundaries 'left)
(setq-default indicate-empty-lines +1)
;; add system clipboard entries to kill ring before overwriting:
(setq save-interprogram-paste-before-kill t)
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

(defun set/my-custom-window-settings ()
  (toggle-scroll-bar -1)
  (set-scroll-bar-mode nil) 
  (set-frame-width (selected-frame) 102)
  (set-frame-height (selected-frame) 48)
)

(defun set/my-custom-terminal-settings ()
  "run any commands specific to no-window mode"
  )

(add-hook 'after-make-frame-functions 'run-after-make-frame-hooks)
(add-hook 'after-init-hook
	  (lambda () (run-after-make-frame-hooks (selected-frame))))
(add-hook 'after-make-window-system-frame-hooks
	  'set/my-custom-window-settings)
(add-hook 'after-make-console-frame-hooks
	  'set/my-custom-terminal-settings)

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
(global-set-key (kbd "<C-mouse-4>") 'zoom-in)
(global-set-key (kbd "<C-mouse-5>") 'zoom-out)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MISCELLANEOUS BEHAVIORS OF BUILT IN PACKAGES ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; disable backup files
(setq make-backup-files nil)
;; enable scroll-left command
(put 'scroll-left 'disabled nil)
;; Enter also indents in cc-mode
(add-hook 'c-initialization-hook 'electric-indent-mode)
;; Choose default cc-mode styles
(setq c-default-style '((other . "linux")))
(setq c-basic-offset 4)
(c-set-offset 'comment-intro 0)
;; set default tab width:
(setq-default tab-width 4)
;; if dtrt-indent is available, we will enable it for C and C++ buffers
(when (require 'dtrt-indent nil 'noerror)
  (add-hook 'c-mode-common-hook
	(lambda () (dtrt-indent-mode 1)))
  (add-hook 'c++-mode-common-hook
	(lambda () (dtrt-indent-mode 1))))
;; set tabbing in lisp mode:
(setq-default lisp-indent-offset 2)
;; setup clang-format for projects that have a .clang_format file. Borrowed
;; following snippets from here:
;; https://eklitzke.org/smarter-emacs-clang-format
;; Note, on current system I have built emacs26 from source and installed it
;; into /usr/local/share, but the clang-format package that I install from
;; apt-get installs the clang-format.el file to /usr/share, and my
;; built-from-source emacs doesn't search there by default. I fixed this by
;; providing a symbolic link in ~/.emacs.d
(defun clang-format-buffer-smart ()
  "Reformat buffer if .clang-format exists in the projectile root."
  (when (f-exists? (expand-file-name ".clang-format" (projectile-project-root)))
    (clang-format-buffer)))
(defun my/clang-format-region ()
  "Call `clang-format-region', but if prefix arg is passed, call `clang-format-buffer'"
  (interactive)
  (if (region-active-p)
	(clang-format-region (region-beginning) (region-end))
	(clang-format-buffer)))
(when (require 'clang-format nil 'noerror)
  (defun clang-format-bindings-c ()
	(define-key c-mode-map (kbd "C-M-\\") 'my/clang-format-region))
(defun clang-format-bindings-c++ ()
  (define-key c++-mode-map (kbd "C-M-\\") 'my/clang-format-region))
(add-hook 'c-mode-hook   'clang-format-bindings-c)
(add-hook 'c++-mode-hook 'clang-format-bindings-c++))
;;   (add-hook 'c-mode-hook
;; 	(lambda () (add-hook 'before-save-hook #'clang-format-buffer-smart nil 'local)))
;;   (add-hook 'c++-mode-hook
;; 	(lambda () (add-hook 'before-save-hook #'clang-format-buffer-smart nil 'local))))
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
;; modify mark pop to allow C-SPC to repeatedly pop after one C-u C-SPC
(setq set-mark-command-repeat-pop t)
;; add tramp functionality:
(require 'tramp)
(setq tramp-default-method "ssh")
(setq remote-file-name-inhibit-cache nil)
(setq vc-ignore-dir-regexp
  (format "%s\\|%s"
	vc-ignore-dir-regexp
	tramp-file-name-regexp))
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
;; allow wdired to change file permissions
(setq wdired-allow-to-change-permissions t)
;; add keybinding for activating wdired-mode
(add-hook 'dired-mode-hook 
  (lambda ()
	(define-key dired-mode-map (kbd "C-c C-q") 'wdired-change-to-wdired-mode)))
;; enable unzipping within Dired
(eval-after-load "dired-aux"
  '(add-to-list 'dired-compress-file-suffixes 
	 '("\\.zip\\'" ".zip" "unzip")))
;; change dired file associations:
(setq dired-guess-shell-alist-user
  '(("\\.pdf\\'" "evince")
	 ("\\.tex\\'" "pdflatex")
	 ("\\.ods\\'\\|\\.xlsx?\\'\\|\\.docx?\\'\\|\\.csv\\'\\|\\.pptx?\\'" "libreoffice")))
;; use ibuffer by default instead of list-buffers
(defalias 'list-buffers 'ibuffer)
;; set abbrev mode settings
(setq save-abbrevs nil)
;; prevent cursor from moving over prompts in minibuffer
(setq minibuffer-prompt-properties 
  (quote
	(read-only t point-entered minibuffer-avoid-prompt cursor-intangible t face minibuffer-prompt)))
;; set emacs completions to be case-insensitive
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)
;; turn on global-auto-revert mode
(global-auto-revert-mode 1)
;; turn on markdown mode for certain files
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode)) ;; gfm = github-flavored
;; automatically make hash-bang files executable
(add-hook 'after-save-hook
  'executable-make-buffer-file-executable-if-script-p)
;; always remember where I was:
(setq-default save-place t)
(require 'saveplace)
;; turn on show-paren mode
(show-paren-mode)
;; add function for running multi-occur on dired marked files:
(defun dired-do-multi-occur (regexp)
  "Run `multi-occur' with REGEXP on all marked files."
  (interactive (list (read-regexp "Regexp: ")))
  (multi-occur (mapcar 'find-file-noselect (dired-get-marked-files)) regexp))
;; settings for the compile command:
(setq compilation-ask-about-save nil)
;; (setq compilation-scroll-output 'next-error)
;; (setq compilation-skip-threshold 2)
;; always use y/n instead of yes/no
(fset 'yes-or-no-p 'y-or-n-p)
;; set isearch to use "flexible" matching (space in search is treated like any character)
(setq search-whitespace-regexp ".*?")



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
(global-set-key (kbd "C-M->") 'mc/unmark-next-like-this)
(global-set-key (kbd "C-M-<") 'mc/unmark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "C-c C->") 'mc/mark-all-dwim)
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
(global-set-key (kbd "C-x F") 'my/find-file-as-root)
(global-set-key (kbd "C-x V") 'my/find-alternative-file-with-sudo)
;; enable fancy-narrow from elpa
(fancy-narrow-mode 1)
;; customize ace-jump-mode from elpa
;; (define-key global-map (kbd "s-a") 'ace-jump-mode)
(setq avy-keys 
      '(?a ?s ?d ?e ?f ?h ?j ?k ?l ?n ?m ?v ?r ?u))
(setq aw-keys '(?a ?s ?d ?f ?j ?k ?l))
(global-set-key (kbd "s-a") 'avy-goto-word-1)
(global-set-key (kbd "s-c") 'avy-goto-char)
(global-set-key (kbd "s-w") 'ace-window)
(global-set-key (kbd "s-l") 'avy-goto-line)
;; add bindings for ace link
(when (require 'ace-link nil 'noerror)
  (ace-link-setup-default)
  (add-hook 'org-mode-hook
	(lambda () (define-key org-mode-map (kbd "s-f") 'ace-link-org))))
;; should we show the ace-window key in modeline?
(ace-window-display-mode t)
(set-face-attribute 'aw-leading-char-face nil :foreground "deep sky blue" :weight 'bold :height 3.0)
(setq aw-background nil)
(when (require 'anzu nil 'noerror)
  (global-anzu-mode)
  (global-set-key (kbd "M-%") 'anzu-query-replace)
  (global-set-key (kbd "C-M-%") 'anzu-query-replace-regexp))
(when (require 'diminish nil 'noerror)
  (eval-after-load "anzu" '(diminish 'anzu-mode))
  (eval-after-load "fancy-narrow" '(diminish 'fancy-narrow-mode))
  (eval-after-load "page-break-lines" '(diminish 'page-break-lines-mode))
  (eval-after-load "auto-revert" '(diminish 'auto-revert-mode))
  (eval-after-load "beacon" '(diminish 'beacon-mode))
  (eval-after-load "which-key" '(diminish 'which-key-mode)))
;; load hydras
(when (require 'hydra nil 'noerror)
  (require 'my-hydras))
;; if swiper is installed, let's use it:
(when (require 'swiper nil 'noerror)
  (global-set-key (kbd "C-s-s") 'swiper)
  (setq ivy-display-style 'fancy)
  (defun bjm-swiper-recenter (&rest args)
	"recenter display after swiper"
	(recenter))
  (advice-add 'swiper :after #'bjm-swiper-recenter))
;; if beacon is installed use it:
(when (require 'beacon nil 'noerror)
  (beacon-mode 1)
  (setq beacon-color "yellow green")
  (setq beacon-blink-when-point-moves 10))
;; page break lines mode:
(when (require 'page-break-lines nil 'noerror)
  (global-page-break-lines-mode))
;; which-key mode
(when (require 'which-key nil 'noerror)
  (which-key-mode))



;; EXEC-PATH-FROM-SHELL PACKAGE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ensure environment variables stay consistent even if launched from a gui
;; button
(require 'exec-path-from-shell)
(add-to-list 'exec-path-from-shell-variables "PYTHONPATH")
(when window-system (exec-path-from-shell-initialize))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; SMARTPARENS MODE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; must be installed via elpa, or (require 'smartmparens)
(when (require 'smartparens nil
		'noerror) (show-smartparens-global-mode +1))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; WEB MODE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (require 'smartparens nil 'noerror)
  (setq web-mode-enable-auto-closing t)
  (setq web-mode-enable-auto-quoting t)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-current-element-highlight t)
  ;; (setq web-mode-enable-current-column-highlight t)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; COMPANY MODE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'after-init-hook 'global-company-mode)
(company-quickhelp-mode t)
(when (require 'company-statistics nil 'noerror)
  (add-hook 'after-init-hook 'company-statistics-mode))
(when (require 'company-try-hard nil 'noerror)
  (define-key company-active-map (kbd "C-j") #'company-try-hard)
  (define-key global-map (kbd "C-S-j") #'company-try-hard))
;; Do not show pop-up automatically
(customize-set-variable 'company-quickhelp-delay nil)
;; Define binding for showing pop-up manually in company-active-map instead of
;; company-quickhelp-mode-map; this activates it only when we want completion.
(with-eval-after-load 'company
  (define-key company-active-map (kbd "C-?") #'company-quickhelp-manual-begin))
;; bind extra key to force starting company-completion
(define-key global-map (kbd "<C-tab>") 'company-complete)
;; Setup YCMD:
(require 'company-ycmd)
(set-variable 'ycmd-server-command `("python", (file-truename "~/src/ycmd/ycmd")))
(set-variable 'ycmd-global-config (file-truename "~/src/ycmd/ycmd/global_conf.py"))
;; define company backends for commonly used major modes:
(eval-after-load 'company
  '(progn
	 ;; company and jedi:
	 (defun my/company-python-mode-hook ()
	   (set (make-local-variable 'company-backends) '(company-jedi))
	   (add-to-list 'company-backends 'company-dabbrev-code t)
	   (add-to-list 'company-backends 'company-yasnippet t))
	 (add-hook 'python-mode-hook 'my/company-python-mode-hook)
	 ;; company and C/C++
	 (defun my/company-c-mode-hook ()
	   (set (make-local-variable 'company-backends)
	 	 '(company-ycmd))
	   (add-to-list 'company-backends 'company-yasnippet t)
	   (ycmd-mode))
	 (add-hook 'c-mode-common-hook 'my/company-c-mode-hook)
	 (add-hook 'c++-mode-common-hook 'my/company-c-mode-hook)
	 ;; company and C/C++
	 ;; (defun my/company-c-mode-hook ()
	 ;;   ;; (irony-mode)
	 ;;   (set (make-local-variable 'company-backends)
	 ;; 	 '((company-irony company-etags company-gtags company-c-headers company-dabbrev-code)))
	 ;;   (add-to-list 'company-backends 'company-yasnippet t))
	 ;; (add-hook 'c-mode-common-hook 'my/company-c-mode-hook)
	 ;; (add-hook 'c++-mode-common-hook 'my/company-c-mode-hook)
	 ;; company and LaTeX:
	 (defun my/company-latex-mode-hook ()
	   (set (make-local-variable 'company-backends)
		 '(company-capf company-dabbrev company-ispell company-files company-yasnippet))
	   (company-auctex-init))
	 (add-hook 'LaTeX-mode-hook 'my/company-latex-mode-hook)
	 ;; xml and html:
	 (defun my/company-tml-mode-hook ()
	   (set (make-local-variable 'company-backends)
		 '(company-capf
			(company-web-html company-nxml company-css)
			company-dabbrev-code company-files company-ispell company-yasnippet)))
	 (add-hook 'nxml-mode-hook 'my/company-tml-mode-hook)
	 (add-hook 'html-mode-hook 'my/company-tml-mode-hook)
	 (add-hook 'web-mode-hook 'my/company-tml-mode-hook)
	 ;; CMake
	 ;; (defun my/company-cmake-mode-hook ()
	 ;;   (add-to-list 'company-backends 'company-cmake))
	 ;; (add-hook 'cmake-mode-hook 'my/company-cmake-mode-hook)
	 ;; elisp:
	 (defun my/company-elisp-mode-hook ()
	   (set (make-local-variable 'company-backends)
			'((company-capf company-keywords company-dabbrev-code company-yasnippet)))
	   (add-to-list 'company-backends 'company-files t))
	 (add-hook 'emacs-lisp-mode-hook 'my/company-elisp-mode-hook)
	 ;; text mode
	 (defun my/company-text-mode-hook ()
	   (set (make-local-variable 'company-backends) '((company-dabbrev company-ispell company-files))))
	 (add-hook 'text-mode-hook 'my/company-text-mode-hook)
	 ;; web mode
	 ;; (defun my/company-web-mode-hook ()
	 ;;   (set (make-local-variable 'company-backends) '((company-web-html company-dabbrev company-ispell company-files))))
	 ;; (add-hook 'web-mode-hook 'my/company-web-mode-hook)
	 ;; org mode
	 (defun my/company-org-mode-hook ()
	   (set (make-local-variable 'company-backends) '((company-web-html company-css company-dabbrev company-ispell company-files) company-yasnippet)))
	 (add-hook 'org-mode-hook 'my/company-org-mode-hook)))
(defvar my/cmake-ide-enable-flag nil
  "Set to true once we have properly enabled `cmake-ide' in a
  single Emacs session.")
(defun my/cmake-ide-enable ()
  (interactive)
  (when (and (require 'rtags nil 'noerror)
		  (require 'company-rtags nil 'noerror))
	(cmake-ide-setup)
	(setq rtags-completions-enabled t)
	(setq rtags-autostart-diagnostics t)
	(rtags-diagnostics)
	(rtags-start-process-unless-running)
	(define-key c-mode-base-map (kbd "<backtab>") (function company-rtags))
	(setq my/cmake-ide-enable-flag t)))
(defun my/cmake-ide-disable ()
  (interactive)
  (if (eq my/cmake-ide-enable-flag t)
	(progn
	  (setq rtags-completions-enabled nil)
	  (setq rtags-autostart-diagnostics nil)
	  (rtags-stop-diagnostics)
	  (rtags-quit-rdm)
	  (define-key c-mode-base-map (kbd "<backtab>") nil))))
;; company customizations: 
(eval-after-load 'company
  '(progn
     (define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
     (define-key company-active-map (kbd "<tab>") 'company-complete-common-or-cycle)
	 (define-key company-active-map (kbd "S-TAB") 'company-select-previous)
     (define-key company-active-map (kbd "<backtab>") 'company-select-previous)
	 (define-key company-active-map (kbd "C-n") '(lambda () (interactive) (company-complete-common-or-cycle 1)))
	 (define-key company-active-map (kbd "C-p") '(lambda () (interactive) (company-complete-common-or-cycle -1)))
	 (setq company-idle-delay 0.6)
	 (setq company-minimum-prefix-length 2)))
(yas-global-mode)

;; 
;; ;; AUTOCOMPLTE MODE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Add autocomplete package:
;; (require 'auto-complete-config)
;; ;; (ac-config-default)
;; ;; (auto-complete-mode)
;; ;; (define-key global-map (kbd "<C-tab>") 'ac-fuzzy-complete)
;; (setq ac-ignore-case nil)
;; (ac-flyspell-workaround)
;; ;; enable yasnippet with ac:
;; (set-default 'ac-sources
;;   '(ac-source-abbrev
;; 	 ac-source-dictionary
;; 	 ac-source-yasnippet
;; 	 ac-source-words-in-buffer
;; 	 ac-source-words-in-same-mode-buffers
;; 	 ;; ac-source-semantic
;; 	 ))
;; ;; turn on yasnippet by default for all modes
;; ;; (yas-global-mode)
;; ;; (defun my:ac-c-headers-init ()
;; ;;   ;; (require 'auto-complete-c-headers)
;; ;;   (add-to-list 'ac-sources 'ac-source-c-headers))
;; ;; (add-hook 'c++-mode-hook 'my:ac-c-headers-init)
;; ;; (add-hook 'c-mode-hook 'my:ac-c-headers-init)
;; ;; add hook for c-sources in c mode
;; ;; (require 'ac-c-headers)
;; ;; (add-hook 'c-mode-common-hook
;; ;;   (lambda ()
;; ;; 	(add-to-list 'ac-sources 'ac-source-c-headers)))
;; 	;; (add-to-list 'ac-sources 'ac-source-c-header-symbols t)))
;; ;; allow return key to also autocomplete:
;; (define-key ac-completing-map "\C-m" nil)
;; (setq ac-use-menu-map t)
;; (define-key ac-menu-map "\C-m" 'ac-complete)
;; (auto-complete-mode 0)
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;; ROSEMACS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Add functionality for rosemacs
(if (getenv "ROS_DISTRO")
	(let ((rpath (concat "/opt/ros/" (getenv "ROS_DISTRO") "/share/emacs/site-lisp/")))
	  (if (file-directory-p rpath)
		(add-to-list 'load-path rpath)
		(message (format "Could not find ROS elisp path: %s" rpath))))
  (message "No ROS_DISTRO environment variable"))
(if (require 'rosemacs nil 'noerror)
  (progn
	(invoke-rosemacs)
	;; add a keymap for using rosemacs commands
	(global-set-key "\C-x\C-r" ros-keymap)
	(message "rosemacs successfully loaded"))
  (message "rosemacs could not be imported"))
;; since ROS Groovy, catkin inserts ansi-color sequences into the output of the
;; compilation buffer... let's fix that
(ignore-errors
  (require 'ansi-color)
  (defun colorize-compilation-buffer ()
    (when (eq major-mode 'compilation-mode)
      (ansi-color-apply-on-region (point-min) (point-max))))
  (add-hook 'compilation-filter-hook 'colorize-compilation-buffer))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; LATEX ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Add Latex functionality
(require 'my-auctex-plugins)
(auctex-latexmk-setup)
(setq-default TeX-master nil)
(setq TeX-parse-self t)
(setq TeX-auto-save t)
(setq TeX-electric-sub-and-superscript t)
(setq TeX-save-query nil) 
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
;; add common TeX variables as safe for local vars at end of doc
(add-to-list 'safe-local-variable-values '(TeX-auto-parse-length . 999999))
(add-to-list 'safe-local-variable-values '(TeX-auto-regexp-list . TeX-auto-full-regexp-list))
(add-to-list 'safe-local-variable-values '(TeX-parse-self . t))
(add-to-list 'safe-local-variable-values '(TeX-auto-save . t))
(add-to-list 'safe-local-variable-values '(TeX-source-correlate-method . synctex))
;; customize previewing:
(setq
  preview-auto-cache-preamble t
  preview-gs-options (quote ("-q" "-dNOSAFER" "-dNOPAUSE" "-DNOPLATFONTS" "-dPrinted" "-dTextAlphaBits=4" "-dGraphicsAlphaBits=4"))
  preview-scale-function 1.25)
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
;; (require 'auto-complete-auctex)
;; binding for compiling beamer frames
(add-hook 'LaTeX-mode-hook
  (lambda () (define-key LaTeX-mode-map (kbd "C-M-x") 'tex-beamer-frame)))
;; move by blank lines in LaTeX-mode:
(add-hook 'LaTeX-mode-hook
  (lambda () (progn
			   (define-key LaTeX-mode-map
				 (kbd "<C-down>") 'skip-to-next-blank-line)
			   (define-key LaTeX-mode-map
				 (kbd "<C-up>") 'skip-to-previous-blank-line))))
;; turn on auto-fill for LaTeX mode:
(add-hook 'LaTeX-mode-hook 'auto-fill-mode)
;; setup fonts for math mode:
(defface my/unimportant-latex-face
  '((t :height 0.6
       :inherit font-lock-comment-face))
  "Face used on less relevant math commands.")
(font-lock-add-keywords
 'latex-mode
 `((,(rx "\\" (or (any ",.!;")
                  (and (or "left" "right")
                       symbol-end)))
    0 'my/unimportant-latex-face prepend))
 'end)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;; PYTHON ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; jedi configurations:
;; (setq jedi:setup-function nil)
;; (add-hook 'python-mode-hook 'jedi:setup)
;; (add-hook 'jedi-mode-hook 'jedi-direx:setup)
;; (setq jedi:complete-on-dot t)
(add-hook 'python-mode-hook
  (lambda ()
	;; make python mode recognize _ as a word separator
	(modify-syntax-entry ?_ "_" python-mode-syntax-table)
	;; set docstring formatting options
	(setq python-fill-docstring-style 'django)
	;; comment region function
	(local-set-key (kbd "C-c #") 'comment-region)
	;; python tab-width
	(setq python-indent-offset 4)
	(setq tab-width 4)
	(highlight-indentation-mode)
	(highlight-indentation-current-column-mode)
	;; disable eldoc mode
	(eldoc-mode 0)
	(setq electric-indent-chars (delq ?: electric-indent-chars))
	(setq jedi:setup-function nil)
	(jedi:setup)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;; FLYSPELL ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Turn on FlySpell for some things by default
(add-hook 'c-mode-hook (lambda () (flyspell-prog-mode)))
(add-hook 'c++-mode-hook (lambda () (flyspell-prog-mode)))
(add-hook 'nxml-mode-hook (lambda () (flyspell-mode-off)))
(add-hook 'python-mode-hook (lambda () (flyspell-prog-mode)))
(add-hook 'sh-mode-hook (lambda () (flyspell-prog-mode)))
(add-hook 'emacs-lisp-mode-hook (lambda () (flyspell-prog-mode)))
(setq flyspell-use-meta-tab nil)
(add-hook 'text-mode-hook 'turn-on-flyspell)
(add-hook 'change-log-mode-hook 'turn-on-flyspell)
(add-hook 'LaTeX-mode-hook 'turn-on-flyspell)
(add-hook 'LaTeX-mode-hook (function (lambda () (setq ispell-parser 'tex))))
(add-hook 'texinfo-mode
  '(lambda ()
	 (setq flyspell-generic-check-word-p 'texinfo-mode-flyspell-verify)))
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
(setq
  matlab-comment-line-s "% "
  matlab-comment-on-line-s "% "
  matlab-comment-region-s "% "
  matlab-shell-ask-MATLAB-for-completions nil)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; 
;; ;; PROCESSING ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Add processing-emacs mode
;; (add-to-list 'load-path "~/src/emacs_stuff/processing-emacs/")
;; (autoload 'processing-mode "processing-mode" "Processing mode" t)
;; (add-to-list 'auto-mode-alist '("\\.pde$" . processing-mode))
;; (setq processing-location "~/processing-2.0.1/")
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; 
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



;; IDO, Projectile, Helm, Org ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(ido-mode 1) ;; turn on ido mode
(setq ido-everywhere t)
(ido-ubiquitous-mode 1) ;; replace stock completion with ido in most places
(setq ido-enable-flex-matching t)
(flx-ido-mode 1) ;; flexible matching
;; Use smex by default, but still provide a shortcut for regular M-x:
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c M-x") 'execute-extended-command)
(projectile-mode t) ;; searching project dirs (including git repos)
;; turn on projectile caching for faster functionality in large repos
(setq projectile-enable-caching t)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(setq org-completion-use-ido t)
;; change projectile to use fd if it is available:
;; (if (executable-find "fd")
;;   (progn
;; 	(set-variable 'projectile-git-command )
;; have ido use current window when switching buffers
(setq ido-default-buffer-method 'selected-window)
;; change projectile to use my utags script instead of ctags
;; (setq projectile-tags-command "utags %s")
(setq projectile-tags-command "ctags-exuberant -Re -f \"%s\" %s")
;; (setq projectile-mode-line '(:eval (with-timeout (0.2 " P[ -- ]")
;;                                      (format " P[ %s ]" (projectile-project-name)))))
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
(require 'helm)
(require 'helm-config)
(require 'helm-swoop)
(setq helm-swoop-split-direction 'split-window-horizontally)
(setq
  helm-apropos-fuzzy-match t
  helm-buffers-fuzzy-matching t
  helm-imenu-fuzzy-match t
  helm-lisp-fuzzy-completion t
  helm-locate-fuzzy-matching t
  helm-M-x-fuzzy-match t
  helm-recentf-fuzzy-match t
  helm-semantic-fuzzy-match t
  )
;; rebind tab to run persistent action and C-z to select action
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
(define-key helm-map (kbd "C-z")  'helm-select-action)
;; change helm prefix
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-set-key [f2] 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))
;; helm swoop keybindings:
(global-set-key (kbd "C-c h s") 'helm-swoop)
(global-set-key (kbd "C-c h S") 'helm-surfraw)
(define-key helm-swoop-map (kbd "C-r") 'helm-previous-line)
(define-key helm-swoop-map (kbd "C-s") 'helm-next-line)
(define-key helm-multi-swoop-map (kbd "C-r") 'helm-previous-line)
(define-key helm-multi-swoop-map (kbd "C-s") 'helm-next-line)
(define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)
(define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)
;; ignore boring files:
(setq helm-ff-skip-boring-files t)
(setq helm-boring-file-regexp-list
  '("\\.git$" "\\.hg$" "\\.svn$" "\\.CVS$" "\\._darcs$" "\\.la$" "\\.o$" "~$"
    "\\.so$" "\\.a$" "\\.elc$" "\\.fas$" "\\.fasl$" "\\.pyc$" "\\.pyo$"))
(setq helm-boring-buffer-regexp-list
  '("\\` " "\\*helm" "\\*helm-mode" "\\*Echo Area" "\\*tramp" "\\*Minibuf"
	 "\\*epc" "\\*ros" "\\*CEDET"))
;; other helm keybindings:
(global-set-key (kbd "C-c h C-x b") 'helm-mini)
;; use org bullets if installed:
(when (require 'org-bullets nil 'noerror)
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
;; setup languages to use with org-babel:
(org-babel-do-load-languages
  'org-babel-load-languages
  '((python . t)
	 (emacs-lisp . t)
	 (shell . t)
	 (C . t)))
;; set org to fontify languages:
(setq org-src-fontify-natively t)
;; setup wgrep mode
(add-hook 'ag-mode-hook #'wgrep-ag-setup)
;; Workaround for issue where the edits in `wgrep' don't apply
;; https://github.com/Wilfred/ag.el/issues/119
;; actually prefer the grouped matches but wgrep is so useful
(setq ag-group-matches nil)
;; Don't generate a lot of ag buffers:
(setq ag-reuse-buffers t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; BUFFER MOVE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'buffer-move)
(global-set-key (kbd "<C-S-up>") 'buf-move-up)
(global-set-key (kbd "<C-S-down>") 'buf-move-down)
(global-set-key (kbd "<C-S-left>") 'buf-move-left)
(global-set-key (kbd "<C-S-right>") 'buf-move-right)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; RECENTF CUSTOMIZATIONS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; use recentf to store a list of recent files across sessions:
(require 'recentf)
(setq recentf-max-saved-items 100
  recentf-max-menu-items 40)
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
(add-to-list 'recentf-exclude "^/tmp/.*\\'")
(add-to-list 'recentf-exclude ".*\\.gmm\\'") ;; gmail messages
(add-to-list 'recentf-exclude "/sudo:.*\\'")
(add-to-list 'recentf-exclude "/scp:.*\\'")
(add-to-list 'recentf-exclude "\\.password-store/.*\\'")
(add-to-list 'recentf-exclude "^/dev/shm/.*\\'")
(defun recentf-ido-find-file ()
  "Find a recent file using ido."
  (interactive)
  (let ((file (ido-completing-read "Choose recent file: " recentf-list nil t)))
    (when file
      (find-file file))))
(global-set-key (kbd "C-c f") 'recentf-ido-find-file)
;; (global-set-key (kbd "C-c f") 'recentf-open-files)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; EDIT-SERVER ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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



;; ;; CEDET MODE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'semantic/bovine/gcc)
;; ;; (setq semantic-default-submodes nil)
;; (add-to-list 'semantic-default-submodes 'global-semantic-decoration-mode)
;; (add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)
;; (add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
;; (add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)
;; (semantic-mode 1)
;; (setq my-semantic-inhibited-modes '(latex-mode))
;; (defun my-inhibited-modes-check ()
;;   "Check if current buffer's mode is allowed to have cedet run"
;;   (member major-mode my-semantic-inhibited-modes))
;; (add-to-list 'semantic-inhibit-functions 'my-inhibited-modes-check)
;; ;; (defun my-c-mode-cedet-hook ()
;; ;;   (semantic-idle-summary-mode 1)
;; ;;   (semantic-mru-bookmark-mode 1)
;; ;;   (semantic-highlight-func-mode 1)
;; ;;   (semantic-decoration-mode 1))
;; ;; ;; (add-hook 'c-mode-common-hook
;; ;; ;; 	  '(lambda () (add-hook 'semantic-init-hook 'my-c-mode-cedet-hook t t)))
;; ;; (add-hook 'c-mode-common-hook 'my-c-mode-cedet-hook)
;; ;; (global-ede-mode 1)
;; ;; (ede-enable-generic-projects)
;; (semanticdb-enable-gnu-global-databases 'c-mode)
;; (semanticdb-enable-gnu-global-databases 'c++-mode)
;; (setq-mode-local c-mode semanticdb-find-default-throttle
;;   '(project local unloaded system recursive))
;; (setq-mode-local c++-mode semanticdb-find-default-throttle
;;   '(project local unloaded system recursive))
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

