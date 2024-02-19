;;; sm-custom.el --- keybindings and customizations  -*- lexical-binding: t -*-

;; keybindings
(global-set-key (kbd "C-c r") 'revert-buffer)
(global-set-key (kbd "M-z") 'zap-up-to-char)
(global-set-key (kbd "C-c /") 'comment-or-uncomment-region)
(global-set-key (kbd "C-S-V") 'scroll-down-command)

;; 
(setq custom-file (locate-user-emacs-file "custom.el"))
(defalias 'yes-or-no-p 'y-or-n-p)
(setq auto-save-default nil
      bookmark-save-flag 1
      completion-ignore-case t
      confirm-kill-processes nil
      inhibit-splash-screen t
      inhibit-startup-message t
      isearch-lazy-count t
      make-backup-files nil
      network-security-level 'high
      org-completion-use-ido t
      read-buffer-completion-ignore-case t
      read-file-name-completion-ignore-case t
      ring-bell-function 'ignore
      search-whitespace-regexp ".*?"
      use-dialog-box nil
      word-wrap nil)
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(column-number-mode t)
(global-auto-revert-mode 1)
(global-display-line-numbers-mode 1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(defun sm/gui-customizations ()
  (let ((time-of-day (nth 3 (split-string (current-time-string)))))
    (if (or (string-lessp time-of-day "07:00:00")
	    (string-greaterp time-of-day "20:00:00"))
	(load-theme 'modus-vivendi)
      (load-theme 'modus-operandi))))

(defun sm/terminal-customizations ()
  (menu-bar-mode -1))

(if (or (display-graphic-p) (daemonp))
    (sm/gui-customizations)
  (sm/terminal-customizations))

(defun sm/mac-customizations ())
(when (or (memq window-system '(mac ns x))
	  (daemonp))
  (sm/mac-customizations))

(when (file-exists-p custom-file)
  (load custom-file))

(provide 'sm-custom)
