(provide 'stuff)

(defun stuff-init ()
  (interactive)
  (stuff-emacs-options-to-apply))

(defun stuff-emacs-options-to-apply ()
  (setq inhibit-startup-screen t)
  (menu-bar-mode 0)
  (tool-bar-mode 0)

  (set-frame-font "Terminus 20" nil t)

  (setq backup-directory-alist '(("." . "~/.emacs_saves"))))
