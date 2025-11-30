;; -*- no-byte-compile: t; lexical-binding: nil -*-
(define-package "emms" "20251125.1121"
  "The Emacs Multimedia System."
  '((cl-lib  "0.5")
    (nadvice "0.3")
    (seq     "0"))
  :url "https://www.gnu.org/software/emms/"
  :commit "2b652057ca75b99fab6fb8da90ead645b4a6af13"
  :revdesc "2b652057ca75"
  :keywords '("emms" "mp3" "ogg" "flac" "music" "mpeg" "video" "multimedia")
  :authors '(("Jorgen Schäfer" . "forcer@forcix.cx"))
  :maintainers '(("Yoni Rabkin" . "yrk@gnu.org")))
