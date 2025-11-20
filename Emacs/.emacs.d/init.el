;; ======================================
;; Portable Emacs Init
;; ======================================

;; ----------------------
;; 0. Basic settings
;; ----------------------
(setq inhibit-startup-screen t
      visible-bell t
      column-number-mode t
      scroll-conservatively 101)

;; ----------------------
;; 1. Theme
;; ----------------------
(load-theme 'zenburn t)

;; ----------------------
;; 2. USB and MiKTeX paths (FIXED)
;; ----------------------
;; Dynamically detect the USB root, assuming init.el is in Emacs/.emacs.d/
(defvar usb-root
  (file-name-directory
   (directory-file-name
    (expand-file-name "../../.." user-emacs-directory))))
;; MiKTeX executables relative to USB root
(defvar miktex-bin (expand-file-name "miktex-portable/texmfs/install/miktex/bin/x64" usb-root))
(defvar latex-exe (expand-file-name "miktex-portable/texmfs/install/miktex/bin/x64/latex.exe" usb-root))
(defvar dvisvgm-exe (expand-file-name "miktex-portable/texmfs/install/miktex/bin/x64/dvisvgm.exe" usb-root))

;; Add MiKTeX bin to Emacs exec-path (optional)
(add-to-list 'exec-path miktex-bin)
(setenv "PATH" (concat miktex-bin ";" (getenv "PATH")))

;; ----------------------
;; 3. Package system setup
;; ----------------------
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))
(let ((default-directory package-user-dir))
  (normal-top-level-add-subdirs-to-load-path))

;; ----------------------
;; 4. Org-mode & LaTeX previews
;; ----------------------
(with-eval-after-load 'org
  ;; Auto-mode
  (add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

  ;; Temporary output directory for LaTeX previews
  (setq org-latex-preview-output-directory
        (let ((dir (expand-file-name "tmp/latex" user-emacs-directory)))
          (unless (file-exists-p dir) (make-directory dir t))
          dir))
  (setq temporary-file-directory org-latex-preview-output-directory)

  ;; Setup dvisvgm process using full paths
  (setq org-preview-latex-process-alist
        `((dvisvgm
           :programs (,latex-exe ,dvisvgm-exe) ;; use full paths!
           :description "dvi -> svg"
           :message "Ensure LaTeX and dvisvgm are installed"
           :use-xcolor t
           :image-input-type "dvi"
           :image-output-type "svg"
           :image-size-adjust (1.0 . 1.0)
           :latex-compiler ,(list (concat latex-exe " -interaction nonstopmode -output-directory %o %f"))
           :image-converter ,(list (concat dvisvgm-exe " %f -n -b min -o %O")))))

  ;; Set default process
  (setq org-preview-latex-default-process 'dvisvgm)

  ;; Automatically preview LaTeX on startup
  (setq org-startup-with-latex-preview t))

;; ----------------------
;; 5. Paths to config.org and config.el
;; ----------------------
(defvar my-config-org (expand-file-name "config.org" user-emacs-directory))
(defvar my-config-el  (expand-file-name "config.el"  user-emacs-directory))

;; ----------------------
;; 6. Tangle config.org if needed
;; ----------------------
(when (or (not (file-exists-p my-config-el))
          (file-newer-than-file-p my-config-org my-config-el))
  (with-temp-message "Tangling config.org..."
    (require 'org)
    (require 'ob-tangle)
    (org-babel-tangle-file my-config-org my-config-el)))

;; ----------------------
;; 7. Load generated config.el
;; ----------------------
(when (file-exists-p my-config-el)
  (load-file my-config-el))

;; ----------------------
;; 8. Custom variables & faces
;; ----------------------
(custom-set-variables
 '(package-selected-packages
   '(auctex beacon evil help-find-org-mode ivy pdf-tools zenburn-theme)))
(custom-set-faces
 )

;; ----------------------
;; 9. Helper function to toggle previews
;; ----------------------
(defun my/org-preview-toggle ()
  "Toggle LaTeX previews in Org-mode."
  (interactive)
  (require 'org)
  (org-preview-latex-fragment))

(global-set-key (kbd "C-c C-x C-l") 'my/org-preview-toggle)

(provide 'init)

