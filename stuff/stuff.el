(provide 'stuff)

(defun stuff-init ()
  (interactive)
  (stuff-emacs-options-to-apply)
  (stuff-unix-misc))

(defun stuff-emacs-options-to-apply ()
  (setq inhibit-startup-screen t)
  (menu-bar-mode 0)
  (tool-bar-mode 0)

  (set-frame-font "Terminus 20" nil t)

  (setq backup-directory-alist '(("." . "~/.emacs_saves"))))

(defun stuff-generate-configs ()
  )

(defun stuff-generate-dot-emacs ()
  )

(defun stuff-unix-misc ()
  (shell-command "setxkbmap -option grp:alt_shift_toggle -layout 'us,ru'"))
