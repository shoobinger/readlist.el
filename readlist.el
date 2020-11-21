;;; readlist.el --- Minor mode to manage read lists.
;;; Commentary:
;;;
;;; Code:

(define-minor-mode readlist-mode
  "Toggle Readlist mode"
  :init-value nil
  :lighter " Readlist"
  :keymap (make-sparse-keymap))

(defun readlist-start-reading()
  "Move the selected book to the ACTIVE status and create a notes org file for it."
  (interactive)
  (org-todo "ACTIVE")
  (let* ((element (org-element-at-point))
         (current-project (projectile-project-root))
         (book-name (org-element-property :raw-value element))
         (new-file (concat "notes/books/" book-name ".org"))
         (new-file-absolute (concat current-project new-file)))
    ;; Create a new notes file.
    (shell-command (concat "touch '" new-file-absolute "'"))

    ;; Put the newly created file to the project cache.
    (unless (projectile-file-cached-p new-file-absolute current-project)
      (puthash current-project
               (cons new-file-absolute (gethash current-project projectile-projects-cache))
               projectile-projects-cache)
      (projectile-serialize-cache))

    ;; Replace the heading with the link to the file.
    (org-edit-headline (concat "[[file:" new-file "][" book-name "]]"))))

(provide 'readlist)

;;; readlist.el ends here
