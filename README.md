# project-hooks


Define a hook for any buffer within a project that satisfies a specified predicate.

## Usage

Add an entry to `project-hooks-alist` with a cons cell containing a predicate and a function to run if that predicate returns `t`. The predicate can also be a string corresponding to a filename in the root of the project. In that case, the actual predicate used is if that file exists in the root of the project.

### Example with `use-package`

```emacs-lisp
(use-package project-hooks
  :config
   (add-to-list 'project-hooks-alist '("go.mod" . (lambda () (interactive) (message "I'm in a Go project"))))
  )
```

**Note**: Don't put anything heavy on the predicate or on the hook function, since this runs for every buffer in a project.
