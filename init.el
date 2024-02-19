;;; -*- lexical-binding: t -*-
(let ((normal-gc-cons-threshold (* 20 1024 1024))
      (init-gc-cons-threshold (* 128 1024 1024)))
  (setq gc-cons-threshold init-gc-cons-threshold)
  (add-hook 'emacs-startup-hook
	    (lambda () (setq gc-cons-threshold normal-gc-cons-threshold))))

(defvar site-lisp-dirs
  (directory-files (expand-file-name "site-lisp" user-emacs-directory) t directory-files-no-dot-files-regexp))

(dolist (d site-lisp-dirs)
  (add-to-list 'load-path d))

(defun sm/in-load-path-p (package)
  (let ((present nil))
    (dolist (p load-path present)
      (when (string-suffix-p package p)
	(setq present t)))))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'sm-packages)
(require 'sm-keybinds)
(require 'sm-custom)
