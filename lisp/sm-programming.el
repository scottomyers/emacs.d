;;; -*- lexical-binding: t -*-

(when (boundp 'treesit-language-source-alist)
  (dolist (l treesit-language-source-alist)
    (when (not (treesit-language-available-p (nth 0 l)))
      (treesit-install-language-grammar (nth 0 l)))))

(add-hook 'eglot-managed-mode-hook
	  (lambda () 
	    (define-key eglot-mode-map (kbd "C-c e f") 'eglot-format)
	    (define-key eglot-mode-map (kbd "C-c e h") 'eldoc)
	    (define-key eglot-mode-map (kbd "C-c e o") 'eglot-code-action-organize-imports)
	    (define-key eglot-mode-map (kbd "C-c e r") 'eglot-rename)
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

(provide 'sm-programming)
