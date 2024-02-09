;;; -*- lexical-binding: t -*-

;; System
(let ((normal-gc-cons-threshold (* 20 1024 1024))
      (init-gc-cons-threshold (* 128 1024 1024)))
  (setq gc-cons-threshold init-gc-cons-threshold)
  (add-hook 'emacs-startup-hook
	    (lambda () (setq gc-cons-threshold normal-gc-cons-threshold))))

(setq site-lisp-dirs (directory-files (expand-file-name "site-lisp" user-emacs-directory) t directory-files-no-dot-files-regexp))
(dolist (d site-lisp-dirs)
  (add-to-list 'load-path d))

(defun sm/in-load-path-p (package)
  (let ((present nil))
    (dolist (p load-path present)
      (when (string-suffix-p package p)
	(setq present t)))))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(setq custom-file (locate-user-emacs-file "custom.el"))


;; Packages
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(use-package exec-path-from-shell
  :ensure t
  :config (when (or (memq window-system '(mac ns x))
		    (daemonp))
	    (exec-path-from-shell-initialize)))

(use-package magit
  :ensure t)

(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package yaml-mode
  :ensure t)


;; Tree-sitter
(when (boundp 'treesit-language-source-alist)
  (dolist (l treesit-language-source-alist)
    (when (not (treesit-language-available-p (nth 0 l)))
      (treesit-install-language-grammar (nth 0 l)))))


;; Eglot
(add-hook 'eglot-managed-mode-hook
	  (lambda () 
	    (define-key eglot-mode-map (kbd "C-c f") 'eglot-format)
	    (define-key eglot-mode-map (kbd "C-c h") 'eldoc)
	    (define-key eglot-mode-map (kbd "C-c o") 'eglot-code-action-organize-imports)
	    (define-key eglot-mode-map (kbd "C-c r") 'eglot-rename)
	    (define-key eglot-mode-map (kbd "<f6>") 'xref-find-definitions)))

(setq eglot-autoshutdown t
      eldoc-echo-area-use-multiline-p nil)


;; Go
(autoload 'go-mode "go-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))

;; see https://github.com/golang/tools/blob/master/gopls/doc/emacs.md
(require 'project)
(defun project-find-go-module (dir)
  (when-let ((root (locate-dominating-file dir "go.mod")))
    (cons 'go-module root)))
(cl-defmethod project-root ((project (head go-module)))
  (cdr project))
(add-hook 'project-find-functions #'project-find-go-module)


;; Common Lisp
(when (sm/in-load-path-p "sly")
  (require 'sly-autoloads)
  (setq inferior-lisp-program "sbcl"))


;; Keybinds
(global-set-key (kbd "M-z") 'zap-up-to-char)
(global-set-key (kbd "C-c /") 'comment-or-uncomment-region)
(global-set-key (kbd "C-S-V") 'scroll-down-command)


;; Customizations
(defalias 'yes-or-no-p 'y-or-n-p)
(setq auto-save-default nil
      bookmark-save-flag 1
      completion-ignore-case t
      confirm-kill-processes nil
      inhibit-startup-message t
      inhibit-splash-screen t
      make-backup-files nil
      network-security-level 'high
      org-completion-use-ido t
      read-buffer-completion-ignore-case t
      read-file-name-completion-ignore-case t
      ring-bell-function 'ignore
      word-wrap nil)
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(column-number-mode t)
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

(defun sm/prog-mode-hooks ()
  (display-line-numbers-mode 1))
(add-hook 'prog-mode-hook 'sm/prog-mode-hooks)

;; Custom file
(when (file-exists-p custom-file)
  (load custom-file))
