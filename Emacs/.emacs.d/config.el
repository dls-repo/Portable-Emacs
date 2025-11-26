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

(custom-set-variables
 '(package-selected-packages '(beacon evil ivy)))
(custom-set-faces)

;; ================================
;; Modeline color changes
;; ================================

(defvar my/modeline-modified-color "#1d847c")
(defvar my/modeline-saved-color    "#7b7067")
(defvar my/modeline-default-color  (face-background 'mode-line))

(defun my/update-modeline-color ()
  "Change the mode line color depending on buffer state."
  (let* ((bg (cond
              ((minibufferp) my/modeline-default-color)
              (buffer-read-only my/modeline-saved-color)
              ((buffer-modified-p) my/modeline-modified-color)
              (t my/modeline-default-color))))
    (set-face-background 'mode-line bg)))

(add-hook 'post-command-hook #'my/update-modeline-color)

(display-time-mode 1)

;; Make sure elfeed is installed and loaded
(use-package elfeed
  :ensure t)

;; Elfeed goodies for better UX
(use-package elfeed-goodies
  :ensure t
  :after elfeed
  :config
  (elfeed-goodies/setup)
  (setq elfeed-goodies/log-window-size 0.5))

;; Elfeed-tube for YouTube RSS feeds
(use-package elfeed-tube
  :ensure t
  :after elfeed
  :config
  ;; Path to your org file relative to .emacs.d
  (setq elfeed-tube-org-file
        (expand-file-name "org/elfeed.org" user-emacs-directory))
  ;; Initialize elfeed-tube
  (elfeed-tube-setup)
  ;; Optional: auto-update Elfeed when opening search buffer
  (add-hook 'elfeed-search-mode-hook 'elfeed-update))

;; Fix for C-u in Normal mode to scroll like Vim
(setq evil-want-C-u-scroll t)

;; Use evil-collection for bindings
(setq evil-want-integration t) ;; This is optional since it's already set to t by default.
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

(message "Git executable: %s" (executable-find "git"))
(message "Git version:\n%s" (shell-command-to-string "git --version"))

(use-package ivy
  :defer 0
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
        enable-recursive-minibuffers t))

(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "C-<left>") #'evil-window-left)
  (define-key evil-normal-state-map (kbd "C-<up>") #'evil-window-up)
  (define-key evil-normal-state-map (kbd "C-<down>") #'evil-window-down)
  (define-key evil-normal-state-map (kbd "C-<right>") #'evil-window-right))
