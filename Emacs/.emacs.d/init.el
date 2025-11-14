;; ======================================
;; Portable Emacs Init Loader
;; ======================================

;; Paths to config.org and config.el
(defvar my-config-org  (expand-file-name "config.org" user-emacs-directory))
(defvar my-config-el   (expand-file-name "config.el"  user-emacs-directory))

;; Tangle config.org if config.el is missing or older
(when (or (not (file-exists-p my-config-el))
          (file-newer-than-file-p my-config-org my-config-el))
  (with-temp-message "Tangling config.org..."
    (require 'org)
    (require 'ob-tangle)
    (org-babel-tangle-file my-config-org my-config-el)))

;; Load the tangled config.el
(load-file my-config-el)
