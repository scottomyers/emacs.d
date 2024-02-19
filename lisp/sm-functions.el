;;; sm-functions.el --- helper functions  -*- lexical-binding: t -*-
(defun sm/in-load-path-p (package)
  (let ((present nil))
    (dolist (p load-path present)
      (when (string-suffix-p package p)
	(setq present t)))))

(provide 'sm-functions)
