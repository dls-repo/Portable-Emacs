;; --- Disable GPG signature checks ---
(setq package-check-signature nil)

;; --- Package system ---
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(package-initialize)

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

(display-time-mode 1)

;; Fix for C-u in Normal mode to scroll like Vim
(setq evil-want-C-u-scroll t)

(use-package evil
  :defer 0
  :config
  (evil-mode 1))

;; Optional: make ESC quit prompts everywhere
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package ivy
  :defer 0
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
        enable-recursive-minibuffers t))

(message "Git executable: %s" (executable-find "git"))
(message "Git version:\n%s" (shell-command-to-string "git --version"))

(custom-set-variables
 '(package-selected-packages '(beacon evil ivy)))
(custom-set-faces)
