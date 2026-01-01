(require 'package)
(setq package-archives
      '(("nongnu-devel" . "https://elpa.nongnu.org/nongnu-devel/")
        ("gnu"         . "https://elpa.gnu.org/packages/")
        ("melpa"       . "https://melpa.org/packages/")))
(package-initialize)
(package-refresh-contents)
;; --- Bootstrap use-package ---
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(use-package beacon
  :defer 0
  :config
  (beacon-mode 1))

(use-package company
  :ensure t
  :init
  (global-company-mode)  ; Enable Company Mode globally
  :config
  (setq company-idle-delay 0.2)  ; Wait 200ms before showing suggestions
  (setq company-minimum-prefix-length 1))  ; Minimum prefix length for suggestions

(global-visual-line-mode 1) ;;allow text wrapping
(electric-indent-mode 1)
(display-time-mode 1)
(global-display-line-numbers-mode 1)
(menu-bar-mode 0)
(tool-bar-mode 0)
(setq org-startup-with-inline-images t)

(use-package zenburn-theme
  :config
  (load-theme 'zenburn t))

(setq evil-want-C-u-scroll t)
(setq evil-want-keybinding nil)
(require 'evil)
(when (require 'evil-collection nil t)
  (evil-collection-init))

(use-package evil
  :defer 0
  :config
  (evil-mode 1))

;; Optional: make ESC quit prompts everywhere
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package gptel
  :ensure t
  :commands gptel
  :config
  (setq gptel-api-key "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")
  (setq gptel-default-mode 'org-mode))

(use-package ivy
  :defer 0
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
        enable-recursive-minibuffers t))

(use-package org
  :ensure t
  :config
  (require 'org-tempo))

;; Do NOT auto-indent Org src blocks
(setq org-src-preserve-indentation t
      org-edit-src-content-indentation 0
      org-adapt-indentation nil
      org-src-tab-acts-natively t)
(setq org-babel-python-command "python3")

(org-babel-do-load-languages
  'org-babel-load-languages
    '((python . t)
      (emacs-lisp . t)
      (C . t)))

(use-package flyspell
  :ensure t
  :init
  (setq ispell-program-name "aspell") ;; or "ispell", depending on your preference
  :hook
  (text-mode . flyspell-mode)          
  (prog-mode . flyspell-prog-mode))    

(use-package langtool
  :ensure t
  :defer t
  :init
  (setq langtool-language-tool-jar "~/LanguageTool-6.6/languagetool-server.jar") ;; Set the jar path
  (global-set-key (kbd "C-c h") 'langtool-check)) ;; Keybinding for grammar checking

(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "C-<left>") #'evil-window-left)
  (define-key evil-normal-state-map (kbd "C-<up>") #'evil-window-up)
  (define-key evil-normal-state-map (kbd "C-<down>") #'evil-window-down)
  (define-key evil-normal-state-map (kbd "C-<right>") #'evil-window-right))
