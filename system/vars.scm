(define-module (system vars)
  #:use-module (gnu)
  #:use-module (pkgs emacs)
  #:export (%my-main-user-groups
            %my-desktop-packages))

(define %my-main-user-groups
  '("wheel" "netdev" "audio" "video" "docker" "libvirt" "kvm"))

(define %my-desktop-packages
  `("emacs"
    "emacs-exwm"
    "emacs-desktop-environment"
    "emacs-magit"
    "emacs-stuff"
    "emacs-emojify"
    "emacs-editorconfig"
    "papirus-icon-theme"
    "nss-certs"))
