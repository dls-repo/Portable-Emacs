(setq package-check-signature nil)
;; ----------------------
;; USB-root and pointing paths
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

;;Show mpv executable relative to USB root
(defvar mpv-exe (expand-file-name "mpv-x86_64-gcc-20251124-git-8469605/mpv.exe" usb-root))

;; Portable Python
(defvar python-exe (expand-file-name "python-3.13.9-embed-amd64/python.exe" usb-root))

;; Tell Emacs and Org Babel where Python is
(setq python-shell-interpreter python-exe)
(setq org-babel-python-command python-exe)

;; Add MiKTeX bin to Emacs exec-path (optional)
(add-to-list 'exec-path miktex-bin)
(setenv "PATH" (concat miktex-bin ";" (getenv "PATH")))


;; ----------------------
;; Paths to config.org and config.el
;; ----------------------
(defvar my-config-org (expand-file-name "config.org" user-emacs-directory))
(defvar my-config-el  (expand-file-name "config.el"  user-emacs-directory))

;; ----------------------
;; Tangle config.org if needed
;; ----------------------
;; Adding `/path/to/simpc` to load-path so `require` can find it
(add-to-list 'load-path "~/.emacs.d/simpc/")
(require 'simpc-mode)
;; Automatically enabling simpc-mode on files with extensions like .h, .c, .cpp, .hpp
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))

(defvar my-config-org (expand-file-name "config.org" user-emacs-directory))
(defvar my-config-el  (expand-file-name "config.el"  user-emacs-directory))

;; Tangle config.org if needed
(when (or (not (file-exists-p my-config-el))
          (file-newer-than-file-p my-config-org my-config-el))
  (with-temp-message "Tangling config.org..."
    (require 'org)
    (require 'ob-tangle)
    (org-babel-tangle-file my-config-org my-config-el)))

;; Load generated config.el
(when (file-exists-p my-config-el)
  (load-file my-config-el))

(provide 'init)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
