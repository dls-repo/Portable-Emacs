(require 'package)
(setq package-archives
      '(("nongnu-devel" . "https://elpa.nongnu.org/nongnu-devel/")
        ("gnu"         . "https://elpa.gnu.org/packages/")
        ("melpa"       . "https://melpa.org/packages/")))

(unless package--initialized
  (package-initialize))

(unless (package-installed-p 'use-package)
  (unless package-archive-contents
    (package-refresh-contents))
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package company
  :ensure t
  :init
  (global-company-mode)  ; Enable Company Mode globally
  :config
  (setq company-idle-delay 0.2)  ; Wait 200ms before showing suggestions
  (setq company-minimum-prefix-length 1))  ; Minimum prefix length for suggestions

(keymap-set global-map "C-c c" #'compile)
(keymap-set global-map "C-c d" #'duplicate-line)
(keymap-set global-map "C-c =" #'align-regexp)
(setq compile-command "cc")


;; alias expansion
(defun my/expand-compile-alias (cmd)
  (if (string= cmd "cc")
      (let ((src (shell-quote-argument buffer-file-name))
            (out (shell-quote-argument
                  (file-name-sans-extension
                   (file-name-nondirectory buffer-file-name)))))
        (format "gcc -Wall -Wextra -Wno-missing-braces -Wno-unused-parameter"
                out src))
    cmd))

(electric-indent-mode 1)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(menu-bar-mode 0)
(tool-bar-mode 0)
(setq org-startup-with-inline-images t)
(windmove-default-keybindings 'control)
(winner-mode 1) ;;undo but for window layout
(global-visual-line-mode 1)
(load-theme 'deeper-blue t)
(setq inhibit-startup-screen t)
(ido-mode 1)

(use-package expand-region
  :bind (("C-\"" . er/expand-region)   ;; expand
         ("C-:"  . er/contract-region))) ;; contract

(pending-delete-mode t)

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

(use-package multiple-cursors
  :ensure t
  :bind
  (("C-c m c" . mc/edit-lines)        ; Add cursors to each line in region
   ("C->" . mc/mark-next-like-this) ; Add a cursor to next occurrence
   ("C-<" . mc/mark-previous-like-this) ; Add cursor to previous occurrence
   ("C-c m a" . mc/mark-all-like-this))) ; Add cursors to all matches

(use-package org
  :ensure t
  :config
  (require 'org-tempo))

(setq org-babel-python-command "python3")

(org-babel-do-load-languages
  'org-babel-load-languages
    '((python . t)
      (emacs-lisp . t)
      (C . t)))

(with-eval-after-load 'org
  ;; Temporary output directory for LaTeX previews
  (setq org-latex-preview-output-directory
        (let ((dir (expand-file-name "tmp/latex" user-emacs-directory)))
          (unless (file-exists-p dir) (make-directory dir t))
          dir))
  (setq temporary-file-directory org-latex-preview-output-directory)

  ;; Setup dvisvgm process using full paths
  (setq org-latex-preview-process-alist
        `((dvisvgm
           :programs ("latex" "dvisvgm")
           :description "dvi -> svg"
           :message "Ensure LaTeX and dvisvgm are installed"
           :use-xcolor t
           :image-input-type "dvi"
           :image-output-type "svg"
           :image-size-adjust (1.0 . 1.0)
           :latex-compiler (,latex-exe "-interaction" "nonstopmode"
                                      "-output-directory" "%o" "%f")
           :image-converter (,dvisvgm-exe "%f" "-n" "-b" "min" "-o" "%O"))))

  ;; Set default process
  (setq org-latex-preview-default-process 'dvisvgm)

  ;; Automatically preview LaTeX on startup
  (setq org-startup-with-latex-preview t))

(defun my/org-preview-toggle ()
  "Toggle LaTeX previews in Org-mode."
  (interactive)
  (require 'org)
  (org-preview-latex-fragment))

(global-set-key (kbd "C-c C-x C-l") 'my/org-preview-toggle)

(use-package flyspell
  :ensure t
  :init
  (setq ispell-program-name "aspell") ;; or "ispell", depending on your preference
  :hook
  ;; Enable flyspell only in text and org modes
  ((text-mode org-mode) . flyspell-mode)
  ;; Ensure flyspell ignores code blocks in org-mode
  :config
  (defun my/org-mode-flyspell-setup ()
    "Disable flyspell in Org src blocks."
    (setq-local flyspell-verify-ignore-predicate
                (lambda ()
                  (not (org-in-src-block-p)))))
  (add-hook 'org-mode-hook #'my/org-mode-flyspell-setup))

(use-package langtool
  :ensure t
  :defer t
  :init
  (setq langtool-language-tool-jar "~/LanguageTool-6.6/languagetool-server.jar") ;; Set the jar path
  (global-set-key (kbd "C-c h") 'langtool-check)) ;; Keybinding for grammar checking

(use-package astyle
  :ensure t  ;; installs the Emacs Lisp wrapper from MELPA
  :commands (astyle-buffer astyle-region)
  :config
  ;; Example: set default style options
(setq astyle-options '("--style=kr" "--indent=spaces=4")))
(defun astyle-buffer ()
  (interactive)
  (let ((saved-line-number (line-number-at-pos)))
    (shell-command-on-region
     (point-min)
     (point-max)
     "astyle --style=kr"
     nil
     t)
    (goto-line saved-line-number)))
 (global-set-key (kbd "C-c a") 'astyle-buffer)

(use-package yasnippet
  :ensure t
  :hook ((prog-mode . yas-minor-mode)
         (org-src-mode . yas-minor-mode))
  :config
  (yas-reload-all))
