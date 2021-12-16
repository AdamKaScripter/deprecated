(define-module (system vars)
  #:export (%my-system-packages))

(define %my-desktop-services
  (append
   (map specification->package
	`("emacs"
	  "emacs-exwm"
	  "emacs-desktop-environment"
	  "emacs-magit"
	  "emacs-stuff"
	  "emacs-emojify"
	  "emacs-editorconfig"
	  "papirus-icon-theme"
	  "nss-certs"))
   %base-packages))
