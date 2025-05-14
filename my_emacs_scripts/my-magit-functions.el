(defgroup my/gitlint nil
  "Customization group for GitLint-related configurations."
  :group 'tools
  :prefix "my/gitlint-")

(defcustom my/gitlint-executable "gitlint"
  "Path to the gitlint executable."
  :type 'string
  :group 'my/gitlint)

(defcustom my/gitlint-pyenv-version nil
  "Pyenv version to use with gitlint. Set to nil to not configure pyenv."
  :type '(choice
          (const :tag "None" nil)
          (string :tag "Pyenv version"))
  :group 'my/gitlint)

(defcustom my/gitlint-add-debug-flag nil
  "Enable or disable adding the --debug flag to gitlint."
  :type 'boolean
  :group 'my/gitlint)

(defun my/run-gitlint-after-commit ()
  "Run gitlint after finishing a commit. Reject the commit if gitlint fails."
  (let ((default-directory (magit-toplevel)) ;; Navigate to repository root
        (process-environment (copy-sequence process-environment)) ;; Copy environment variables
        (commit-message-file (expand-file-name ".git/COMMIT_EDITMSG" (magit-toplevel))) ;; Commit message file
        (output-buffer (get-buffer-create "*gitlint-output*")) ;; Create/reuse output buffer
        (gitlint-command (list my/gitlint-executable))) ;; Gitlint base command

    ;; Set PYENV_VERSION if specified
    (when my/gitlint-pyenv-version
      (setenv "PYENV_VERSION" my/gitlint-pyenv-version))

    ;; Add --debug flag if applicable
    (when my/gitlint-add-debug-flag
      (setq gitlint-command (append gitlint-command '("--debug"))))

    ;; Add commit message filename argument
    (setq gitlint-command (append gitlint-command (list "--msg-filename" commit-message-file)))

    ;; Prepare output buffer
    (with-current-buffer output-buffer
      (let ((inhibit-read-only t))
        (erase-buffer)) ;; Clear buffer contents
      (special-mode)
      (local-set-key (kbd "q") #'quit-window) ;; Allow quitting if displayed
      (message "*gitlint-output* buffer prepared."))

    ;; Temporarily disable read-only mode for process writing
    (with-current-buffer output-buffer
      (setq-local inhibit-read-only t)) ;; Disable read-only locally during gitlint process

    ;; Run gitlint against the commit message
    (if (and (file-exists-p commit-message-file) ;; Ensure commit message exists
             (= (apply #'call-process (car gitlint-command)
                       nil output-buffer t (cdr gitlint-command)) 0))
        ;; Success case: Passed validation
        (progn
          (message "Commit passed gitlint checks."))
      ;; Failure case: Validation failed - display output buffer
      (with-current-buffer output-buffer
        (display-buffer output-buffer) ;; Show errors
        ;; Revert buffer to read-only
        (special-mode))

      ;; Optionally undo commit
      (if (yes-or-no-p "Commit message did not pass gitlint rules. Undo commit?")
          (progn
            (magit-run-git "reset" "--soft" "HEAD~1")
            (magit-refresh)
            (message "Commit undone due to failed gitlint checks."))
        (message "Commit retained despite failed gitlint checks.")))))

(provide 'my-magit-functions)
