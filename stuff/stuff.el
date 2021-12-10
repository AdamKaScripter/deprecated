(provide 'stuff)

(defvar stuff-dot-channels-scm
  (let ((guix-url "https://git.savannah.gnu.org/git/guix.git")
        (nonguix-url "https://gitlab.com/nonguix/nonguix")
        (mine-url "https://github.com/AdamKaScripter/deprecated"))
    `(list
       (channel
        (name 'guix)
        (url ,guix-url))
       (channel
        (name 'nonguix)
        (url ,nonguix-url))
       (channel
        (name 'mine)
        (url ,mine-url)))))

(defun stuff-init ()
  (interactive)
  (stuff-emacs-options-to-apply)
  (stuff-unix-misc)
  (stuff-generate-configs))

(defun stuff-emacs-options-to-apply ()
  ;; for copyright
  (setq user-full-name "Adam Kandur")
  (setq user-mail-address "rndd@tuta.io")

  (let ((guix-dir "~/p/guix"))
    (if (file-directory-p guix-dir)
        (progn
          (with-eval-after-load 'yasnippet
            (add-to-list 'yas-snippet-dirs
                         (concat guix-dir
                                 "/etc/snippets")))
          (load-file (concat guix-dir
                             "/etc/copyright.el")))))

  (setq inhibit-startup-screen t)
  (menu-bar-mode 0)
  (tool-bar-mode 0)
  ;; needed for running emacs inside of emacs
  (scroll-bar-mode -1)

  (add-hook 'after-init-hook #'global-emojify-mode)

  (if (x-list-fonts "Terminus")
      (set-frame-font "Terminus 20" nil t))

  (load-theme 'tsdh-light)

  (setq backup-directory-alist '(("." . "~/.emacs_saves"))))

(defun stuff-generate-configs ()
  (stuff-generate-dot-emacs)
  (stuff-generate-dot-channels-scm))

(defun stuff-generate-dot-emacs ()
  (stuff-write-to-file "~/.emacs"
                       "(require 'stuff)\n(stuff-init)\n"))

(defun stuff-generate-dot-channels-scm ()
  (stuff-write-to-file "~/.channels.scm"
                       (concat "; Autogenerated by deprecated...\n"
                               (format "%S" stuff-dot-channels-scm))))

(defun stuff-unix-misc ()
  (shell-command "setxkbmap -option grp:alt_shift_toggle -layout 'us,ru'"))

(defun stuff-write-to-file (file string)
  (write-region string nil file))

(defun stuff-suspend ()
  (interactive)
  (shell-command "loginctl suspend && xlock"))


(global-set-key (kbd "C-x <f5>") 'stuff-suspend)
