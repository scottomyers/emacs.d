;;;  -*- lexical-binding: t -*-

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(use-package company
  :ensure t
  :config (global-company-mode))

(use-package exec-path-from-shell
  :ensure t
  :config (when (or (memq window-system '(mac ns x))
		    (daemonp))
	    (exec-path-from-shell-initialize)))

(use-package go-mode
  :ensure t)

(use-package magit
  :ensure t)

(use-package markdown-mode
  :ensure t)

(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package yaml-mode
  :ensure t)

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

(provide 'sm-packages)
