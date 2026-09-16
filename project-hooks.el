;;; project-hooks.el --- Hooks for specific projects  -*- lexical-binding: t; -*-

;; Copyright (C) 2026 Darlan Cavalcante Moreira

;; Author: Darlan Cavalcante Moreira <darcamo@gmail.com>
;; Keywords:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Define predicates for common project types and allow registering functions to
;; run after opening buffers in one of them.

;;; Code:
(require 'project)

(defgroup project-hooks nil
  "Hooks for specific projects."
  :group 'convenience
  :prefix "project-hooks-")


(defcustom project-hooks-alist nil
  "An alist of predicate functions and hooks to run.

For each buffer in a project, the predicate run and, if it returns t,
the hook is run for that buffer.

The predicate and also be a string, in which case it will be treated as
a file name to check in the root of the project."
  :group 'project-hooks
  :type
  '(alist
    :key-type
    (choice
     (function :tag "Predicate function")
     (string :tag "A file in the project root"))))


(defun project-hooks-check-for-specific-file (filename)
  "Check if FILENAME exists in the root of the project."
  (if-let* ((project (project-current))
            (project-root (project-root project))
            (file-path (expand-file-name filename project-root)))
      (file-exists-p file-path)))


(defun project-hooks--run-matching-hooks ()
  "Run the hooks in `project-hooks-alist' whose predicate returns non-nil."
  (when-let* ((project (project-current)))
    (dolist (pair project-hooks-alist)
      (let ((predicate (car pair))
            (hook (cdr pair)))
        (when (if (stringp predicate)
                  (project-hooks-check-for-specific-file predicate)
                (funcall predicate))
          (funcall hook))))))


(define-minor-mode project-hooks-mode
  "Minor mode to run hooks for specific projects."
  :global
  nil
  (when project-hooks-mode
    (project-hooks--run-matching-hooks)))


;; Define a global minor mode that will run the predicates in `project-hooks-alist' and call the corresponding hooks if a predicate returns true.
;;;###autoload
(define-globalized-minor-mode global-project-hooks-mode
  project-hooks-mode
  (lambda ()
    (when (project-current)
      (project-hooks-mode 1))))


(provide 'project-hooks)
;;; project-hooks.el ends here
