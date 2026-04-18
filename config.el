;;; config.el --- configuration file -*- lexical-binding: t; -*-
;; -------------------------------------------------------------------- Time stamp
;; Time-stamp: "Last changed on 20260412T1540"
;;; ------------------------------------------------------------------- Commentary:
;; My code snippets come mainly from the web. I evaluate snippets. Those that work
;; I add to my config.org file. This file is tangled to produce my configuration
;; config.el file.
;;; -------------------------------------------------------------------- Code:

(defvar straight-use-package)
(defvar bootstrap-version)

(unless (boundp 'straight-use-package)
  (message "Bootstrapping straight.el")

  (let ((bootstrap-file
         (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
        (bootstrap-version 7))
    (unless (file-exists-p bootstrap-file)
      (with-current-buffer
          (url-retrieve-synchronously
           "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
           'silent 'inhibit-cookies)
        (goto-char (point-max))
        (eval-print-last-sexp)))
    (load bootstrap-file nil 'nomessage)))

(eval-and-compile
  (setq use-package-always-ensure nil
        use-package-always-defer t
        use-package-compute-statistics nil
        use-package-hook-name-suffix nil
        use-package-verbose 'debug
        use-package-expand-minimally t)
  (put 'use-package 'lisp-indent-function 1))

(when init-file-debug
  (setq use-package-verbose t
        use-package-expand-minimally nil
        use-package-compute-statistics t
        debug-on-error t))

(setq straight-repository-branch "develop"
      straight-profiles
      `((nil . ,(expand-file-name "straight/versions/lock.el" user-emacs-directory)))
      straight-check-for-modifications nil
      straight-base-dir user-emacs-directory
      straight-cache-autoloads t
      straight-use-package-by-default t
      straight-fix-flycheck t)

(straight-register-package 'org)
(straight-register-package 'org-contrib)

  (use-package async
    :config
    (async-bytecomp-package-mode 1)

    :commands (async-start dired-async-mode dired-do-async-shell-command))

  (use-package bind-key
    :straight (:type built-in))

  (use-package dash)

  (use-package diminish)

  (use-package f
    :commands (f-entries f-ext?))

  (use-package s)

(use-package bug-hunter
  :commands (bug-hunter-init-file bug-hunter-file))

(use-package debug
  :straight (:type built-in)
  :commands (debugger-continue debugger-eval-expression backtrace-toggle-locals))

(use-package cus-edit
  :straight (:type built-in)
  :init
  (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
  (load custom-file :noerror :nomessage))

(eval-when-compile
  (require 'cl-lib)
  (require 'subr-x))

(use-package emacs
  :straight (:type built-in)
  :init
  (menu-bar-mode 1)
  (scroll-bar-mode 1)

  (setq-default cursor-type 'bar)

  (setq scroll-bar-position 'right
        print-length nil
        print-level nil
        eval-expression-print-length nil
        eval-expression-print-level nil))

(use-package emacs
  :straight (:type built-in)
  :config
  (dotimes (n 10)
    (global-unset-key (kbd (format "C-%d" n))))

  (setq read-process-output-max (* 1024 1024))

  (defvar proj-dir (expand-file-name "~/Dropbox/projects/")
    "Root directory for projects.")
  (defvar downloads (expand-file-name "~/Downloads/")
    "Downloads directory.")

  :bind (("<escape>" . top-level)
         ("C-x m"   . man)
         ("C-c s-s" . outline-show-all)
         ("C-c s-a" . my-close-all-buffers)
         ("C-c s-b" . scratch-buffer)
         ("C-c s-n" . display-line-numbers-mode)
         ("C-c s-v" . split-window-vertically)
         ("C-c s-c" . my-char-case-toggle)
         ("C-c s-r" . my-block-compact-uncompact)))

(setq-default display-fill-column-indicator-column 94)
(setq-default fill-column 94)
(global-display-fill-column-indicator-mode 1)

(use-package which-key
  :straight (:type built-in)
  :diminish which-key-mode
  :config
  (setq which-key-show-prefix 'left
        which-key-separator " → "
        which-key-side-window-max-height 0.3
        which-key-idle-delay 0.2
        which-key-sort-order #'which-key-key-order-alpha
        which-key-sort-uppercase-first nil
        which-key-compute-remaps t)
  (which-key-setup-side-window-right)
  (which-key-mode 1))

(use-package hydra
  :config
  ;; --------------------------------- modes
  (global-set-key
   (kbd "C-c h m")
   (defhydra hydra-modes (:color blue :columns 1)
     "mode"
     ("d" dap-mode "debugger" :column "Mode")
     ("v" abbrev-mode "abbrev")
     ("s" flyspell-mode "flyspell")
     ("c" flycheck-mode "flycheck")
     ("f" visual-fill-column-mode "visual fill")
     ("y" yas-minor-mode "yas")
     ("n" display-line-numbers-mode "line nums")
     ("q" nil "quit" :color red)))

  ;; -------------------------- global keys
  (global-set-key
   (kbd "C-c h k")
   (defhydra hydra-global (:color blue :columns 1)
     "global"
     ("a" my-close-all-buffers "close all")
     ("b" scratch-buffer "scratch")
     ("v" split-window-vertically "split v")
     ("c" my-char-case-toggle "change case")
     ("f" my-block-compact-uncompact "change fill")
     ("q" nil "quit" :color red)))

  ;; --------------------------------- Font size
  (global-set-key
   (kbd "C-c h f")
   (defhydra hydra-font (:color red :columns 1)
     "fontsize"
     ("+" text-scale-increase "increase")
     ("-" text-scale-decrease "decrease")
     ("q" nil "quit" :color blue)))

  ;; ----------------------------------- Organize in Org
  (global-set-key
   (kbd "C-c h o")
   (defhydra hydra-organize (:color red :columns 4)
     "organize"
     ("u" org-metaup "up" :column "Meta")
     ("w" org-metadown "down")
     ("h" org-metaleft "lt")
     ("r" org-metaright "rt")

     ("U" org-shiftup    "up" :column "Shift")
     ("W" org-shiftdown  "down")
     ("H" org-shiftleft  "lt")
     ("R" org-shiftright "rt")

     ("<" org-promote "promo" :column "rank")
     (">" org-demote "demo")

     ("^" org-move-item-up "up" :column "move")
     ("v" org-move-item-down "down")
     ("q" nil "quit" :color blue)))

  ;; ---------------------------- Check box
  (global-set-key
   (kbd "C-c h b")
   (defhydra hydra-checkbox (:color pink :columns 1)
     "checkbox"
     ("t" org-toggle-checkbox             "toggle" :column "box")
     ("c" org-update-checkbox-count-maybe "count")
     ("r" org-reset-checkbox-state-subtree "reset")
     ("q" nil "quit" :color blue)))

  ;; --------------------------------- Navigation
  (global-set-key
   (kbd "C-c h n")
   (defhydra hydra-navigation (:color red :columns 2)
     "navigation"
     ("u" outline-up-heading "up" :column "heading")
     ("n" outline-next-visible-heading "next")
     ("p" outline-previous-visible-heading "prev")
     ("f" org-forward-heading-same-level "frward")
     ("b" org-backward-heading-same-level "bkward")

     ("o" org-previous-item "prev" :column "item")
     ("i" org-next-item "next")
     ("g" org-goto "goto" :exit t)
     ("s" outline-show-all "all")
     ("q" nil "quit" :color blue)))

  ;; ------------------------------- Org "wrist-watch"
  (global-set-key
   (kbd "C-c h w")
   (defhydra hydra-clock (:color red :columns 2)
     "wrist-watch"
     ("i" org-clock-in "in" :column "Clock")
     ("o" org-clock-out "out")
     ("r" org-clock-report "report")
     ("d" org-clock-display "display")
     ("z" org-resolve-clocks "resolve")
     ("l" org-clock-in-last "last")
     ("c" org-clock-cancel "cancel")
     ("g" org-clock-goto "goto")

     ("t" org-time-stamp "time" :column "Timestamp")
     ("T" org-time-stamp-inactive "inactive")
     ("q" nil "quit" :color blue)))

  ;; ------------------------------ Org span-timer
  (global-set-key
   (kbd "C-c h s")
   (defhydra hydra-timer (:color red :columns 1)
     "span-timer"
     ("w" org-timer "timer" :column "Time span")
     ("i" org-timer-item "item")
     ("s" org-timer-set-timer "set")
     ("b" org-timer-start "start")
     ("e" org-timer-stop "stop")
     ("p" org-timer-pause-or-continue "Stop&Go")
     ("q" nil "quit" :color blue)))

  ;; --------------------------------- Org table
  (global-set-key
   (kbd "C-c h t")
   (defhydra hydra-table (:color red :columns 4)
     "table"
     ("p" org-table-previous-field "prev" :column "field")
     ("n" org-table-next-field "next")
     ("$" org-table-end-of-field "end")
     ("a" org-table-beginning-of-field "begin")
     ("e" org-table-edit-field "edit")
     ("b" org-table-blank-field "blank")

     ("^" org-table-move-row-up "go up" :column "row")
     ("v" org-table-move-row-down "go down")
     ("r" org-table-insert-row "insert")
     ("k" org-table-kill-row "kill")

     ("<" org-table-move-column-left "left" :column "column")
     (">" org-table-move-column-right "right")
     ("c" org-table-insert-column "insert")
     ("d" org-table-delete-column "del")

     ("-" org-table-insert-hline "hl" :column "region")
     ("A" org-table-align "align")
     ("q" nil "quit" :color blue)))

  ;; --------------------------- Dired selecting addresses
  (global-set-key
   (kbd "C-c h d")
   (defhydra hydra-dired (:color blue :columns 1)
     "dired"
     ("b" (dired bibliography-directory) "Bib" :column "Dir")
     ("n" (dired org-notes-dir)          "Note")
     ("o" (dired org-directory)          "Org")
     ("l" (dired org-lib-dir)            "Org lib")
     ("d" (dired downloads)              "Downloads")
     ("r" (dired org-roam-directory)     "Org roam")
     ("q" nil "quit" :color red)))

  ;; ---------------------------- Working with rectangles
  (global-set-key
   (kbd "C-c h r")
   (defhydra hydra-rectangle (:body-pre (rectangle-mark-mode 1)
                                        :color pink
                                        :columns 2
                                        :post (deactivate-mark))
     "rectangle"
     ("k" kill-rectangle   "kill" :column "Edit")
     ("d" delete-rectangle "del")
     ("y" yank-rectangle   "yank")
     ("j" copy-rectangle-as-kill "cp & keep")
     ("c" clear-rectangle        "clear")

     ("p" rectangle-previous-line "prev line" :column "Move")
     ("n" rectangle-next-line "next line")
     ("b" rectangle-backward-char "bkward char")
     ("f" rectangle-forward-char "frward char")
     ("q" keyboard-quit "quit" :color blue)))

  ;; ------------------------------------ expand region
  (global-set-key
   (kbd "C-c h x")
   (defhydra hydra-expand (:pre (er/mark-word)
                                :color red
                                :columns 1)
     "expand"
     ("x" er/expand-region "expand" :column "Region")
     ("r" er/contract-region "contract")
     ("q" nil "quit" :color blue)))

  ;; -------------------------------- multiple cursors
  (global-set-key
   (kbd "C-c h c")
   (defhydra hydra-multicursors (:columns 2 :color red)
     "multicursors"
     ("n" mc/mark-next-like-this       "mark next" :column "Mark like this")
     ("u" mc/unmark-next-like-this     "unmark next")
     ("p" mc/mark-previous-like-this   "mark prev")
     ("d" mc/unmark-previous-like-this "unmark prev")
     ("a" mc/mark-all-like-this        "mark all")

     ("b" mc/edit-beginnings-of-lines "bol" :column "Edit line")
     ("e" mc/edit-ends-of-lines "eol")
     ("l" mc/edit-lines "line" :color blue)
     ("q" nil "quit" :color blue)))

  ;; ------------------------------------- Elisp
  (global-set-key
   (kbd "C-c h e")
   (defhydra hydra-elisp (:color red :columns 3)
     "elisp"
     ("r" eval-region "region" :column "Eval")
     ("f" eval-defun  "func")
     ("b" eval-buffer "buffer")
     ("e" eval-expression "exp" :color blue)
     ("l" eval-last-sexp "ls exp")

     ("d" find-function-at-point "FFAP" :column "Find")
     ("v" find-variable "FV")

     ("^" beginning-of-defun "BOD" :column "Move in defs")
     ("$" end-of-defun "EOD")
     ("q" nil "quit" :color blue)))

  ;; -------------------------------- debug
  (global-set-key
   (kbd "C-c h a")
   (defhydra hydra-debugger (:color blue :columns 1)
     "debugger"
     ("c" debugger-continue        "cont" :column "CMD")
     ("e" debugger-eval-expression "eval exp")
     ("q" nil "quit" :color red))))

(use-package org-superstar
  :hook (org-mode-hook . org-superstar-mode)
  :config
  (setq org-superstar-headline-bullets-list '("◉" "⁑" "⁂" "❖" "✮" "✱" "✸")))

(use-package adaptive-wrap
  :hook (visual-line-mode-hook . adaptive-wrap-prefix-mode))

(use-package org
  :demand t
  :straight (:includes (org-agenda org-capture org-datetree org-protocol
                                   org-tempo org-table org-clock org-indent
                                   ox ox-latex ox-beamer org-mouse org-faces
                                   org-timer org-list org-id org-archive
                                   org-attach org-element org-src org-mobile
                                   org-refile oc-bibtex))
  :init
  (setq org-fontify-whole-heading-line t
        org-fontify-done-headline t
        org-link-descriptive      t
        org-odd-levels-only       nil
        org-startup-indented      t
        org-startup-folded        'nofold
        org-export-backends       '(ascii beamer html latex md)
        org-hide-block-startup    nil)

  (setq org-emphasis-alist
        '(("*" bold       "<b>"  "</b>")
          ("/" italic     "<i>"  "</i>")
          ("_" underline  "<span style=\"text-decoration:underline;\">" "</span>")))

  (setq org-return-follows-link                    t
        org-cycle-include-plain-lists              t
        org-ellipsis                               "…"
        org-use-sub-superscripts                   "{}"
        org-read-date-prefer-future                'time
        org-use-tag-inheritance                    nil
        org-use-property-inheritance               nil
        org-complete-tags-always-offer-all-agenda-tags t
        org-catch-invisible-edits                  'smart
        org-log-done                               nil
        org-use-fast-todo-selection                t
        org-footnote-auto-adjust                   t
        org-pretty-entities                        t)

  (setq org-support-shift-select    'always
        org-columns-default-format  "%4TODO %10TASK %20TIMESTAMP"
        org-tags-column             40
        org-enforce-todo-dependencies t
        org-image-actual-width      nil
        org-remove-highlights-with-change nil)

  (setq org-tag-alist
        '((:startgroup . nil)
          ("linux"     . ?L) ("emacs" . ?e) ("org" . ?o)
          (:endgroup   . nil)

          (:startgroup  . nil)
          ("article"    . ?a) ("book" . ?b) ("reference" . ?r)
          (:endgroup    . nil)

          (:startgroup  . nil)
          ("idea"       . ?i) ("lecture" . ?l) ("quotation" . ?q) ("word" . ?w)
          (:endgroup    . nil)))

  :config
  (defvar org-directory (expand-file-name "~/Dropbox/org/"))
  (defvar bibliography-directory (expand-file-name "~/Dropbox/org/bibliographies/"))
  (defvar archives-dir  (expand-file-name "~/Dropbox/org/archives/"))
  (defvar org-notes-dir (expand-file-name "~/Dropbox/org/notes/"))
  (defvar org-lib-dir   (expand-file-name "~/Dropbox/org/library/"))

  (setq org-default-notes-file (expand-file-name "refile.org" org-directory)
        org-blank-before-new-entry '((heading . t) (plain-list-item . nil))
        org-reverse-note-order     nil
        org-link-search-must-match-exact-headline nil)

  (setq org-todo-keywords
        '((sequence "TODO(t)" "INPROGRESS(p)" "NEXT(n)" "HOLD(h)"
                    "|" "DONE(d!)" "CANCEL(c)")))
  (setq org-todo-keyword-faces
        '(("TODO"       . (:foreground "red"     :weight bold))
          ("INPROGRESS" . (:foreground "blue"    :weight bold))
          ("NEXT"       . (:foreground "pink"    :weight bold))
          ("DONE"       . (:foreground "maroon"  :weight bold))
          ("CANCEL"     . (:foreground "yellow"  :weight bold))))

  ;; org-babel
  (setq org-babel-default-header-args:emacs-lisp '((:lexical . "yes"))
        org-babel-use-quick-and-dirty-noweb-expansion t
        org-confirm-babel-evaluate      nil
        org-confirm-elisp-link-function nil
        org-export-babel-evaluate       t)

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((calc    . t) (ditaa      . t)
     (latex   . t) (emacs-lisp . t)
     (lisp    . t) (css        . t)
     (gnuplot . t) (shell      . t)
     (R       . t) (sqlite     . t)
     (sql     . t) (awk        . t)
     (python  . t) (js         . t)))

  (add-to-list 'org-src-lang-modes '("dot" . graphviz-dot))
  (add-hook 'org-babel-after-execute-hook #'org-display-inline-images 'append)

  :hook (org-mode-hook . (lambda () (setq-local tab-width 8)))
  :bind (:map org-mode-map
              ("s-b s-i" . org-indent-block)
              ("s-b s-c" . org-cycle-list-bullet)))

(use-package org-auto-tangle
  :diminish
  :hook (org-mode-hook . org-auto-tangle-mode))

(use-package graphviz-dot-mode
  :mode "\\.dot\\'"
  :init
  (setq graphviz-dot-indent-width 2
        graphviz-dot-auto-indent-on-newline t
        graphviz-dot-auto-indent-on-braces t
        graphviz-dot-auto-indent-on-semi t))

(use-package org-datetree
  :straight (:type built-in))

(use-package org-tempo
  :straight (:type built-in)
  :custom
  (org-tempo-keywords-alist
   '(("A" . "ascii\n")
     ("H" . "html\n")
     ("i" . "index")
     ("L" . "latex\n")
     ("n" . "name")))
  (org-structure-template-alist
   '(("c" . "center\n")
     ("C" . "comment\n")
     ("e" . "example\n")
     ("v" . "verse\n")
     ("q" . "quote\n")
     ("x" . "export\n")
     ("xa" . "export ascii\n")
     ("xh" . "export html\n")
     ("xl" . "export latex\n")

     ("s" . "src\n")
     ("st" . "src text\n")
     ("so" . "src org\n")
     ("sh" . "src shell\n")
     ("sl" . "src emacs-lisp\n")
     ("sL" . "src latex\n")
     ("sp" . "src python\n"))))

      ;;; --------------------------------- org-refile
(use-package org-refile
  :straight (:type built-in)
  :custom
  (org-refile-use-outline-path t)
  (org-outline-path-complete-in-steps nil)
  (org-refile-allow-creating-parent-nodes 'confirm)
  :config
  (setq org-refile-targets
        `((,org-default-notes-file :level . 1)
          (,(expand-file-name "computing.org" org-directory) :level . 1)
          (,(expand-file-name "inbox.org" org-directory)     :level . 1)
          (,(expand-file-name "projects.org" org-directory)  :level . 1)
          (,(expand-file-name "tags.org" org-directory)      :level . 1)
          (,(expand-file-name "vocab.org" org-directory)     :level . 1)
          (,(expand-file-name "writing.org" org-directory)   :level . 1))))

(use-package org-protocol
  :straight (:type built-in)
  :demand t)

(use-package org-capture
    :straight (:type built-in)
    :after org
    :init
    (setq org-capture-templates
          `(("n" "Note" entry (file+headline ,(expand-file-name "inbox.org" org-directory) "Note")
             "* %?\n\n:PROPERTIES:\n:CREATED: %U\n:END:\n/Context:/ %a")

            ("t" "Task" entry (file+headline ,(expand-file-name "inbox.org" org-directory) "Task")
             "* TODO %?\n\n:PROPERTIES:\n:CREATED: %U\n:END:\n/Context:/ %a")))

    :config
    (defvar abs--capture-frame nil
      "The frame created for org-capture.")

    (defun abs--delete-frame-on-capture-finalize ()
      "Delete the capture frame if it exists after capture finalizes."
      (when (and abs--capture-frame (frame-live-p abs--capture-frame))
        (delete-frame abs--capture-frame))
      (remove-hook 'org-capture-after-finalize-hook #'abs--delete-frame-on-capture-finalize))

    (defun abs--quick-capture (&optional key)
      "Launch an org-capture frame that deletes itself when done.
  Optional argument KEY specifies the capture template key (default: \"n\")."
      (interactive)
      (let ((capture-key (or key "n")))
        (setq abs--capture-frame (selected-frame))
        (cl-letf (((symbol-function 'org-switch-to-buffer-other-window)
                   #'switch-to-buffer))
          (add-hook 'org-capture-after-finalize-hook #'abs--delete-frame-on-capture-finalize)
          (org-capture nil capture-key))))

    :bind ("<f9>" . abs--quick-capture))

(use-package org-agenda
  :straight (:type built-in)
  :init
  (setq org-agenda-restore-windows-after-quit t
        org-agenda-window-setup 'only-window
        org-agenda-block-separator 9472
        org-agenda-dim-blocked-tasks nil
        org-agenda-inhibit-startup t
        org-agenda-use-tag-inheritance nil
        org-tags-match-list-sublevels t
        org-agenda-show-all-dates nil
        org-agenda-skip-deadline-if-done t
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-prewarning-if-scheduled t
        org-agenda-skip-scheduled-if-deadline-is-shown 'not-today
        org-agenda-start-on-weekday nil)

  :config
  (setq org-agenda-files (list (file-truename (expand-file-name "todo/" org-directory)))
        org-agenda-sticky t
        org-agenda-tags-todo-honor-ignore-options t
        org-agenda-skip-additional-timestamps-same-entry t
        org-agenda-skip-timestamp-if-done t
        org-agenda-span 1
        org-agenda-todo-ignore-with-date nil
        org-agenda-todo-ignore-deadlines nil
        org-agenda-todo-ignore-scheduled nil
        org-agenda-todo-ignore-timestamp nil
        org-agenda-persistent-filter t
        org-agenda-compact-blocks t
        org-agenda-log-mode-items '(closed state)
        org-agenda-restriction-lock-highlight-subtree nil
        org-agenda-sorting-strategy '((agenda category-keep) (todo category-up)))

  (setq appt-message-warning-time 15
        appt-display-mode-line nil
        appt-display-format 'window)

  (setq org-agenda-time-grid
        '((daily today require-timed remove-match)
          (800 1000 1200 1400 1600 1800 2000)
          "......" "----------------"))

  (setq org-agenda-custom-commands
        '(("g" "GTD"
           ((tags "inbox"
                  ((org-agenda-prefix-format "  %?-12t% s")
                   (org-agenda-hide-tags-regexp "inbox")
                   (org-agenda-overriding-header "\nInbox: clarify and organize\n")))))

          ("a" "Daily"
           ((agenda nil
                    ((org-scheduled-past-days 0)
                     (org-deadline-warning-days 0)))

            (todo "INPROGRESS"
                  ((org-agenda-prefix-format "  %i %-12:c [%e] ")
                   (org-agenda-overriding-header "\nTasks: in progress\n")))

            (todo "NEXT"
                  ((org-agenda-overriding-header "Next task")))

            (todo "TODO"
                  ((org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'deadline 'scheduled))
                   (org-agenda-files (list "agenda.org" "notes.org" "projects.org"))
                   (org-agenda-prefix-format "  %i %-12:c [%e] ")
                   (org-agenda-max-entries 5)
                   (org-agenda-overriding-header "\nTasks: Can be done\n")))

            (tags-todo "Refile"
                       ((org-agenda-overriding-header "Todos")
                        (org-tags-match-list-sublevels nil)))

            (tags "CLOSED>=\"<today>\""
                  ((org-agenda-overriding-header "\nCompleted today\n"))))
           ((org-agenda-hide-tags-regexp "inbox")
            (org-agenda-compact-blocks t)))

          ("w" "Week"
           ((agenda ""
                    ((org-agenda-span 7)))
            (todo "INPROGRESS")
            (todo "NEXT")))

          ("s" "Search"
           ("a" "Store" search ""
            ((org-agenda-files (file-expand-wildcards (expand-file-name "*.org" archives-dir)))))
           ("p" "Project" search ""
            ((org-agenda-files (file-expand-wildcards (expand-file-name "*.org" proj-dir)))))
           ("t" "Tags" org-tags-view ""
            ((org-agenda-files (file-expand-wildcards (expand-file-name "*.org" org-directory))))))

          ("d" "Deadlines" alltodo ""
           ((org-agenda-overriding-columns-format "%25ITEM %DEADLINE")
            (org-agenda-view-columns-initially t)))

          ("G" "All tasks"
           ((todo "TODO"
                  ((org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'deadline 'scheduled))
                   (org-agenda-files (list "agenda.org" "notes.org" "projects.org"))
                   (org-agenda-prefix-format "  %i %-12:c [%e] ")
                   (org-agenda-overriding-header "\nTasks: Can be done\n")))
            (agenda nil
                    ((org-scheduled-past-days 0)
                     (org-deadline-warning-days 0)))))))

  (add-hook 'org-agenda-finalize-hook
            (lambda () (goto-char (point-min))) 100)

  :bind ("C-c a" . org-agenda))

(use-package org-agenda-property)

(use-package org-roam
  :after org
  :init
  (setq org-roam-database-connector 'sqlite-builtin
        org-roam-directory (file-truename (expand-file-name "org-roam/" org-directory))
        org-roam-db-location (expand-file-name "db/org-roam.db" org-roam-directory)
        org-roam-file-extensions '("org" "md" "txt")
        org-roam-completion-everywhere t)

  :config
  (unless (file-exists-p org-roam-directory)
    (make-directory org-roam-directory t))

  (org-roam-db-autosync-enable)

  (add-to-list 'display-buffer-alist
               '("\\*org-roam\\*"
                 (display-buffer-in-direction)
                 (direction . right)
                 (window-width . 0.33)
                 (window-height . fit-window-to-buffer)))

  (setq org-roam-capture-templates
        '(("o" "OrgRoamNote" plain "%?"
           :if-new
           (file+head "%<%Y%m%dT%H%M%S>-${slug}.org"
                      "#+TITLE: ${title}\n#+FILETAGS: ${tags}\n#+lastmod:\n")
           :unnarrowed t
           :immediate-finish t)))

  (setq time-stamp-start "#\\+lastmod: [\t]*")

  (defun org-roam-capture-at-point ()
    (interactive)
    (org-roam-capture 0))

  ;; ------------------------------------------ add node "type"
  (cl-defmethod org-roam-node-type ((node org-roam-node))
    "Return the TYPE of NODE."
    (condition-case nil
        (file-name-nondirectory
         (directory-file-name
          (file-name-directory
           (file-relative-name (org-roam-node-file node)
                               org-roam-directory))))
      (error "")))

  ;; ------------------------------------------ add node "keywords"
  (cl-defmethod org-roam-node-keywords ((node org-roam-node))
    "Return the currently set KEYWORDS for NODE."
    (cdr (assoc-string "KEYWORDS" (org-roam-node-properties node))))

  (setq org-roam-node-display-template
        (concat "${title:25}"
                (propertize "${type:10}"     'face 'org-tag)
                (propertize "${tags:20}"     'face 'org-tag)
                (propertize "${keywords:20}" 'face 'org-tag)
                "${file:20}"))

  ;; ---------------------------------- Convert org note to org-roam node
  (defun my-make-filepath (title now &optional zone)
    "Make filename from note TITLE and NOW time in the current time ZONE."
    (expand-file-name
     (concat (format-time-string "%Y%m%dT%H%M-" now (or zone (current-time-zone)))
             (org-roam--title-to-slug title) ".org")
     org-roam-directory))

  (defun my-insert-org-roam-file (file-path title &optional links sources text quote)
    "Insert org roam file in FILE-PATH with TITLE, LINKS, SOURCES, TEXT, QUOTE."
    (with-temp-file file-path
      (insert
       "#+TITLE: " title "\n\n"
       "- tags :: " (string-join links ", ") "\n"
       (if sources (concat "- source :: " (string-join sources ", ") "\n") "")
       "\n"
       (or text "") "\n\n"
       (if quote (concat "#+begin_src text\n" quote "\n#+end_src") "")))
    (with-current-buffer (find-file-noselect file-path)
      (org-id-get-create)
      (save-buffer)))

  (defun my-org-id-update-org-roam-files ()
    "Update Org-ID locations for all Org-roam files."
    (interactive)
    (org-roam-update-org-id-locations (org-roam-list-files)))

  (defun my-org-id-update-id-current-file ()
    "Scan the current buffer for Org-ID locations and update them."
    (interactive)
    (org-roam-update-org-id-locations (list (buffer-file-name))))

  (require 'org-roam-protocol)

  :bind ((:map org-mode-map
               ("C-c c p" . completion-at-point)
               ("C-c n o" . org-id-get-create)
               ("C-c n i" . org-roam-node-insert)
               ("C-c n t" . org-roam-tag-add)
               ("C-c n I" . org-roam-insert-immediate))
         (:map org-roam-mode-map
               ("C-c n f" . org-roam-node-find)
               ("C-c n g" . org-roam-graph))))

(use-package websocket
  :defer t)

(use-package org-roam-ui
  :after org-roam
  :init
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start nil))

(use-package vulpea
  :after org-roam
  :config
  (defun vulpea-project-p ()
    "Return non-nil if current buffer has any incomplete todo entry."
    (seq-find
     (lambda (type) (eq type 'todo))
     (org-element-map
         (org-element-parse-buffer 'headline)
         'headline
       (lambda (h) (org-element-property :todo-type h)))))

  (defun vulpea-project-update-tag ()
    "Update PROJECT tag in the current buffer."
    (when (and (not (active-minibuffer-window))
               (vulpea-buffer-p))
      (save-excursion
        (goto-char (point-min))
        (let* ((tags (vulpea-buffer-tags-get))
               (original-tags tags))
          (if (vulpea-project-p)
              (setq tags (cons "project" tags))
            (setq tags (remove "project" tags)))
          (setq tags (seq-uniq tags))
          (when (or (seq-difference tags original-tags)
                    (seq-difference original-tags tags))
            (apply #'vulpea-buffer-tags-set tags))))))

  (defun vulpea-buffer-p ()
    "Return non-nil if the currently visited buffer is an org-roam note."
    (and buffer-file-name
         (org-roam-file-p buffer-file-name)))

  (defun vulpea-project-files ()
    "Return a list of note files containing the \"project\" tag."
    (seq-uniq
     (seq-map
      #'car
      (org-roam-db-query
       [:select [nodes:file]
                :from tags
                :left-join nodes
                :on (= tags:node-id nodes:id)
                :where (like tag (quote "%\"project\"%"))]))))

  (defun vulpea-agenda-files-update (&rest _)
    "Update the value of `org-agenda-files'."
    (setq org-agenda-files
          (append
           (cl-remove-if
            (lambda (x) (string-match-p (regexp-quote ".#") x))
            (directory-files org-roam-directory t "\\.org\\'"))
           (vulpea-project-files))))

  (advice-add 'org-agenda    :before #'vulpea-agenda-files-update)
  (advice-add 'org-todo-list :before #'vulpea-agenda-files-update)

  :hook ((find-file-hook   . vulpea-project-update-tag)
         (before-save-hook . vulpea-project-update-tag)
         (org-roam-db-autosync-mode-hook . vulpea-db-autosync-enable)))

(use-package citeproc
  :defer t)

(use-package oc
  :straight (:type built-in)
  :after org
  :init
  (setq org-cite-insert-processor   'citar
        org-cite-follow-processor   'citar
        org-cite-activate-processor 'citar
        org-cite-global-bibliography
        (list (expand-file-name "bibliography-bibtex.bib" bibliography-directory)))
  :custom-face
  (org-cite     ((t (:foreground "green"))))
  (org-cite-key ((t (:foreground "red" :slant italic)))))

(use-package oc-bibtex
  :straight (:type built-in)
  :after oc)

(use-package org-appear
  :hook (org-mode-hook . org-appear-mode)
  :init
  (setq org-appear-autolinks t
        org-appear-autosubmarkers t
        org-appear-autoentities t
        org-appear-autoemphasis t
        org-appear-trigger 'always
        org-appear-delay 0.135))

(use-package org-table
  :straight (:type built-in)
  :init
  (setq org-table-export-default-format "orgtbl-to-csv"
        org-table-use-standard-references 'from
        org-startup-align-all-tables t)
  :config
  (setq org-table-copy-increment nil))

(use-package csv-mode
  :hook (csv-mode-hook . csv-align-mode)
  :config
  (setq csv-separators '("," "\t" ";")
        csv-comment-start "#"))

(use-package org-transclusion
  :config
  (add-to-list 'org-transclusion-extensions 'org-transclusion-indent-mode)
  (require 'org-transclusion-indent-mode))

(use-package org-element
  :straight (:type built-in)
  :commands (org-element-update-syntax))

(use-package org-indent
  :straight (:type built-in)
  :diminish org-indent-mode
  :hook (org-mode-hook . org-indent-mode))

(use-package org-clock
  :straight (:type built-in)
  :init
  (setq org-time-stamp-custom-formats '("<%Y-%m-%d>" . "<%Y-%m-%d %H:%M>")
        org-clock-persist-file (expand-file-name "org-clock-save.el" org-directory)
        org-time-stamp-rounding-minutes '(1 15))
  :config
  (setq org-duration-format '(:hours "%d" :require-hours t
                                     :minutes ":%02d" :require-minutes t))
  (setq-default org-display-custom-times t)
  (org-clock-persistence-insinuate))

(use-package org-timer
  :straight (:type built-in)
  :commands (org-timer-start org-timer-set-timer org-timer-pause-or-continue
                             org-timer-stop org-timer org-timer-item))

(use-package org-pandoc-import
  :straight (:host github
                   :repo "tecosaur/org-pandoc-import"
                   :files ("*.el" "filters" "preprocessors")))

(use-package org-mouse
  :straight (:type built-in)
  :config
  (setq org-mouse-1-follows-link 'double))

(use-package org-faces
  :straight (:type built-in))

(use-package org-list
  :straight (:type built-in)
  :config
  (setq org-list-allow-alphabetical t))

(use-package org-id
  :straight (:type built-in)
  :config
  (setq org-id-link-to-org-use-id t))

(use-package org-archive
    :straight (:type built-in)
    :init
    (setq org-archive-mark-done nil
          org-archive-location (concat (expand-file-name "archive.org" archives-dir)
                                       "::datetree/")))

(use-package org-recent-headings
  :config
  (org-recent-headings-mode 1))

(use-package org-attach
  :straight (:type built-in)
  :commands (org-attach))

(use-package org-attach-screenshot
  :config
  (setq org-attach-screenshot-dirfunction
        (lambda ()
          (cl-assert (buffer-file-name))
          (concat (file-name-sans-extension (buffer-file-name)) "-att"))
        org-attach-screenshot-command-line "screencapture -m %f"))

(use-package org-download
  :init
  (setq org-download-method 'directory
        org-download-image-dir (expand-file-name "images/" org-directory)
        org-download-heading-lvl nil
        org-download-timestamp "%Y%m%dT%H%M-"))

(use-package org-cliplink
  :commands (org-cliplink))

(use-package org-context
  :commands (org-context-activate))

(use-package nov
  :mode ("\\.epub\\'" . nov-mode))

(use-package djvu
  :mode ("\\.djvu\\'" . djvu-find-file))

(use-package outline
  :straight (:type built-in)
  :diminish outline-minor-mode
  :init
  (setq outline-minor-mode-prefix (kbd "C-c -"))
  :hook (emacs-lisp-mode-hook . outline-minor-mode))

(use-package outline-indent
  :custom
  (outline-indent-ellipsis " ▼")
  :hook ((python-mode-hook    . outline-indent-minor-mode)
         (python-ts-mode-hook . outline-indent-minor-mode)))

(use-package toc-org
  :hook (org-mode-hook . toc-org-enable))

(use-package ox
    :straight (:type built-in)
    :init
    (setq org-export-htmlize-output-type 'css
          org-export-output-directory-prefix "xport-")
    :config
    (defun delete-org-comments (_backend)
      "Remove all comment elements before export."
      (dolist (comment (reverse
                        (org-element-map
                            (org-element-parse-buffer)
                            'comment #'identity)))
        (delete-region (org-element-property :begin comment)
                       (org-element-property :end comment))))
    :commands (org-export-dispatch)
    :hook (org-export-before-processing-hook . delete-org-comments))

(use-package ox-latex
  :after (org)
  :init
  (setq org-latex-title-command           nil)
  (setq org-latex-default-figure-position "!htb")

  (setq org-export-with-timestamps       nil)
  (setq org-export-with-tags             nil)
  (setq org-export-with-todo-keywords    nil)
  (setq org-export-with-toc              nil)
  (setq org-export-with-section-numbers  t)
  (setq org-export-headline-levels       8)
  (setq org-export-with-sub-superscripts '{})
  :config
  (setq org-latex-preview-ltxpng-directory "~/Dropbox/org/images/")
  (setq org-latex-with-hyperref nil)

  ;; Default packages included in every tex file.
  (setq org-latex-packages-alist
        '(("" "graphicx"  t)
          ("" "longtable" nil)
          ("" "float"     nil)))

  (defvar my-pdflatex-packages
    '(("AUTO"      "inputenc"  t)
      ("T1"        "fontenc"   t)
      (""          "wrapfig"   nil)
      (""          "textcomp"  t)
      (""          "marvosym"  t)
      (""          "wasysym"   t)
      (""          "latexsym"  t)
      (""          "amssymb"   t)
      (""          "listings"  t)
      (""          "amstext"   t)
      (""          "mlmodern"  t)
      ("normalem"  "ulem"     t)
      (""          "hyperref"  nil))
    "Default packages for pdflatex export.")

  (defvar my-xelatex-packages
    '((""         "fontspec" t)
      (""         "url"      t)
      (""         "rotating" t)
      ("american" "babel"    t)
      ("babel"    "csquotes" t)
      ("svgnames" "xcolor"   t)
      (""         "soul"     t)
      (""         "minted"   t))
    "Default packages for xelatex export.")

  (defun my-auto-tex-cmd (_backend)
    "Set `org-latex-pdf-process' and default packages based on
LATEX_CMD keyword in the current buffer.  Supports pdflatex and
xelatex via latexmk."
    (let ((buf (buffer-string)))
      (cond
       ((string-match "LATEX_CMD: pdflatex" buf)
        (setq org-latex-default-packages-alist my-pdflatex-packages)
        (setq org-latex-pdf-process
              '("latexmk -pdf -pdflatex='pdflatex -file-line-error --shell-escape -synctex=1' %f")))
       ((string-match "LATEX_CMD: xelatex" buf)
        (setq org-latex-default-packages-alist my-xelatex-packages)
        (setq org-latex-src-block-backend 'minted)
        (setq org-latex-minted-options
              '(("frame"        "leftline")
                ("linenos"      "true")
                ("fontsize"     "\\footnotesize")
                ("samepage"     "")
                ("xrightmargin" "0.5cm")
                ("xleftmargin"  "0.5cm")))
        (setq org-latex-pdf-process
              '("latexmk -pdflatex='xelatex -file-line-error --shell-escape -synctex=1' -pdf %f")))
       (t
        (setq org-latex-pdf-process '("latexmk %f"))))))

  ;; Export article by placing "#+LaTeX_CLASS: my-article" in org file
  (add-to-list 'org-latex-classes
               '("my-article" "
\\documentclass[11pt, letterpaper, oneside]{article}
\\input{vc}

\\usepackage{gensymb}
\\usepackage[none]{hyphenat}
\\usepackage[style=authoryear-comp-ajs, abbreviate=true,
    maxbibnames=100, backend=bibtex,
    hyperref=true, backref=true, url=true]{bibtex}
\\usepackage[textwidth=6in, textheight=9in,
            marginparsep=6pt, marginparwidth=.5in]{geometry}

\\usepackage[hyperref]{xcolor}
\\usepackage{indentfirst}

\\usepackage[utf8]{inputenc}
\\usepackage[T1]{fontenc}
\\usepackage{longtable}
\\usepackage{float}
\\usepackage{wrapfig}
\\usepackage{rotating}
\\usepackage{amsmath}
\\usepackage{textcomp}
\\usepackage{marvosym}
\\usepackage{wasysym}
\\usepackage{amssymb}
\\usepackage{hyperref}
\\usepackage{mathptmx}
\\usepackage{helvet}
\\usepackage{courier}
\\usepackage{type1cm}
\\usepackage{makeidx}
\\usepackage{graphicx}
\\usepackage{multicol}
\\usepackage[bottom]{footmisc}

\\addbibresource{bibliography-bibtex.bib}
\\bibliography{References}

\\author{Your Name}
\\date{}

\\begin{document}
\\pagestyle{empty}
[NO-DEFAULT-PACKAGES] [EXTRA]"
("\\section{%s}"       . "\\section*{%s}")
("\\subsection{%s}"    . "\\subsection*{%s}")
("\\subsubsection{%s}" . "\\subsubsection*{%s}")
("\\paragraph{%s}"     . "\\paragraph*{%s}")
("\\subparagraph{%s}"  . "\\subparagraph*{%s}")))

  ;; Export book by placing "#+LaTeX_CLASS: my-book" in org file
  (add-to-list 'org-latex-classes
               '("my-book" "
\\documentclass[11pt, letterpaper]{book}
\\usepackage{filecontents}
\\usepackage[none]{hyphenat}
\\usepackage{makeidx}
\\usepackage[citestyle=authoryear-comp, isbn=false, citereset=chapter,
    maxcitenames=3, maxbibnames=100, backend=bibtex, hyperref=true,
    backref=true, url=true]{bibtex}

\\usepackage[textwidth=6in, textheight=9in, marginparsep=6pt,
  marginparwidth=.5in]{geometry}

\\usepackage[plainpages=false, pdfpagelabels, bookmarksnumbered]{hyperref}
\\usepackage[hyperref]{xcolor}

\\addbibresource{bibliography-bibtex.bib}
\\pagestyle{empty}
[NO-DEFAULT-PACKAGES] [EXTRA]"
("\\part{%s}"          . "\\part*{%s}")
("\\chapter{%s}"       . "\\chapter*{%s}")
("\\section{%s}"       . "\\section*{%s}")
("\\subsection{%s}"    . "\\subsection*{%s}")
("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

  :hook (org-export-before-parsing-hook . my-auto-tex-cmd)
  :commands (org-latex-export-to-pdf org-export-string-as org-latex-preview))

(use-package org-fragtog
  :init
  (setq org-startup-with-latex-preview t)
  :hook (org-mode-hook . org-fragtog-mode)
  :config
  (plist-put org-format-latex-options :scale 1.2))

(use-package ox-beamer
  :straight (:type built-in)
  :after ox-latex
  :custom
  (org-beamer-frame-level 2)
  (org-beamer-outline-frame-title nil)
  (org-beamer-outline-frame-options "plain")
  (org-beamer-cover-frame-title nil)
  (org-beamer-frame-default-options "\\transfade[duration=0.3]")
  :config
  (add-to-list 'org-beamer-environments-extra
               '("block" "B"
                 "\\begin{block}
                   %o{%h}"
                 "\\end{block}"))

  ;; Export presentation by placing "#+LaTeX_CLASS: my-beamer" in org file
  (add-to-list 'org-latex-classes
               '("my-beamer" "
      \\documentclass[presentation, bigger, xcolor=table, aspectratio=169]{beamer}
      \\usetheme{Warsaw}
      \\usecolortheme{dove}
      \\useoutertheme{sidebar}
      \\usefonttheme{professionalfonts}

      \\usepackage{beamerthemeshadow}
      \\usepackage{beamerouterthemeshadow}

      \\usepackage{array}
      \\usepackage{chemarrow}
      \\usepackage{verbatim}
      \\usepackage{colortbl}
      \\usepackage{tabularht}
      \\usepackage{calc}
      \\usepackage{multimedia}
      \\usepackage{enumerate}
      \\usepackage{appendixnumberbeamer}
      \\usepackage{grffile}
      \\usepackage{capt-of}
      \\usepackage{listings}
      \\usepackage{longtable}
      \\usepackage{float}
      \\usepackage{hyperref}

      \\setbeamertemplate{navigation symbols}{}
      \\setbeamercovered{transparent=30}
      \\setbeameroption{show notes}

      \\definecolor{maroon}{RGB}{128,26,64}
      \\definecolor{background}{RGB}{249,242,215}
      \\definecolor{title}{RGB}{107,174,214}
      \\definecolor{subtitle}{RGB}{102,255,204}
      \\definecolor{gray}{RGB}{155,155,155}
      \\definecolor{lightgray}{RGB}{107,110,108}
      \\definecolor{hilight}{RGB}{102,255,204}
      \\definecolor{vhilight}{RGB}{255,111,207}
      \\definecolor{lolight}{RGB}{155,155,155}
      \\definecolor{green}{RGB}{125,250,125}
      \\definecolor{red}{RGB}{230,37,52}
      \\definecolor{reddishbrown}{RGB}{182,101,70}
      \\definecolor{brown}{RGB}{118,91,52}
      \\definecolor{blue}{RGB}{86,152,200}
      \\definecolor{lightblue}{RGB}{22,190,207}

      \\setbeamercolor{title}{fg=black,      bg=gray}
      \\setbeamercolor{frametitle}{fg=black, bg=gray}
      \\setbeamercolor{normal text}{fg=black,bg=gray}
      \\setbeamercolor{item}{fg=blue}
      \\setbeamercolor{subitem}{fg=black}
      \\setbeamercolor{itemize/enumerate body}{fg=reddishbrown}
      \\setbeamercolor{itemize/enumerate subbody}{fg=brown}
      \\setbeamercolor{itemize/enumerate subsubbody}{fg=blue}

      \\setbeamerfont{itemize/enumerate subitem}{size=\\footnotesize}
      \\setbeamerfont{itemize/enumerate subbody}{shape=\\itshape}
      \\setbeamerfont{itemize/enumerate subbody}{size=\\footnotesize}
      \\setbeamerfont{note page}{family*=pplx,size=\\footnotesize}

      \\setbeamertemplate{section in toc}{\\inserttocsectionnumber . ~\\inserttocsection}
      \\setbeamertemplate{itemize items}[triangle]
      \\setbeamertemplate{itemize subitem}{{\\textendash}}
      \\setbeamertemplate{itemize subsubitem}{{\\textemdash}}
      \\setbeamertemplate{caption}{\\tiny\\insertcaption}
      \\setbeamertemplate{caption label separator}{}
      \\setbeamertemplate{footline}{
         \\raisebox{5pt}{
         \\makebox[\\paperwidth]{
         \\hfill\\makebox[20pt]{
         \\color{gray}\\scriptsize\\insertframenumber}}}
         \\hspace{5pt}
       }

      \\tolerance=1000
      \\providecommand{\\alert}[1]{\\textbf{#1}}

      \\lstset{numbers=none,tabsize=4,frame=single,basicstyle=\\small,showspaces=false,
      showstringspaces=false,showtabs=false,keywordstyle=\\color{blue}\\bfseries,
      commentstyle=\\color{red}}

      \\newcommand{\\hs}[1]{\\hspace{#1mm}}
      \\newcommand{\\hso}{\\hspace{1mm}}
      \\newcommand{\\hsf}{\\hspace{5mm}}
      \\newcommand{\\vs}[1]{\\vspace{#1mm}}
      \\newcommand{\\vso}{\\vspace{1mm}}
      \\newcommand{\\vsf}{\\vspace{5mm}}
      \\newcommand{\\jl}{$\\frac{}{}$}
      \\newcommand\\chl[1]{\\arrayrulecolor{#1}\\hline\\arrayrulecolor{blue}}
      \\newcommand{\\hsno}[1]{\\hspace{-#1 mm}}
      \\newcommand{\\ds}{\\displaystyle}
      \\newcommand{\\subt}[1]{{\\footnotesize\\color{blue}{#1}}}

      \\institute[Your Institution]{
      \\includegraphics[width=8cm]{~/pics/backgrounds/logo.png} \\\\
      \\vs{1}
      \\textcolor{maroon}{Your Institution} \\\\
      \\textcolor{darkgray}{Your Department}
      }

      \\date[]{\\scriptsize}

      \\author[you]{Your Name}
      \\logo{
      \\includegraphics[width=1.5cm,height=1.5cm]{~/pics/backgrounds/logo.png}
      }
      [NO-DEFAULT-PACKAGES] [EXTRA]"
                   ("\\section{%s}"       . "\\section*{%s}")
                   ("\\subsection{%s}"    . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                   ("\\paragraph{%s}"     . "\\paragraph*{%s}")
                   ("\\subparagraph{%s}"  . "\\subparagraph*{%s}"))))

(use-package htmlize
  :custom
  (htmlize-ignore-face-size nil)
  (htmlize-ignore-face-underline nil))

(use-package ox-reveal
  :straight (org-reveal :includes (ox-reveal))
  :bind ("C-c C-e R R" . org-reveal-export-to-html)
  :custom
  (org-reveal-root (concat "file://" (expand-file-name "~/reveal.js/")))
  (org-reveal-theme "moon")
  (org-reveal-transition "slide")
  (org-reveal-fragment-default "appear"))

(use-package request)

(use-package quarto-mode
  :mode "\\.Rmd")

(use-package citar
  :straight (citar :includes (citar-org))
  :preface
  (defun citar-setup-capf ()
    (add-to-list 'completion-at-point-functions #'citar-capf))
  :commands (citar-org-update-prefix-suffix)
  :hook (org-mode-hook . citar-setup-capf)
  :custom
  (citar-templates
   '((preview . "${author}   (${year issued date})  ${title}, ${journal}.\n")
     (main    . "${author:25} ${date year issued:4} ${title:100}")
     (suffix  . "${=type=:20} ${tags keywords:*}")
     (note    . "#+TITLE: Notes on ${author},       ${title}")))
  (citar-open-note-function 'orb-citar-edit-note)
  :config
  (setq citar-org-roam-sub-dir (concat org-roam-directory "citar-org-roam/"))
  (setq citar-notes-paths   (list (concat citar-org-roam-sub-dir "notes/")))
  (setq citar-library-paths (list (concat org-directory "library/")))
  (setq citar-bibliography org-cite-global-bibliography))

(use-package citar-embark
  :after (citar embark)
  :custom
  (citar-at-point-function 'embark-act)
  :config
  (citar-embark-mode))

(use-package org-roam-bibtex
  :after (org-roam bibtex)
  :config
  (org-roam-bibtex-mode))

(use-package citar-org-roam
  :after (org-roam citar)
  :custom
  (citar-org-roam-note-title-template "${author} - ${title}")
  (citar-org-roam-capture-template-key "M")
  :config
  (citar-org-roam-mode)

  (add-to-list 'org-roam-capture-templates
               '("p" "RegRef" plain "%?"
                 :if-new
                 (file+head "refs/%<%Y%m%dT%H%M%S>-${citar-citekey}.org"
                            "#+TITLE: ${citar-citekey} (${citar-date}) ${title}\n#+created: %U\n#+last_modified: %U\n#+FILETAGS:\n")
                 :unnarrowed t))

  (citar-register-notes-source
   'orb-citar-source (list :name     "Roam Nodes"
                           :category 'org-roam-node
                           :items    #'citar-org-roam--get-candidates
                           :hasitems #'citar-org-roam-has-notes
                           :open     #'citar-org-roam-open-note
                           :create   #'orb-citar-edit-note
                           :annotate #'citar-org-roam--annotate))

  (setq citar-notes-source 'orb-citar-source)

  (defun my-citar-org-roam--create-capture-note (citekey entry)
    "Open or create org-roam node for CITEKEY and ENTRY."
    (let ((title (citar-format--entry
                  citar-org-roam-note-title-template entry)))
      (org-roam-capture-
       :templates
       '(("r" "RegNote" plain "%?"
          :if-new
          (file+head
           "%(concat (when citar-org-roam-subdir (concat citar-org-roam-subdir \"/\")) \"${citekey}.org\")"
           "#+TITLE: ${title}\n\n#+begin_src bibtex\n%(my-citar-get-bibtex citekey)\n#+end_src\n")
          :immediate-finish t
          :unnarrowed t))
       :info (list :citekey citekey)
       :node (org-roam-node-create :title title)
       :props '(:finalize find-file))
      (org-roam-ref-add (concat "@" citekey))))

  (defun my-citar-get-bibtex (citekey)
    "Return the BibTeX entry for CITEKEY from bibliography files."
    (let ((org-cite-global-bibliography citar--bibliography-files))
      (with-temp-buffer
        (bibtex-set-dialect)
        (dolist (bib-file org-cite-global-bibliography)
          (insert-file-contents bib-file))
        (bibtex-search-entry citekey)
        (buffer-substring-no-properties (bibtex-beginning-of-entry)
                                        (bibtex-end-of-entry)))))

  (advice-add #'citar-org-roam--create-capture-note
              :override #'my-citar-org-roam--create-capture-note))

(use-package eval-in-repl
  :commands (eir-eval-in-repl)
  :custom
  (eir-jump-after-eval nil))

(use-package org-babel-eval-in-repl
  :after (org eval-in-repl))

(use-package ob-tangle
  :straight (:type built-in)
  :after org)

(use-package ob-async
  :after org)

(use-package org-src
  :straight (:type built-in)
  :after org
  :custom
  (org-edit-src-content-indentation 0)
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-src-window-setup 'current-window)
  (org-src-preserve-indentation t)
  (org-src-ask-before-returning-to-edit-buffer nil)
  (org-src-strip-leading-and-trailing-blank-lines t)
  (org-src-block-faces
   '(("emacs-lisp" (:background "#444444"))
     ("python"     (:background "#4b4b4b")))))

(use-package org-ai
  :bind (("C-c M-a C" . org-ai-refactor-code)
         :map org-mode-map
         ("C-c M-a s" . org-ai-summarize))
  :hook (org-mode-hook . org-ai-mode)
  :custom
  (org-ai-service 'openai)
  (org-ai-use-auth-source t)
  (org-ai-default-chat-model "gpt-5.4")
  (org-ai-default-max-tokens 2048)
  (org-ai-default-chat-system-prompt "You are a helpful and concise assistant.")
  (org-ai-default-inject-sys-prompt-for-all-messages t)
  (org-ai-jump-to-end-of-block nil)
  (org-ai-auto-fill t)
  (org-ai-image-model "dall-e-3")
  (org-ai-image-default-size "1792x1024")
  (org-ai-image-default-count 2)
  (org-ai-image-default-style 'vivid)
  (org-ai-image-default-quality 'hd)
  (org-ai-image-directory (expand-file-name "org-ai-images/" org-directory))
  :config
  (org-ai-install-yasnippets))

(use-package pretty-hydra)

(use-package page-break-lines
  :diminish page-break-lines-mode
  :hook (emacs-lisp-mode-hook . page-break-lines-mode))

(use-package comint
  :straight (:type built-in)
  :custom
  (password-cache t)
  (password-cache-expiry nil)
  (comint-buffer-maximum-size 100000)
  (comint-prompt-read-only t)
  (comint-scroll-to-bottom-on-input t)
  (comint-scroll-to-bottom-on-output nil)
  (comint-scroll-show-maximum-output t)
  (comint-completion-autolist t)
  (comint-input-ignoredups t)
  :config
  (setq comint-get-old-input (lambda () "")))

(use-package winum
  :demand t
  :config
  (winum-mode))

(use-package display-line-numbers
  :straight (:type built-in)
  :demand t
  :hook ((prog-mode-hook . display-line-numbers-mode)
         (text-mode-hook . display-line-numbers-mode))
  :config
  (if (daemonp)
      (add-hook 'after-make-frame-functions
                (lambda (frame)
                  (with-selected-frame frame
                    (set-face-attribute 'line-number-current-line nil
                                        :background "#3B4252" :foreground "#EFEFEF")
                    (dolist (buf (buffer-list))
                      (with-current-buffer buf
                        (when (derived-mode-p 'prog-mode 'text-mode 'bibtex-mode)
                          (unless display-line-numbers
                            (display-line-numbers-mode 1))
                          (font-lock-fontify-buffer)))))))
    (set-face-attribute 'line-number-current-line nil
                        :background "#3B4252" :foreground "#EFEFEF")))

(use-package fringe
  :straight (:type built-in)
  :custom
  (visual-line-fringe-indicators '(right-curly-arrow))
  (fringes-outside-margins t)
  (indicate-buffer-boundaries nil)
  (indicate-empty-lines nil)
  (overflow-newline-into-fringe t)
  :config
  (defface visual-line-wrap-face
    '((t (:foreground "green")))
    "Face for visual line fringe indicators."
    :group 'fringe)
  (set-fringe-bitmap-face 'right-curly-arrow 'visual-line-wrap-face)
  (fringe-mode '(0 . 12)))

(use-package recentf
  :straight (:type built-in)
  :hook (after-init-hook . recentf-mode)
  :custom
  (recentf-save-file "~/.emacs.d/recentf")
  (recentf-max-menu-items 25)
  (recentf-max-saved-items 50)
  (recentf-exclude
   '("/straight/" "/eln-cache/" "/tmp/"
     "~$" "github.*txt$" "/sudo:"
     "session\\.[a-f0-9]*$" "\\.elc$"
     "cookies" "\\.toc$" "\\.log$" "\\.aux$"
     "\\*message\\*" "auto-save-list\\*"
     "\\.\\(?:tar\\|tbz2?\\|tgz\\|bz2?\\|gz\\|gzip\\|xz\\|zip\\|7z\\|rar\\)$"
     "COMMIT_EDITMSG\\'"
     "\\.\\(?:gif\\|svg\\|png\\|jpe?g\\|bmp\\|xpm\\)$"
     "-autoloads\\.el$" "autoload\\.el$"))
  :config
  (setq recentf-menu-filter
        (lambda (list)
          (recentf-arrange-by-mode (recentf-show-basenames list))))
  (add-hook 'kill-emacs-hook #'recentf-cleanup -50))

(use-package desktop
  :straight (:type built-in)
  :demand t
  :custom
  (desktop-save 'ask-if-new)
  (desktop-files-not-to-save nil)
  (desktop-missing-file-warning nil)
  (desktop-lazy-idle-delay 1)
  (desktop-lazy-verbose nil)
  (desktop-dirname "~/.emacs.d/")
  (desktop-base-file-name ".desktop")
  (desktop-base-lock-name ".desktop.lock")
  (desktop-auto-save-timeout 300)
  (desktop-load-locked-desktop t)
  (desktop-restore-eager 2)
  (desktop-restore-frames nil)
  (desktop-restore-forces-onscreen nil)
  (desktop-restore-in-current-display nil)
  (desktop-globals-to-clear nil)
  (desktop-globals-to-save '(search-ring
                             regexp-search-ring))
  (desktop-locals-to-save '(truncate-lines
                            fill-column
                            overwrite-mode
                            line-number-mode
                            column-number-mode
                            buffer-file-coding-system
                            buffer-display-time
                            indent-tabs-mode
                            tab-width
                            indicate-empty-lines
                            show-trailing-whitespace))
  :config
  (dolist (mode '(dired-mode Info-mode))
    (add-to-list 'desktop-modes-not-to-save mode))
  (desktop-save-mode))

(use-package treemacs
  :bind (("M-0"       . treemacs-select-window)
         ("C-x t 1"   . treemacs-delete-other-windows)
         ("C-x t t"   . treemacs)
         ("<f8>"      . treemacs)
         ("C-x t d"   . treemacs-select-directory)
         ("C-x t B"   . treemacs-bookmark)
         ("C-x t C-t" . treemacs-find-file)
         ("C-x t M-t" . treemacs-find-tag))
  :custom
  (treemacs-follow-after-init t)
  (treemacs-is-never-other-window t)
  (treemacs-goto-tag-strategy 'refetch-index)
  (treemacs-persist-file (expand-file-name ".cache/treemacs-persist" user-emacs-directory))
  (treemacs-recenter-after-project-jump 'always)
  (treemacs-recenter-after-project-expand 'on-distance)
  (treemacs-litter-directories '("/node_modules" "/.venv"))
  (treemacs-width 30)
  (treemacs-wide-toggle-width 60)
  :config
  (setq treemacs-collapse-dirs (if treemacs-python-executable 3 0))
  (treemacs-resize-icons 44)
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode 'always))

(use-package stripe-buffer
  :hook (dired-mode-hook . stripe-buffer-mode))

(use-package trashed
  :commands (trashed)
  :custom
  (trashed-action-confirmer 'y-or-n-p)
  (trashed-use-header-line t)
  (trashed-date-format "%Y%m%dT%H%M"))

(use-package autorevert
  :straight (:type built-in)
  :diminish auto-revert-mode
  :hook (after-init-hook . global-auto-revert-mode)
  :custom
  (auto-revert-interval 3)
  (auto-revert-remote-files nil)
  (auto-revert-use-notify t)
  (auto-revert-avoid-polling nil)
  (auto-revert-verbose t)
  (global-auto-revert-non-file-buffers t))

(fset 'display-startup-echo-area-message #'ignore)

(use-package scratch
  :commands (scratch))

(use-package persistent-scratch
  :demand t
  :config
  (persistent-scratch-setup-default))

(use-package bookmark
  :straight (:type built-in)
  :hook (bookmark-bmenu-mode-hook . hl-line-mode)
  :custom
  (bookmark-sort-flag 'last-modified)
  (bookmark-save-flag 1))

(defvar default-gc-cons-threshold (* 128 1024 1024)
  "Default `gc-cons-threshold' during normal emacs operations.")

(defun gc-minibuffer-setup-hook ()
  "Disable garbage collection in minibuffer."
  (setq gc-cons-threshold most-positive-fixnum))

(defun gc-minibuffer-exit-hook ()
  "Restore garbage collection after minibuffer exit."
  (garbage-collect)
  (setq gc-cons-threshold default-gc-cons-threshold))

(use-package minibuffer
  :straight (:type built-in)
  :bind (:map minibuffer-local-map
              ("C-w" . backward-kill-word))
  :hook ((minibuffer-setup-hook . gc-minibuffer-setup-hook)
         (minibuffer-exit-hook  . gc-minibuffer-exit-hook)))

(use-package isearch
  :straight (:type built-in)
  :init
  (setq-default case-fold-search t)
  (setq isearch-case-fold-search 'yes)
  (setq isearch-wrap-pause 'no)
  (setq isearch-allow-scroll t)
  (setq isearch-lazy-count t
        lazy-count-prefix-format "(%s/%s) "
        lazy-count-suffix-format nil
        lazy-highlight-initial-delay 0)
  :config
  (setq lazy-highlight-cleanup t
        lazy-highlight-max-at-a-time nil)
)

(use-package isearch-mb
  :after isearch
  :init
  (isearch-mb-mode)
  :config
  ;; Hand off to consult commands from isearch
  (add-to-list 'isearch-mb--with-buffer #'consult-isearch-history)
  (add-to-list 'isearch-mb--after-exit #'consult-line)
  (add-to-list 'isearch-mb--after-exit #'consult-ripgrep))

(use-package grep
  :straight (:type built-in)
  :bind
  (("M-s g" . rgrep)))

(use-package wgrep
  :config
  (setq wgrep-auto-save-buffer t)
  :bind (:map grep-mode-map
              ("C-x C-q" . wgrep-change-to-wgrep-mode)
              ("C-c C-c" . wgrep-finish-edit)))

(use-package replace
  :straight (:type built-in)
  :config
  (setq list-matching-lines-jump-to-current-line t)
  :bind
  (("M-s o" . occur)))

(use-package vertico
  :straight (vertico :files (:defaults "extensions/*")
                     :includes (vertico-indexed
                                vertico-flat
                                vertico-grid
                                vertico-mouse
                                vertico-buffer
                                vertico-repeat
                                vertico-reverse
                                vertico-directory
                                vertico-multiform
                                vertico-unobtrusive))
  :custom
  (vertico-count 50)
  (vertico-resize t)
  (vertico-cycle t)
  :bind (:map vertico-map
              ("C-g"   . minibuffer-keyboard-quit)
              ("?"     . minibuffer-completion-help)
              ("M-RET" . minibuffer-force-complete-and-exit)
              ("M-TAB" . minibuffer-complete)
              ("<tab>" . vertico-insert)
              ("C-M-n" . vertico-next-group)
              ("C-M-p" . vertico-previous-group))
  :hook ((minibuffer-setup-hook . vertico-repeat-save)
         (after-init-hook . vertico-mode)))

(use-package vertico-directory
  :after vertico
  :hook (rfn-eshadow-update-overlay-hook . vertico-directory-tidy)
  :bind (:map vertico-map
              ("RET"          . vertico-directory-enter)
              ("<backspace>"  . vertico-directory-delete-char)
              ("C-w"          . vertico-directory-delete-word)
              ("C-<backspace>" . vertico-directory-delete-word)))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides
   '((file (styles basic partial-completion))))
  (orderless-component-separator 'orderless-escapable-split-on-space)
  (orderless-matching-styles
   '(orderless-prefixes
     orderless-initialism
     orderless-regexp)))

;; Display Vertico in a child frame
(use-package vertico-posframe
  :after vertico
  :init
  (setq vertico-posframe-poshandler #'posframe-poshandler-frame-top-center)
  (setq vertico-posframe-parameters
        '((left-fringe . 8)
          (right-fringe . 8)))
  (vertico-posframe-mode 1))

(use-package savehist
  :straight (:type built-in)
  :custom
  (savehist-autosave-interval 600)
  (savehist-additional-variables
   '(kill-ring
     register-alist
     mark-ring global-mark-ring
     search-ring regexp-search-ring))
  :hook (after-init-hook . savehist-mode))

(use-package marginalia
  :custom
  (marginalia-align 'right)
  :hook (after-init-hook . marginalia-mode)
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle)))

(use-package embark
  :init
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none))))
  :hook (eldoc-documentation-functions-hook . embark-eldoc-first-target)
  :bind (("C-S-a" . embark-act)
         ("C-;"   . embark-dwim)
         ("C-h B" . embark-bindings)
         :map minibuffer-local-map
         ("C-c C-c" . embark-collect)
         ("C-c C-e" . embark-export)))

(use-package consult
  :init
  (setq register-preview-delay 0.5)
  (setq register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window)
  (setq xref-show-xrefs-function #'consult-xref)
  (setq xref-show-definitions-function #'consult-xref)
  :config
  (setq consult-project-function #'project-current)
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep
   consult-grep
   consult-bookmark
   consult-recent-file
   consult-xref
   consult--source-bookmark
   consult--source-file-register
   consult--source-recent-file
   consult--source-project-recent-file :preview-key '(:debounce 0.4 any))
  (setq consult-narrow-key "<")
  :hook (completion-list-mode-hook . consult-preview-at-point-mode)
  :bind (("M-s M-c" . consult-bookmark)
         ("M-s M-f" . consult-find)
         ("M-s M-g" . consult-grep)
         ("M-s M-l" . consult-line)
         ("M-s M-L" . consult-line-multi)
         ("M-s M-o" . consult-outline)
         ("M-s M-b" . consult-buffer)
         ("M-s M-r" . consult-recent-file)

         ("C-x M-:" . consult-complex-command)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame)
         ("C-x t b" . consult-buffer-other-tab)
         ("C-x p b" . consult-project-buffer)

         ("M-#"   . consult-register-load)
         ("M-'"   . consult-register-store)
         ("C-M-#" . consult-register)

         ("M-y"   . consult-yank-pop)

         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)
         ("M-g g" . consult-goto-line)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)

         ("M-s c" . consult-locate)
         ("M-s r" . consult-ripgrep)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ("M-s e" . consult-isearch-history)

         ("C-c M-x" . consult-mode-command)
         ("M-s h"   . consult-history)
         ("M-s m"   . consult-man)
         ("M-s i"   . consult-info)

         :map isearch-mode-map
         ("M-s e"   . consult-isearch-history)
         ("M-s M-l" . consult-line)
         ("M-s M-L" . consult-line-multi)

         :map Info-mode-map
         ("s" . consult-info)

         :map minibuffer-local-map
         ("M-s" . consult-history)
         ("M-r" . consult-history)))

(use-package embark-consult
  :after (embark consult)
  :hook (embark-collect-mode-hook . consult-preview-at-point-mode))

(use-package consult-project-extra
  :after consult
  :bind (("M-s M-p" . consult-project-extra-find)))

(use-package helpful
  :custom
  (helpful-max-buffers 7)
  :bind
  (([remap describe-command]  . helpful-command)
   ([remap describe-function] . helpful-callable)
   ([remap describe-key]      . helpful-key)
   ([remap describe-symbol]   . helpful-symbol)
   ([remap describe-variable] . helpful-variable)))

(use-package emacs
  :straight (:type built-in)
  :init
  (setq ad-redefinition-action 'accept)
  :config
  (defvar my--cursor-color-cache "" "Last cursor color set.")
  (defvar my--cursor-color-buffer nil "Last buffer where cursor color was set.")

  (defun my-set-cursor-color-according-to-mode ()
    "Change cursor color according to some minor modes."
    (let ((color (cond (buffer-read-only "purple")
                       (overwrite-mode "red")
                       (t "green"))))
      (unless (and (string= color my--cursor-color-cache)
                   (eq (current-buffer) my--cursor-color-buffer))
        (set-cursor-color (setq my--cursor-color-cache color))
        (setq my--cursor-color-buffer (current-buffer)))))

  :hook (post-command-hook . my-set-cursor-color-according-to-mode))

(use-package beacon
  :config
  (setq beacon-push-mark 35)
  (setq beacon-color "#d65d0e")
  (setq beacon-size 20)
  :hook (after-init-hook . beacon-mode))

(use-package emacs
  :straight (:type built-in)
  :config
  (setq-default next-screen-context-lines 1)
  (setq auto-window-vscroll nil))

(use-package mouse
  :straight (:type built-in)
  :config
  (context-menu-mode 1)
  (setq make-pointer-invisible t)
  (setq mouse-drag-copy-region nil)
  (setq mouse-drag-and-drop-region t))

(use-package emacs
  :straight (:type built-in)
  :config
  ;; Highlight marked region
  (setq mark-even-if-inactive t)
  ;; Shift works with cursor keys
  (setq shift-select-mode     t)

  (setq delete-by-moving-to-trash t)

  ;; Clipboard
  ;; ------------- cutting and pasting uses primary selection
  (setq select-enable-primary t)
  ;; ----------- clipboard to copy-and-paste between programs
  (setq select-enable-clipboard t)
  ;; ------------------ active region sets primary selection
  (setq select-active-regions t)
  ;; Save clipboard strings into kill ring before replacing them
  (setq save-interprogram-paste-before-kill t))

(use-package emacs
  :straight (:type built-in)
  :init
  (setq apropos-do-all t)
  (setq inhibit-quit nil)
  (setq echo-keystrokes 0.02)
  (setq query-user-mail-address nil)
  (setq sentence-end-double-space nil)
  (setq colon-double-space nil)
  (setq use-hard-newlines nil)

  (setq user-full-name (or (getenv "USER_FULL_NAME") "Your Name"))
  (setq user-mail-address (or (getenv "EMAIL") "your-email@example.com"))

  (defvar my-user-short-name (or (getenv "USER_FULL_NAME") "Your Name"))
  (defvar my-user-first-name "Your")
  (defvar my-user-last-name "Name")

  :config
  (setq x-underline-at-descent-line t)
  (setq byte-compile-warnings '(not cl-functions free-vars unresolved noruntime lexical
                                     make-local))
  (setq describe-char-unidata-list '(name general-category canonical-combining-class
                                          bidi-class decomposition decimal-digit-value
                                          digit-value numeric-value mirrored uppercase
                                          lowercase titlecase))
  (setq-default bidi-inhibit-bpa t)
  (setq-default idle-update-delay 1)
  (setq-default track-eol nil)
  (size-indication-mode 1)
  (setq-default tab-first-completion 'word-or-paren-or-punct)
  (setq-default indent-tabs-mode nil)

  :hook (after-init-hook . column-number-mode))

(use-package emacs
  :straight (:type built-in)
  :init
  (setq use-short-answers t)
  (setq left-margin-width 2)
  (setq right-margin-width 2)
  :hook (org-mode-hook . visual-line-mode))

(use-package visual-fill-column
  :custom
  (visual-fill-column-center-text nil)
  (visual-fill-column-width 100)
  (visual-fill-column-enable-sensible-window-split t)
  (visual-fill-column-adjust-for-text-scale t)
  :config
  (advice-add 'text-scale-adjust :after #'visual-fill-column-adjust)
  (add-hook 'visual-fill-column-mode-hook
            (lambda ()
              (display-fill-column-indicator-mode
               (if visual-fill-column-mode -1 1))))
  :hook (visual-line-mode-hook . visual-fill-column-mode))

(use-package logos
  :custom
  (logos-outlines-are-pages t)
  (logos-hide-mode-line t)
  :bind (([remap narrow-to-region] . logos-narrow-dwim)
         ([remap forward-page]     . logos-forward-page-dwim)
         ([remap backward-page]    . logos-backward-page-dwim)))

(use-package wc-mode
  :hook (org-mode-hook . wc-mode))

(use-package tmr
  :bind ("C-c t" . tmr))

(use-package emacs
  :straight (:type built-in)
  :config
  (dolist
      (cmd '(scroll-left downcase-region upcase-region
                         narrow-to-region narrow-to-page eval-expression
                         set-goal-column erase-buffer narrow-to-defun
                         dired-find-alternate-file))
    (put cmd 'disabled nil)))

(use-package dired
  :straight (:type built-in)
  :init
  (setq dired-recursive-deletes 'always)
  (setq dired-recursive-copies  'always)
  (setq dired-listing-switches "-la")
  :config
  (defvar my-dired-switches
    '("-l" "-la" "-lA --group-directories-first")
    "List of ls switches for dired to cycle through.")

  (defun my-cycle-dired-switches ()
    "Cycle through `my-dired-switches'."
    (interactive)
    (setq my-dired-switches
          (append (cdr my-dired-switches)
                  (list (car my-dired-switches))))
    (dired-sort-other (car my-dired-switches)))

  (defun my-dired-ediff-files ()
    "Ediff the two marked files in dired."
    (interactive)
    (let ((files (dired-get-marked-files))
          (wnd (current-window-configuration)))
      (if (<= (length files) 2)
          (let ((file1 (car files))
                (file2 (if (cdr files)
                           (cadr files)
                         (read-file-name
                          "file: "
                          (dired-dwim-target-directory)))))
            (if (file-newer-than-file-p file1 file2)
                (ediff-files file2 file1)
              (ediff-files file1 file2))
            (add-hook 'ediff-after-quit-hook-internal
                      (lambda ()
                        (setq ediff-after-quit-hook-internal nil)
                        (set-window-configuration wnd))))
        (error "No more than 2 files should be marked"))))
  :bind (:map dired-mode-map
              ("z" . my-cycle-dired-switches)
              ("=" . my-dired-ediff-files))
  :hook (dired-mode-hook . dired-hide-details-mode))

(use-package dired-single
  :bind (:map dired-mode-map
              ([remap dired-find-file] . dired-single-buffer)
              ([remap dired-up-directory] . dired-single-up-directory)))

(use-package dired-x
  :straight (:type built-in)
  :init
  (setq dired-omit-case-fold nil)
  (setq dired-omit-verbose nil)
  :config
  (setq dired-omit-files
        (concat dired-omit-files
                "\\|^\\.git\\|^\\.svn$\\|\\.meta$\\|\\.elc$\\|^\\.emacs"))
  :hook (dired-mode-hook . dired-omit-mode))

(use-package wdired
  :straight (:type built-in)
  :bind (:map dired-mode-map
              ("E" . wdired-change-to-wdired-mode)))

(use-package nerd-icons
  :custom
  (nerd-icons-font-family "Symbols Nerd Font Mono")
  :config
  (unless (file-exists-p (expand-file-name "~/.local/share/fonts/nerd-icons.ttf"))
    (nerd-icons-install-fonts 'install-without-asking)))

(use-package nerd-icons-dired
  :hook (dired-mode-hook . nerd-icons-dired-mode)
  :custom
  (nerd-icons-dired-monochrome nil))

(use-package nerd-icons-completion
  :after (marginalia nerd-icons)
  :hook (marginalia-mode-hook . nerd-icons-completion-marginalia-setup)
  :config
  (nerd-icons-completion-mode))

(use-package emacs
  :straight (:type built-in)
  :init
  (setq display-warning-minimum-level 'error)
  (setq confirm-nonexistent-file-or-buffer nil))

(use-package saveplace
  :straight (:type built-in)
  :init
  (setq save-place-file (expand-file-name "~/.emacs.d/.my-saveplaces"))
  (setq save-place-ignore-files-regexp
   "\\(?:COMMIT_EDITMSG\\|eln-cache\\|straight\\|bzr_log\\.[[:alnum:]]+\\)$")
  (setq save-place-forget-unreadable-files t)
  :hook (after-init-hook . save-place-mode)
  :custom
  (save-place-limit 400))

(use-package image-file
  :straight (:type built-in)
  :hook (after-init-hook . auto-image-file-mode))

(use-package uniquify
  :straight (:type built-in)
  :init
  (setq uniquify-buffer-name-style   'post-forward)
  (setq uniquify-min-dir-content      2)
  (setq uniquify-separator           ":")
  (setq uniquify-after-kill-buffer-p  t)
  (setq uniquify-ignore-buffers-re   "^\\*"))

(use-package emacs
  :straight (:type built-in)
  :config
  (defun my-close-all-buffers ()
    "Kill all buffers besides the current one."
    (interactive)
    (mapc #'kill-buffer (delq (current-buffer) (buffer-list))))

  (defun my-nuke-all-buffers ()
    "Kill all buffers, leaving *scratch* only."
    (interactive)
    (mapc #'kill-buffer (buffer-list))
    (delete-other-windows)))

(use-package ibuffer
  :straight (:type built-in)
  :config
  (setq ibuffer-formats
        '((mark-modified-buffer " "
                                (name-only         60 0 1)
                                " "
                                (size-h            9 right)
                                " "
                                (mode              16 right)
                                " "
                                (read-only-flag    3 right)
                                " "
                                (project-name      15 left)
                                " "
                                (age               5 right)
                                " "
                                (filename-and-dir  0 left))))
  (setq ibuffer-sorting-mode 'alphabetic)
  (setq ibuffer-show-full-path t)
  (setq ibuffer-show-empty-groups nil)
  (setq ibuffer-expert t)
  :hook (ibuffer-mode-hook . hl-line-mode)
  :bind ([remap list-buffers] . ibuffer))

(use-package ibuffer-project
  :config
  (setq ibuffer-project-use-cache t)
  :hook (ibuffer-mode-hook . my-ibuffer-project-setup))

(defun my-ibuffer-project-setup ()
  "Set up ibuffer-project filter groups and sorting."
  (setq ibuffer-filter-groups
        (ibuffer-project-generate-filter-groups))
  (unless (eq ibuffer-sorting-mode 'alphabetic)
    (ibuffer-do-sort-by-alphabetic)))

(use-package whitespace
  :straight (:type built-in)
  :diminish whitespace-mode
  :custom
  (whitespace-display-mappings
   '((space-mark ?\xA0 [?\xA4] [?_])
     (tab-mark   9 [183 9] [92 9])))
  :init
  (setq search-whitespace-regexp ".*?")
  (setq show-trailing-whitespace nil)
  (setq whitespace-line-column 100)
  :config
  (setq-default whitespace-style
                '(trailing spaces empty tab-mark tabs
                  space-before-tab space-mark lines-tail))

  (defun my-whitespace-cleanup-on-save ()
    "Clean up whitespace on save without marking unmodified buffers as modified."
    (let ((modified-p (buffer-modified-p)))
      (whitespace-cleanup)
      (unless modified-p
        (set-buffer-modified-p nil))))

  (add-hook 'before-save-hook #'my-whitespace-cleanup-on-save)
  :hook ((text-mode-hook prog-mode-hook) . whitespace-mode))

(use-package files
  :straight (:type built-in)
  :init
  (setq confirm-kill-processes nil)
  (setq require-final-newline t)
  (setq find-file-existing-other-name t)
  (setq enable-local-variables t)
  (setq enable-local-eval 'maybe)
  (setq large-file-warning-threshold (* 30 1000 1000))

  (setq auto-save-default t)
  (setq auto-save-interval 600)
  (setq auto-save-timeout 700)
  (setq auto-save-visited-interval 60)

  (setq backup-directory-alist
        `(("." . ,(expand-file-name "~/.emacs.d/lisp/backups/"))))
  (setq delete-old-versions t)
  (setq kept-new-versions 1)
  (setq kept-old-versions 1)

  :config
  (auto-save-visited-mode 1)

  (defun my-rename-current-buffer-file ()
    "Rename current buffer and file it is visiting."
    (interactive)
    (let ((name (buffer-name))
          (filename (buffer-file-name)))
      (if (not (and filename (file-exists-p filename)))
          (error "Buffer '%s' is not visiting a file!" name)
        (let ((new-name (read-file-name "New name: " filename)))
          (if (get-buffer new-name)
              (error "A buffer named '%s' already exists!" new-name)
            (rename-file filename new-name 1)
            (rename-buffer new-name)
            (set-visited-file-name new-name)
            (set-buffer-modified-p nil)
            (message "File '%s' successfully renamed to '%s'"
                     name (file-name-nondirectory new-name)))))))

  (defun my-delete-current-buffer-file ()
    "Remove file connected to current buffer and kill buffer."
    (interactive)
    (let ((filename (buffer-file-name))
          (buffer (current-buffer)))
      (if (not (and filename (file-exists-p filename)))
          (kill-buffer)
        (when (yes-or-no-p "Are you sure you want to remove this file? ")
          (delete-file filename)
          (kill-buffer buffer)
          (message "File '%s' successfully removed" filename)))))

  (defun my-reopen-file-as-root ()
    "Reopen current file as root via TRAMP."
    (interactive)
    (when buffer-file-name
      (find-alternate-file
       (concat "/sudo:root@localhost:" buffer-file-name))))

  (defun my-set-file-executable ()
    "Add executable permissions on current file."
    (interactive)
    (when (buffer-file-name)
      (set-file-modes buffer-file-name
                      (logior (file-modes buffer-file-name) #o100))
      (message "Made %s executable" buffer-file-name))))

(use-package compile
  :straight (:type built-in)
  :init
  (setq compile-command "compile")
  (setq compilation-scroll-output t)
  :config
  (defun my-compilation-auto-dismiss (buf str)
    "Dismiss compilation window after successful compilation."
    (unless (string-match "exited abnormally" str)
      (run-at-time "0.2 sec" nil
                   (lambda ()
                     (when-let* ((win (get-buffer-window buf)))
                       (quit-window nil win))))
      (message "No Compilation Errors!")))

  (add-hook 'compilation-finish-functions #'my-compilation-auto-dismiss))

(use-package delsel
  :straight (:type built-in)
  :hook (after-init-hook . delete-selection-mode))

(use-package visible-mark
  :init
  (setq visible-mark-max 2)
  (setq visible-mark-faces '(visible-mark-face1 visible-mark-face2))
  :config
  (set-face-attribute 'region nil :background "light grey")
  (global-visible-mark-mode 1))

(use-package abbrev
  :straight (:type built-in)
  :diminish abbrev-mode
  :init
  (setq abbrev-file-name "~/.emacs.d/lisp/my-abbrevs.el")
  (setq save-abbrevs 'silently)
  :config
  (when (file-exists-p abbrev-file-name)
    (quietly-read-abbrev-file))
  :hook (prog-mode-hook . abbrev-mode))

(use-package flycheck
  :config
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (setq-default flycheck-highlighting-mode 'lines)
  (add-to-list 'flycheck-checkers 'proselint)
  :hook (flycheck-error-list-mode-hook . visual-fill-column-mode))

(use-package flycheck-indicator
  :config
  (setq flycheck-indicator-icon-error ?!)
  (setq flycheck-indicator-icon-info ?·)
  (setq flycheck-indicator-icon-warning ?*)
  (setq flycheck-indicator-status-icons
        '((not-checked "%")
          (no-checker "-")
          (running "&")
          (errored "!")
          (finished "=")
          (interrupted "#")
          (suspicious "?")))
  :hook (flycheck-mode-hook . flycheck-indicator-mode))

(use-package flycheck-package
  :after flycheck
  :config
  (flycheck-package-setup))

(use-package emacs
  :straight (:type built-in)
  :config
  (setq undo-limit 67108864)            ; 64 MB soft limit
  (setq undo-strong-limit 100663296)    ; 96 MB strong limit
  (setq undo-outer-limit 1006632960))   ; ~960 MB outer limit

(use-package vundo
  :bind ("C-x u" . vundo)
  :hook ((prog-mode-hook text-mode-hook) . vundo-popup-mode))

(use-package expand-region
  :init
  (setq er--show-expansion-message t)
  :bind (("C-=" . er/expand-region)
         ("C-<" . er/contract-region)))

(use-package region-bindings-mode
  :diminish region-bindings-mode
  :init
  (setq region-bindings-mode-disabled-modes '(dired-mode))
  :bind (:map region-bindings-mode-map
              ("l"  . mc/edit-lines)
              ("#"  . mc/insert-numbers)
              ("c"  . mc/insert-letters)
              ("b"  . mc/edit-beginnings-of-lines)
              ("e"  . mc/edit-ends-of-lines))
  :hook ((prog-mode-hook text-mode-hook) . region-bindings-mode-enable))

(use-package multiple-cursors
  :config
  (set-face-attribute 'mc/cursor-face nil :foreground "cyan")
  :bind (("C->" . mc/mark-next-like-this)
         ("C-S-<mouse-1>" . mc/add-cursor-on-click)))

(use-package emacs
  :straight (:type built-in)
  :config
  (defun my-backward-word ()
    "Move one word backward, treating _ as part of word."
    (interactive)
    (backward-word 1)
    (backward-char 1)
    (cond ((looking-at "_") (my-backward-word))
          (t (forward-char 1))))

  (defun my-forward-word ()
    "Move one word forward to start of next word, treating _ as part of word."
    (interactive)
    (forward-char 1)
    (backward-word 1)
    (forward-word 2)
    (backward-word 1)
    (backward-char 1)
    (cond ((looking-at "_") (forward-char 1) (my-forward-word))
          (t (forward-char 1))))

  (defun my-delete-word (arg)
    "Delete characters forward until encountering the end of a word.
With argument ARG, do this that many times."
    (interactive "p")
    (delete-region (point) (progn (forward-word arg) (point))))

  (defun my-backward-delete-word (arg)
    "Delete characters backward until encountering the end of a word.
With argument ARG, do this that many times."
    (interactive "p")
    (my-delete-word (- arg)))

  :bind (("M-f" . my-forward-word)
         ("M-b" . my-backward-word)))

(use-package emacs
  :straight (:type built-in)
  :init
  (setq mode-require-final-newline 'visit-save)
  (setq next-line-add-newlines nil)
  (setq kill-whole-line t))

(use-package emacs
  :straight (:type built-in)
  :config
  (defun my-char-case-toggle ()
    "Toggle letter case of current word or text selection.
Cycles between: all lower, Init Caps, ALL CAPS."
    (interactive)
    (let (p1 p2 (deactivate-mark nil) (case-fold-search nil))
      (if (region-active-p)
          (setq p1 (region-beginning) p2 (region-end))
        (let ((bds (bounds-of-thing-at-point 'word)))
          (setq p1 (car bds) p2 (cdr bds))))
      (unless (eq last-command this-command)
        (save-excursion
          (goto-char p1)
          (cond
           ((looking-at "[[:lower:]][[:lower:]]")
            (put this-command 'state "all lower"))
           ((looking-at "[[:upper:]][[:upper:]]")
            (put this-command 'state "all caps"))
           ((looking-at "[[:upper:]][[:lower:]]")
            (put this-command 'state "init caps"))
           ((looking-at "[[:lower:]]")
            (put this-command 'state "all lower"))
           ((looking-at "[[:upper:]]")
            (put this-command 'state "all caps"))
           (t (put this-command 'state "all lower")))))
      (cond
       ((string= "all lower" (get this-command 'state))
        (upcase-initials-region p1 p2)
        (put this-command 'state "init caps"))
       ((string= "init caps" (get this-command 'state))
        (upcase-region p1 p2)
        (put this-command 'state "all caps"))
       ((string= "all caps" (get this-command 'state))
        (downcase-region p1 p2)
        (put this-command 'state "all lower"))))))

(use-package emacs
  :straight (:type built-in)
  :config
  (defun my-block-compact-uncompact ()
    "Toggle between filling and unfilling the current paragraph or region."
    (interactive)
    (let* ((deactivate-mark nil)
           (bds (bounds-of-thing-at-point 'line))
           (line-len (length (buffer-substring-no-properties (car bds) (cdr bds))))
           (compact-p (if (eq last-command this-command)
                          (get this-command 'compact-p)
                        (> line-len fill-column))))
      (save-excursion
        (if (region-active-p)
            (if compact-p
                (fill-region (region-beginning) (region-end))
              (let ((fill-column most-positive-fixnum))
                (fill-region (region-beginning) (region-end))))
          (if compact-p
              (fill-paragraph nil)
            (let ((fill-column most-positive-fixnum))
              (fill-paragraph nil))))
        (put this-command 'compact-p (not compact-p))))))

(use-package emacs
  :straight (:type built-in)
  :config
  (defun my-fill-paragraph-and-separate (&optional arg)
    "Fill the current paragraph and add a line of dashes after it."
    (interactive "p")
    (save-excursion
      (mark-paragraph)
      (fill-paragraph arg)
      (goto-char (region-end))
      (unless (looking-at "------\n")
        (insert "------\n"))))
  :bind ("C-c f s" . my-fill-paragraph-and-separate))

(use-package align
  :straight (:type built-in)
  :config
  (defun my-align-equals (start end)
    "Align columns by equal signs from START to END."
    (interactive "r")
    (align-regexp start end
                  "\\(\\s-*\\)=" 1 0 t))

  (defun my-align-whitespace (start end)
    "Align columns by whitespace from START to END."
    (interactive "r")
    (align-regexp start end
                  "\\(\\s-*\\)\\s-" 1 0 t))

  (defun my-align-& (start end)
    "Align columns by ampersand from START to END."
    (interactive "r")
    (align-regexp start end
                  "\\(\\s-*\\)&" 1 1 t)))

(use-package goto-addr
  :straight (:type built-in)
  :config
  (setq goto-address-url-mouse-face 'default)
  :hook ((prog-mode-hook text-mode-hook) . goto-address-mode))

(use-package emacs
  :straight (:type built-in)
  :init
  (setq read-extended-command-predicate #'command-completion-default-include-p)
  (setq text-mode-ispell-word-completion nil)
  (setq tab-always-indent 'complete))

(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-delay 0.3)
  (corfu-auto-prefix 1)
  (corfu-preview-current nil)
  (corfu-scroll-margin 5)
  (corfu-quit-no-match t)
  (corfu-quit-at-boundary nil)
  :hook ((prog-mode-hook eshell-mode-hook) . corfu-mode))

(use-package cape
  :config
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-abbrev)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  (add-to-list 'completion-at-point-functions #'cape-elisp-symbol)
  :bind (("C-c c p" . completion-at-point)
         ("C-c c h" . cape-history)
         ("C-c c f" . cape-file)
         ("C-c c s" . cape-elisp-symbol)
         ("C-c c a" . cape-abbrev)
         ("C-c c l" . cape-line)))

(use-package yasnippet
  :custom
  (yas-also-auto-indent-first-line t)
  (yas-also-indent-empty-lines t)
  (yas-snippet-revival nil)
  (yas-wrap-around-region nil)
  (yas-verbosity 0)
  :config
  (add-to-list 'yas-snippet-dirs "~/.emacs.d/snippets/")
  :bind (:map yas-minor-mode-map
              ("TAB"     . nil)
              ("<tab>"   . nil)
              ("C-'"     . yas-expand)
              ("C-c s-n" . yas-new-snippet)
              ("C-c s-i" . yas-insert-snippet)
              ("C-c s-v" . yas-visit-snippet-file)
              ("C-c s-r" . yas-reload-all))
  :hook (after-init-hook . yas-global-mode))

(use-package yasnippet-snippets
  :after yasnippet)

(use-package yasnippet-capf
  :after (cape yasnippet)
  :config
  (add-to-list 'completion-at-point-functions #'yasnippet-capf))

(use-package highlight-escape-sequences
  :config
  (set-face-foreground 'font-lock-regexp-grouping-backslash "#ff1493")
  (set-face-foreground 'font-lock-regexp-grouping-construct "#ff8c00")
  (hes-mode))

(use-package rainbow-delimiters
  :config
  (set-face-attribute 'rainbow-delimiters-unmatched-face nil
                      :foreground "red" :inherit 'error :strike-through t)
  :hook (prog-mode-hook . rainbow-delimiters-mode))

(use-package smartparens
  :diminish smartparens-mode
  :init
  (setq sp-base-key-bindings 'sp)
  (setq sp-show-pair-delay 0)
  (setq sp-show-pair-from-inside nil)
  (setq sp-cancel-autoskip-on-backward-movement nil)
  (setq sp-highlight-pair-overlay nil)
  (setq sp-highlight-wrap-overlay nil)
  (setq sp-highlight-wrap-tag-overlay nil)
  :hook
  ((after-init-hook . show-smartparens-global-mode)
   ((minibuffer-setup-hook prog-mode-hook org-mode-hook) . turn-on-smartparens-strict-mode)))

(use-package smartparens-config
  :straight (smartparens :includes (smartparens-config))
  :after smartparens
  :config
  (sp-pair "'" nil :actions :rem)
  (sp-pair "`" nil :actions :rem)

  (defun my-sp-pair-newline-and-indent (_id _action _context)
    "Newline and indent after inserting a pair."
    (save-excursion
      (newline)
      (indent-according-to-mode))
    (indent-according-to-mode))

  (sp-pair "(" nil :post-handlers
           '(:add (my-sp-pair-newline-and-indent "RET")))
  (sp-pair "{" nil :post-handlers
           '(:add (my-sp-pair-newline-and-indent "RET")))
  (sp-pair "[" nil :post-handlers
           '(:add (my-sp-pair-newline-and-indent "RET")))

  (sp-local-pair 'minibuffer-inactive-mode "'" nil :actions nil)

  (sp-with-modes 'org-mode
    (sp-local-pair "*" "*"
                   :unless '(sp-point-after-word-p sp--org-inside-LaTeX sp-point-at-bol-p)
                   :skip-match 'sp--org-skip-asterisk)
    (sp-local-pair "/" "/"
                   :unless '(sp-point-after-word-p sp--org-inside-LaTeX))
    (sp-local-pair "~" "~"
                   :unless '(sp-point-after-word-p sp--org-inside-LaTeX))
    (sp-local-pair "=" "="
                   :unless '(sp-point-after-word-p sp--org-inside-LaTeX))
    (sp-local-pair "\\[" "\\]")))

(use-package rainbow-mode
  :diminish rainbow-mode
  :config
  (setq rainbow-ansi-colors nil)
  (setq rainbow-x-colors t))

(use-package hl-line
  :straight (:type built-in)
  :config
  (global-hl-line-mode 1))

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package ispell
  :straight (:type built-in)
  :config
  (setq ispell-program-name "hunspell")
  (setq ispell-local-dictionary "en_US")
  (setq ispell-local-dictionary-alist
        '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil
           ("-d" "en_US,en_med_glut") nil utf-8)))

  (when (boundp 'ispell-hunspell-dictionary-alist)
    (setq ispell-hunspell-dictionary-alist ispell-local-dictionary-alist))

  (setq ispell-silently-savep t)
  (setq ispell-tex-skip-alists
        '((("\\\\author"             ispell-tex-arg-end)
           ("\\\\nocite"             ispell-tex-arg-end)
           ("\\\\includegraphics"    ispell-tex-arg-end)
           ("\\\\bibliography"       ispell-tex-arg-end)
           ("\\\\ref"                ispell-tex-arg-end)
           ("\\\\label"              ispell-tex-arg-end)
           ("\\\\parencite"          ispell-tex-arg-end)
           ("\\\\bibliographystyle"  ispell-tex-arg-end)
           ("\\\\cite\\(year\\)"      ispell-tex-arg-end)
           ("\\\\document\\(class\\|style\\)" .
            "\\\\begin[\t\n]*{[\t\n]*document[\t\n]*}"))
          (("\\(figure\\|table\\)\\*?" ispell-tex-arg-end 0)
           ("list"                     ispell-tex-arg-end 2))))

  (add-to-list 'ispell-skip-region-alist '(":PROPERTIES:"  . ":END:"))
  (add-to-list 'ispell-skip-region-alist '("#\\+[Bb][Ee][Gg][Ii][Nn]_[Ss][Rr][Cc]" . "#\\+[Ee][Nn][Dd]_[Ss][Rr][Cc]")))

(use-package flyspell
  :straight (:type built-in)
  :diminish (flyspell-mode . " φ")
  :config
  (setq flyspell-issue-message-flag nil)
  (setq flyspell-prog-text-faces (delq 'font-lock-string-face
                                       flyspell-prog-text-faces))
  (setq flyspell-prog-text-faces (delq 'font-lock-doc-face
                                       flyspell-prog-text-faces))
  :bind (:map flyspell-mode-map
              ([down-mouse-3] . flyspell-correct-word))
  :hook ((text-mode-hook . flyspell-mode)
         (prog-mode-hook . flyspell-prog-mode)))

(use-package flyspell-correct
  :after flyspell
  :bind (:map flyspell-mode-map
              ("C-c $" . flyspell-correct-wrapper)))

(use-package calfw
  :straight (calfw :includes (calfw-org calfw-ical calfw-cal))
  :init
  (setq cfw:fchar-junction         ?╋)
  (setq cfw:fchar-vertical-line    ?┃)
  (setq cfw:fchar-horizontal-line  ?━)
  (setq cfw:fchar-left-junction    ?┣)
  (setq cfw:fchar-right-junction   ?┫)
  (setq cfw:fchar-top-junction     ?┯)
  (setq cfw:fchar-top-left-corner  ?┏)
  (setq cfw:fchar-top-right-corner ?┓)
  :bind ("C-c C" . cfw:open-org-calendar))

(use-package calfw-org :after calfw)
(use-package calfw-ical :after calfw)
(use-package calfw-cal :after calfw)

(use-package time-stamp
  :straight (:type built-in)
  :init
  (setq time-stamp-active        t)
  (setq time-stamp-warn-inactive t)
  (setq time-stamp-line-limit   20)
  (setq time-stamp-format "Last changed on %Y%m%dT%H%M")
  :hook (before-save-hook . time-stamp))

(use-package emacs
  :straight (:type built-in)
  :config
  (defun my-insert-time ()
    "Insert current time."
    (interactive)
    (insert (current-time-string)))

  (defun my-insert-date (prefix)
    "Insert the current date.
With no PREFIX argument, use ISO date format.
With prefix argument 64, use ISO datetime format."
    (interactive "P")
    (let ((format (cond
                   ((not prefix)         "%Y%m%d")
                   ((equal prefix '(64)) "%Y%m%dT%H%M"))))
      (insert (format-time-string format))))

  :bind (("C-c M-d" . my-insert-date)
         ("C-c M-t" . my-insert-time)))

(use-package pdf-tools
  :load-path "~/.emacs.d/straight/repos/pdf-tools/lisp/"
  :straight (pdf-tools
             :includes (pdf-annot pdf-occur pdf-history pdf-links
                                  pdf-outline pdf-sync pdf-misc))
  :magic ("%PDF" . pdf-view-mode)
  :preface (defvar image-map t)
  :init
  (setq pdf-info-epdfinfo-program
        (expand-file-name "straight/repos/pdf-tools/server/epdfinfo" straight-base-dir))
  (setq-default pdf-view-display-size 'fit-width)
  (setq pdf-view-resize-factor 1.1)
  (setq pdf-view-midnight-colors '("gold" . "dark green"))
  (pdf-tools-install :no-query)

  :config
  (defun pdf-no-filter ()
    "View pdf without color filter."
    (interactive)
    (pdf-view-midnight-minor-mode -1))

  (defun pdf-midnite-blue ()
    "Set pdf-view-midnight-colors to white on dark blue."
    (interactive)
    (setq pdf-view-midnight-colors '("#ffffff" . "#0000bb"))
    (pdf-view-midnight-minor-mode))

  (defun pdf-midnite-yellow ()
    "Set pdf-view-midnight-colors to yellow on black."
    (interactive)
    (setq pdf-view-midnight-colors '("yellow" . "black"))
    (pdf-view-midnight-minor-mode))

  (setq pdf-sync-backward-display-action
        '(display-buffer-reuse-window (reusable-frames . t)))

  (defun my-display-buffer-in-pdf-frame (buffer alist)
    (if-let ((frame (car (seq-filter
                          (lambda (f) (frame-parameter f 'my-pdf-frame))
                          (frame-list)))))
        (display-buffer-use-some-frame
         buffer `((frame-predicate . ,(lambda (f)
                                        (frame-parameter f 'my-pdf-frame)))))
      (display-buffer-pop-up-frame
       buffer (cons
               '(pop-up-frame-parameters (my-pdf-frame . t))
               alist))))

  (add-to-list 'display-buffer-alist
               `((derived-mode . pdf-view-mode)
                 my-display-buffer-in-pdf-frame))

  (add-to-list 'revert-without-query ".+\\.pdf")

  :bind (:map pdf-view-mode-map
              ("N" . pdf-no-filter)
              ("Y" . pdf-midnite-yellow)
              ("B" . pdf-midnite-blue))
  :commands
  (TeX-pdf-tools-sync-view pdf-outline pdf-info-gettext pdf-isearch-minor-mode
                           pdf-info-getannots)
  :hook (pdf-view-mode-hook . my-pdf-view-mode-setup))

(defun my-pdf-view-mode-setup ()
  "Configure pdf-view-mode with midnight colors and minor modes."
  (pdf-view-midnight-minor-mode)
  (pdf-misc-size-indication-minor-mode)
  (pdf-links-minor-mode)
  (pdf-isearch-minor-mode)
  (cua-mode 0))

(use-package org-pdftools
  :straight (org-pdftools
             :includes (org-noter-pdftools))
  :defines (org-pdftools-mode)
  :hook (org-mode-hook . org-pdftools-setup-link))

(use-package org-noter-pdftools
  :commands (org-noter-pdftools-jump-to-note)
  :hook (pdf-annot-activate-handler-functions-hook . org-noter-pdftools-jump-to-note))

(use-package pdf-annot
  :straight (:type built-in)
  :init
  (setq pdf-annot-activate-created-annotations t)
  :config
  (defun my-save-buffer-no-args ()
    "Save the buffer while ignoring arguments."
    (save-buffer))

  (advice-add 'pdf-annot-edit-contents-commit :after #'my-save-buffer-no-args)

  ;; Export pdf outline as org-headings.
  ;; Extracts images of square annotations and inlines them.
  ;; Not all pdfs have outlines.
  (defun pdf-annot-markups-as-org-text (pdfpath &optional title level)
    "Acquire highlight annotations in PDFPATH as org text.
TITLE defaults to the filename, LEVEL to one below current heading."
    (interactive "fPath to PDF: ")
    (let* ((title (or title (replace-regexp-in-string
                             "-" " " (file-name-base pdfpath))))
           (level (or level (1+ (org-current-level))))
           (levelstring (make-string level ?*))
           (pdf-image-buffer (get-buffer-create "*temp pdf image*"))
           (outputstring (concat levelstring " Annotations from " title "\n\n")))
      (with-temp-buffer
        (insert-file-contents pdfpath)
        (pdf-view-mode)
        (pdf-annot-minor-mode t)
        (ignore-errors (pdf-outline-noselect (current-buffer)))
        (let ((annots (sort (pdf-annot-getannots nil '(square highlight) nil)
                            #'pdf-annot-compare-annotations))
              (last-outline-page -1))
          (dolist (annot annots)
            (let* ((page (assoc-default 'page annot))
                   (edges (assoc-default 'edges annot))
                   (height (nth 1 edges))
                   (type (assoc-default 'type annot))
                   (id (symbol-name (assoc-default 'id annot)))
                   (text (pdf-info-gettext page edges))
                   (page-str (number-to-string page))
                   (linktext (format "[[pdfview:%s::%s++%s][%s]]"
                                     pdfpath page-str
                                     (number-to-string height) title))
                   (annotation-as-org
                    (concat text "\n(" linktext ", " page-str ")\n\n")))

              ;; Square annotations: extract image and display inline
              (when (eq type 'square)
                (let ((imagefile (concat id ".png")))
                  (pdf-view-extract-region-image
                   (list edges) page '(1000 . 1000) pdf-image-buffer)
                  (with-current-buffer pdf-image-buffer
                    (write-file imagefile))
                  (setq annotation-as-org
                        (format "[[file:%s]]\n\n (%s, %s)\n\n"
                                imagefile linktext page-str))))

              ;; Insert outline heading if on a new page
              (when-let* ((outline-info
                           (ignore-errors
                             (with-current-buffer (pdf-outline-buffer-name)
                               (pdf-outline-move-to-page page)
                               (pdf-outline-link-at-pos))))
                          (outline-page (number-to-string
                                         (assoc-default 'page outline-info))))
                (unless (equal last-outline-page outline-page)
                  (setq outputstring
                        (concat outputstring
                                (make-string
                                 (+ level (assoc-default 'depth outline-info)) ?*)
                                " "
                                (assoc-default 'title outline-info)
                                ", " outline-page "\n\n"))
                  (setq last-outline-page outline-page)))

              (setq outputstring (concat outputstring annotation-as-org))))))
      (insert outputstring)))

  :bind (:map pdf-annot-edit-contents-minor-mode-map
              ("<s-return>" . pdf-annot-edit-contents-commit)
              ("<return>"   . newline)))

(use-package pdf-misc
  :straight (:type built-in)
  :preface
  (defvar pdf-misc-print-program "/usr/bin/lpr"))

(use-package interleave
  :after pdf-tools)

(use-package org-noter
  :init
  (setq org-noter-always-create-frame nil)
  (setq org-noter-kill-frame-at-session-end nil)
  (setq org-noter-hide-other nil)
  (setq org-noter-notes-search-path (list org-notes-dir))
  (setq org-noter-separate-notes-from-heading t)
  :commands
  (org-noter org-noter-insert-note org-noter-insert-precise-note
             org-noter-sync-prev-note org-noter-sync-next-note
             org-noter-create-skeleton org-noter-kill-session))

(use-package project
  :straight (:type built-in)
  :init
  (setq project-vc-extra-root-markers '(".prj"))
  :config
  (add-to-list 'project-switch-commands '(magit-project-status "Magit" ?m)))

(use-package tab-bar
  :straight (:type built-in)
  :init
  (setq tab-bar-close-button-show nil)
  (setq tab-bar-tab-hints t)
  :config
  (add-to-list 'tab-bar-format #'tab-bar-format-menu-bar))

(use-package tabspaces
  :after tab-bar
  :init
  (setq tabspaces-use-filtered-buffers-as-default t)
  (setq tabspaces-remove-to-default nil)
  (setq tabspaces-include-buffers '("*scratch*"))
  :config
  (tabspaces-mode))

(use-package with-editor
  :hook (vterm-mode-hook . with-editor-export-editor))

(use-package magit
  :straight (magit
             :includes (git-commit git-rebase))
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  :config
  (defun my-magit-fullscreen (orig-fun &rest args)
    "Save window config, run magit, then delete other windows."
    (window-configuration-to-register :magit-fullscreen)
    (apply orig-fun args)
    (delete-other-windows))

  (defun my-magit-restore-screen (orig-fun &rest args)
    "Quit magit and restore saved window configuration."
    (apply orig-fun args)
    (jump-to-register :magit-fullscreen))

  (advice-add #'magit-status :around #'my-magit-fullscreen)
  (advice-add #'magit-mode-bury-buffer :around #'my-magit-restore-screen)

  (dolist (hook '(magit-insert-tags-header
                  magit-insert-status-headers
                  magit-insert-unpushed-to-pushremote
                  magit-insert-unpulled-from-pushremote
                  magit-insert-unpulled-from-upstream
                  magit-insert-unpushed-to-upstream-or-recent))
    (remove-hook 'magit-status-sections-hook hook))

  :commands (magit-process-git)
  :bind ("C-x g" . magit-status))

(use-package git-link
  :after magit)

(use-package polymode)

(use-package poly-markdown
  :after (polymode markdown-mode))

(use-package markdown-mode
  :diminish (markdown-mode . " MD")
  :mode "\\.md\\'"
  :custom
  (markdown-fontify-code-blocks-natively t)
  (markdown-command "pandoc -f markdown -t html -s --highlight-style=pygments")
  (markdown-css-paths (list (expand-file-name "~/Dropbox/markdown/")))
  :bind (:map markdown-mode-map
              ("C-c M-d" . markdown-do)))

(use-package markdown-toc
  :after markdown-mode
  :custom
  (markdown-toc-header-toc-title "**Table of Contents**"))

(use-package lsp-mode
  :hook (python-mode-hook . lsp-deferred)
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-pylsp-plugins-black-enabled t))

(use-package lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode)

(use-package envrc
  :init
  (envrc-global-mode))

(use-package python
  :straight (:type built-in)
  :init
  (setq-default python-indent-guess-indent-offset nil)
  (setq-default python-indent-offset 4))

(use-package pyvenv
  :commands (pyvenv-activate pyvenv-workon pyvenv-mode))

(use-package dap-mode
  :straight (dap-mode :includes dap-python)
  :after lsp-mode
  :init
  (setq dap-auto-configure-features '(sessions locals tooltip))
  (setq dap-python-debugger 'debugpy)
  :config
  (dap-ui-mode 1))

(use-package elisp-mode
  :straight (:type built-in)
  :init
  (setq emacs-lisp-docstring-fill-column 100)
  :hook (emacs-lisp-mode-hook . my-emacs-lisp-mode-setup))

(defun my-emacs-lisp-mode-setup ()
  "Extra setup for emacs-lisp buffers."
  (outline-minor-mode 1)
  (rainbow-mode 1))

(use-package elisp-format
  :commands elisp-format-buffer)

(use-package aggressive-indent
  :hook (emacs-lisp-mode-hook . aggressive-indent-mode))

(use-package highlight-defined
  :hook (emacs-lisp-mode-hook . highlight-defined-mode))

(use-package tex
  :defer t
  :straight (auctex :includes (latex tex-site tex preview))
  :preface
  (defvar reftex-cite-format nil)
  (defvar TeX-view-program-selection nil)
  (defvar TeX-view-program-list-builtin nil)
  :custom
  (TeX-fold-env-spec-list
   '(("[fig]"  ("figure"))))
  (TeX-fold-macro-spec-list
   '(("[f]" ("footnote"))
     ("[c]" ("cite"))
     ("[p]" ("parencite"))
     ("[l]" ("label"))
     ("[r]" ("reference"))
     ("[i]" ("index"))
     ("[g]" ("glossary"))
     ("..." ("dots"))
     ("(c)" ("copyright"))
     (1     ("part" "chapter" "section" "subsection" "paragraph" "subparagraph"
             "part*" "chapter*" "section*" "subsection*" "paragraph*" "subparagraph*"))))
  :init
  (setq TeX-auto-global (expand-file-name ".auctex-auto" user-emacs-directory))
  (setq TeX-auto-local  (expand-file-name ".auctex-auto" user-emacs-directory))
  (setq TeX-default-mode      'LaTeX-mode)
  (setq TeX-file-extensions   '("tex" "sty" "texi" "texinfo"))
  (setq tex-start-commands    nil)
  (setq TeX-show-compilation  t)
  :mode ("\\.tex\\'" . LaTeX-mode)
  :config
  (load "auctex.el" nil t t)

  (unless (assoc "PDF Tools" TeX-view-program-list-builtin)
    (add-to-list 'TeX-view-program-list-builtin
                 '("PDF Tools" TeX-pdf-tools-sync-view)))

  (setq TeX-command-list
        '(("latexmk" "latexmk -pdf %f" TeX-run-TeX nil t
           :help "Run latexmk on file")
          ("View" "%V" TeX-run-discard-or-function nil t
           :help "Run Viewer")
          ("Spell" "(TeX-ispell-document \"\")" TeX-run-function nil t
           :help "Spell-check doc")
          ("Clean" "TeX-clean" TeX-run-function nil t
           :help "Delete intermediate files")
          ("Clean All" "(TeX-clean 1)" TeX-run-function nil t
           :help "Delete intermediate and output files")
          ("Index" "makeindex %s" TeX-run-command nil t
           :help "Create index file")
          ("Print" "%p" TeX-run-command t t
           :help "Print file")
          ("Queue" "%q" TeX-run-background nil t
           :help "View printer queue"
           :visible TeX-queue-command)
          ("PDF viewer" "PDF Tools %s.pdf" TeX-run-command nil t
           :help "Run pdf-view")))

  (setq TeX-command-default "latexmk")
  (setq TeX-save-query nil)
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq TeX-clean-confirm nil)
  (setq preview-image-type 'png)
  (setq TeX-outline-extra '(("\\\\newpage" 4) ("\\\\bibliography" 4) ("%chapter" 1)))
  (setq TeX-brace-indent-level 2)
  (setq-default TeX-engine 'xelatex)

  (setq LaTeX-default-offset 2)
  (setq LaTeX-indent-level 2)
  (setq LaTeX-item-indent 2)
  (setq LaTeX-insert-into-comments nil)
  (setq LaTeX-section-hook
        '(LaTeX-section-title LaTeX-section-heading LaTeX-section-section))
  (setq LaTeX-figure-label "Fig. ")
  (setq LaTeX-table-label "Table: ")
  (setq LaTeX-csquotes-open-quote "\\enquote{" LaTeX-csquotes-close-quote "}")

  ;; Automagic detection of master file
  (defun guess-TeX-master (filename)
    "Guess the master file for FILENAME from currently open .tex files."
    (let ((candidate nil)
          (filename (file-name-nondirectory filename)))
      (dolist (buffer (buffer-list))
        (with-current-buffer buffer
          (when-let* ((file buffer-file-name)
                      (_ (string-match-p "\\.tex\\'" file)))
            (save-excursion
              (goto-char (point-min))
              (when (re-search-forward (concat "\\\\input{" filename "}") nil t)
                (setq candidate file))
              (when (re-search-forward
                     (concat "\\\\include{" (file-name-sans-extension filename) "}") nil t)
                (setq candidate file))))))
      (when candidate
        (message "TeX master document: %s" (file-name-nondirectory candidate)))
      candidate))

  (setq TeX-master '(guess-TeX-master (buffer-file-name)))

  (TeX-add-style-hook "csquotes"
                      (lambda ()
                        (TeX-add-symbols
                         '("textcquote"  ["pre-note (post-note if alone)"]["post-note"]
                           TeX-arg-cite  ["Punctuation"] t ignore ignore)
                         '("blockcquote" ["pre-note (post-note if alone)"]["post-note"]
                           TeX-arg-cite  ["Punctuation"] t ignore ignore))))

  (defun my-cite ()
    "Insert a citation with full metadata using reftex."
    (interactive)
    (let ((reftex-cite-format "%a, %t, %j %v, %p, %e: %b, %u, %s, %y %<"))
      (reftex-citation)))

  (defun start-latex-article ()
    "Insert boilerplate for a new LaTeX article."
    (interactive)
    (goto-char (point-min))
    (insert "\\documentclass[12pt,a4paper,oneside,english]{article}
\\title{}
\\author{Your Name}
\\date{}

\\usepackage[greek,english]{babel}
\\usepackage{indentfirst}

\\begin{document}
\\maketitle
")
    (goto-char (point-max))
    (insert "\\end{document}")
    (goto-char (point-min))
    (forward-line 2)
    (backward-char 2)
    (LaTeX-mode))

  (defun my-tex-text-to-table (sep)
    "Transform the current paragraph into a LaTeX table using SEP as column separator."
    (interactive "sColumn separator (e.g. TAB or |): ")
    (let* ((bds (bounds-of-thing-at-point 'paragraph))
           (p1 (1+ (car bds)))
           (p2 (cdr bds))
           (text (buffer-substring-no-properties p1 p2)))
      (delete-region p1 p2)
      (save-excursion
        (let* ((text (replace-regexp-in-string sep " & " text))
               (text (replace-regexp-in-string "\n" " \\\\\\\\\n" text)))
          (insert "\\begin{tabular}{lrrrrrrrrrrrrrr}\n"
                  text "\\end{tabular}\n")))
      (goto-char (+ p1 16))))

  (defvar tr-utf8-to-latex-string-translation-alist
    '(("á" . "\\\'a") ("Á" . "\\\'A")
      ("à" . "\\\`a") ("À" . "\\\`A")
      ("ä" . "\\\"a") ("Ä" . "\\\"A")
      ("é" . "\\\'e") ("É" . "\\\'E")
      ("ë" . "\\\"e") ("Ë" . "\\\"E")
      ("í" . "\\\'{\\i}") ("Í" . "\\\'{\\i}")
      ("ó" . "\\\'o") ("Ó" . "\\\'O")
      ("ú" . "\\\'u") ("Ú" . "\\\'U")
      ("ü" . "\\\"u") ("Ü" . "\\\"U")
      ("ñ" . "\\\~n") ("Ñ" . "\\\~N")
      ("¿" . "?\'")
      ("¡" . "!\'")
      ("ß" . "{\\\ss}")
      ("ç" . "\\c{c}")  ("Ç" . "\\c{C}")
      ("ğ" . "\\u{g}")  ("Ğ" . "\\u{G}")
      ("İ" . "\\.{I}")
      ("ö" . "\\\"{o}") ("Ö" . "\\\"{O}")
      ("ş" . "\\c{s}")  ("Ş" . "\\c{S}")))

  (easy-menu-add-item nil '("LaTeX")
                      ["Text -> Table" my-tex-text-to-table
                       :help "Paragraph to latex table"]
                      "Comment or Uncomment Region")

  :bind (:map LaTeX-mode-map
              ("<f5>"    . (lambda () (interactive) (save-buffer) (TeX-command-master)))
              ("<s-f5>"  . (lambda () (interactive) (TeX-command-menu "LaTeX")))
              ("s-b"     . (lambda () (interactive) (TeX-command-menu "BibTeX")))
              ("C-c k"   . TeX-clean)
              ("s-a"     . LaTeX-find-matching-begin)
              ("s-e"     . LaTeX-find-matching-end)
              ("C-c z"   . my-cite))
  :hook ((LaTeX-mode-hook . (lambda ()
                              (set-input-method "TeX")
                              (TeX-PDF-mode 1)
                              (turn-on-reftex)
                              (flyspell-mode)
                              (rainbow-mode)
                              (outline-minor-mode)
                              (abbrev-mode -1)))
         (TeX-after-compilation-finished-functions-hook . TeX-revert-document-buffer))

  :commands
  (TeX-add-style-hook TeX-run-style-hooks TeX-complete-symbol TeX-add-symbols
                      TeX-revert-document-buffer TeX-pdf-tools-sync-view
                      TeX-master-file TeX-command-menu TeX-source-correlate-mode
                      TeX-PDF-mode))

(use-package latex
  :straight (:type built-in)
  :after tex
  :commands
  (LaTeX-add-environments LaTeX-find-matching-begin
                          LaTeX-mark-environment LaTeX-insert-item
                          LaTeX-fill-region-as-paragraph
                          LaTeX-narrow-to-environment
                          TeX-command-region TeX-revert-document-buffer))

(use-package latex-pretty-symbols
  :after latex)

(use-package preview
  :straight (:type built-in)
  :after latex)

(use-package cdlatex
  :after tex
  :hook ((LaTeX-mode-hook . turn-on-cdlatex)
         (org-mode-hook   . turn-on-org-cdlatex)))

(use-package font-latex
  :after tex
  :straight (:type built-in)
  :preface
  (defvar bold-text-face nil)
  :config
  (set-face-attribute 'font-latex-subscript-face   nil :height 0.6)
  (set-face-attribute 'font-latex-superscript-face nil :height 0.6)

  (let ((height init-default-font-height))
    (dolist (face '(font-latex-sectioning-0-face
                    font-latex-sectioning-1-face
                    font-latex-sectioning-2-face
                    font-latex-sectioning-3-face
                    font-latex-sectioning-4-face))
      (apply #'set-face-attribute face nil
             (plist-put (copy-sequence (or bold-text-face '())) :height height))))

  (setq font-latex-match-reference-keywords
        '(("cite"             "[{")
          ("cites"            "[{}]")
          ("autocite"         "[{")
          ("footcite"         "[{")
          ("footcites"        "[{")
          ("parencite"        "[{")
          ("textcite"         "[{")
          ("fullcite"         "[{")
          ("citetitle"        "[{")
          ("citetitles"       "[{")
          ("headlessfullcite" "[{"))))

(use-package reftex
  :straight (:type built-in)
  :init
  (setq reftex-ref-macro-prompt nil)
  (setq reftex-enable-partial-scans t)
  (setq reftex-save-parse-info t)
  (setq reftex-use-multiple-selection-buffers t)
  (setq reftex-sort-bibtex-matches 'year)
  (setq reftex-revisit-to-follow t)
  (setq reftex-file-extensions '(("tex" ".tex") ("bib" ".bib") ("org" ".org")))
  (setq reftex-default-bibliography org-cite-global-bibliography)
  :config
  (setq reftex-plug-into-AUCTeX t)
  (setq reftex-insert-label-flags '(t t))

  (setq reftex-bibpath-environment-variables
        (list (expand-file-name "~/Dropbox/org/bibliographies/")))
  (setq reftex-external-file-finders
        '(("tex" . "kpsewhich -format=.tex %f")
          ("bib" . "kpsewhich -format=.bib %f")
          ("org" . "kpsewhich -format=.org %f")))

  (setq reftex-bibliography-commands '("bibliography" "nobibliography" "addbibresource"))

  ;; Add custom section levels for beamer frames and article class
  (add-to-list 'reftex-section-levels '("article" . -1))
  (add-to-list 'reftex-section-levels '("begin{frame}" . -3))

  ;; RefTeX formats for biblatex
  (setq reftex-cite-format
        '((?\C-m . "\\cite[]{%l}")
          (?t . "\\textcite{%l}")
          (?a . "\\autocite[]{%l}")
          (?p . "\\parencite{%l}")
          (?f . "\\footcite[][]{%l}")
          (?F . "\\fullcite[]{%l}")
          (?x . "[]{%l}")
          (?X . "{%l}")))

  (setq reftex-cite-prompt-optional-args nil)
  (setq reftex-cite-cleanup-optional-args t)

  :commands (reftex-mode reftex-reset-mode reftex-view-crossref turn-on-reftex)
  :hook (latex-mode-hook . turn-on-reftex))

(use-package anki-editor
  :init
  (defvar my-anki-editor-cloze-number 1
    "Current cloze deletion number for anki-editor.")
  (defvar org-my-anki-file (expand-file-name "~/Dropbox/org/org-roam/anki.org")
    "Path to the Anki org file.")

  (with-eval-after-load 'org-capture
    (add-to-list 'org-capture-templates
                 `("b" "AnkB" entry (file+headline ,org-my-anki-file "Dispatch Shelf")
                   ,(concat "* %<%Y-%m-%d %H:%M:%S> %^g\n"
                            ":PROPERTIES:\n"
                            ":ANKI_NOTE_TYPE: Basic\n"
                            ":ANKI_DECK: Mega\n"
                            ":END:\n"
                            "** Front\n"
                            "%?\n"
                            "** Back\n"
                            "%x\n")))
    (add-to-list 'org-capture-templates
                 `("c" "AnkC" entry (file+headline ,org-my-anki-file "Dispatch Shelf")
                   ,(concat "* %<%Y-%m-%d %H:%M:%S> %^g\n"
                            ":PROPERTIES:\n"
                            ":ANKI_NOTE_TYPE: Cloze\n"
                            ":ANKI_DECK: Mega\n"
                            ":END:\n"
                            "** Text\n"
                            "%x\n"
                            "** Extra\n"))))
  :config
  (setq anki-editor-create-decks t)
  (setq anki-editor-org-tags-as-anki-tags t)

  (defun anki-editor-cloze-region-auto-incr ()
    "Cloze region without hint and increase card number."
    (interactive)
    (anki-editor-cloze-region my-anki-editor-cloze-number "")
    (setq my-anki-editor-cloze-number (1+ my-anki-editor-cloze-number))
    (forward-sexp))

  (defun anki-editor-cloze-region-dont-incr ()
    "Cloze region without hint using the previous card number."
    (interactive)
    (anki-editor-cloze-region (1- my-anki-editor-cloze-number) "")
    (forward-sexp))

  (defun anki-editor-reset-cloze-number (&optional arg)
    "Reset cloze number to ARG or 1."
    (interactive)
    (setq my-anki-editor-cloze-number (or arg 1)))

  (defun anki-editor-push-tree ()
    "Push all notes under a tree."
    (interactive)
    (anki-editor-push-notes '(4))
    (anki-editor-reset-cloze-number))

  :hook (org-capture-after-finalize-hook . anki-editor-reset-cloze-number))

(use-package calibredb
  :init
  (setq calibredb-size-show t)
  (setq calibredb-sql-separator "::::::::")
  :config
  (setq calibredb-root-dir (expand-file-name "Calibre/" org-directory))
  (setq calibredb-db-dir (expand-file-name "metadata.db" calibredb-root-dir))
  (setq calibredb-library-alist
        (list (list calibredb-root-dir)
              (list (expand-file-name "pdf-books/books/" org-directory))))
  (setq calibredb-ref-default-bibliography
        (expand-file-name "catalog.bib" calibredb-root-dir))
  (setq calibredb-annotation-field "comments")

  (add-to-list 'bibtex-completion-bibliography calibredb-ref-default-bibliography))

(use-package bibtex
  :straight (:type built-in)
  :custom
  (bibtex-dialect 'BibTeX)
  (bibtex-user-optional-fields
   '(("keywords" "Keywords to describe the entry" "")
     ("file"     "Link to a document file"        "")))
  (bibtex-entry-delimiters 'braces)
  (bibtex-field-delimiters 'braces)
  (bibtex-maintain-sorted-entries nil)
  (bibtex-help-message nil)
  (bibtex-field-indentation 2)
  (bibtex-align-at-equal-sign t)
  (bibtex-text-indentation 2)
  (bibtex-entry-format
   '(last-comma realign delimiters unify-case sort-fields))
  (bibtex-file-path (list bibliography-directory))
  :bind (:map bibtex-mode-map
              ("M-b M-f" . bibtex-reformat)))

(add-hook 'bibtex-mode-hook (lambda ()
                              (display-line-numbers-mode 1)
                              (font-lock-fontify-buffer)))

(use-package bibtex-completion
  :init
  (setq bibtex-completion-bibliography org-cite-global-bibliography)
  (setq bibtex-completion-library-path org-lib-dir)
  (setq bibtex-completion-notes-path "~/Dropbox/org/org-roam/")
  (setq bibtex-completion-notes-extension ".org")
  (setq bibtex-completion-pdf-field "File")
  (setq bibtex-completion-pdf-symbol "#")
  (setq bibtex-completion-notes-symbol "✎")
  (setq bibtex-completion-browser-function #'browse-url-chrome)
  (setq bibtex-completion-additional-search-fields '(keywords))
  (setq bibtex-completion-find-additional-pdfs t)
  (setq bibtex-completion-notes-template-multiple-files
        (concat "* ${author}, ${title}, ${journal}, (${year}) :${=type=}:\n\n"
                "See [[cite:&${=key=}]]\n"))
  :commands bibtex-completion-find-pdf)

(use-package zotxt
  :hook (org-mode-hook . org-zotxt-mode))

(defun unwrap-lines-and-remove-eol-hyphens ()
  "Remove end-of-line hyphens and unwrap lines while preserving paragraph formatting."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "-\n" nil t)
      (replace-match "" nil nil))
    (goto-char (point-min))
    (while (re-search-forward "\\([^ \t\n]\\)\n\\([^ \t\n]\\)" nil t)
      (replace-match "\\1 \\2" nil nil))))

(use-package ediff
  :straight (:type built-in)
  :init
  (setq ediff-forward-word-function #'forward-char)
  (setq ediff-auto-refine "on")
  (setq ediff-keep-variants nil)
  (setq ediff-highlight-all-diffs nil)
  (setq ediff-diff-options "-w")
  (setq ediff-window-setup-function #'ediff-setup-windows-plain)
  (setq ediff-split-window-function #'split-window-horizontally)
  :custom-face
  (ediff-fine-diff-A ((t (:background "firebrick"))))
  (ediff-fine-diff-B ((t (:background "dark green"))))
  :config
  (defun my-ediff-expand-org-buffers ()
    "Expand all org headings in ediff buffers."
    (when (eq major-mode 'org-mode)
      (outline-show-all)))

  :hook ((ediff-prepare-buffer-hook . my-ediff-expand-org-buffers)
         (ediff-before-setup-hook . (lambda ()
                                      (window-configuration-to-register 'ediff)))
         (ediff-quit-hook . (lambda ()
                              (jump-to-register 'ediff)))))

(use-package vterm
  :commands (vterm vterm-other-window)
  :init
  (setq vterm-kill-buffer-on-exit t)
  (setq vterm-max-scrollback 10000)
  (setq claude-code-terminal-backend 'vterm)
  :config
  (setq shell-file-name "/bin/bash")
  (setenv "SHELL" shell-file-name)
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")

  (add-to-list 'display-buffer-alist
               '("vterm-subterminal.*"
                 (display-buffer-reuse-window
                  display-buffer-in-side-window)
                 (side . bottom)
                 (reusable-frames . visible)
                 (window-height . 0.33)))

  (defun my-toggle-vterm-subterminal ()
    "Toggle a vterm side window at the bottom."
    (interactive)
    (let ((vterm-window
           (seq-find
            (lambda (window)
              (string-match-p
               "vterm-subterminal"
               (buffer-name (window-buffer window))))
            (window-list))))
      (if vterm-window
          (if (eq (get-buffer-window (current-buffer)) vterm-window)
              (kill-buffer (current-buffer))
            (select-window vterm-window))
        (vterm-other-window "vterm-subterminal"))))

  (defun my-vterm-get-pwd ()
    "Get the current working directory of the vterm process."
    (if vterm--process
        (file-truename (format "/proc/%d/cwd" (process-id vterm--process)))
      default-directory))

  (defun my-vterm-dired-other-window ()
    "Open dired in vterm pwd in other window."
    (interactive)
    (dired-other-window (my-vterm-get-pwd)))

  (defun my-vterm-dired-replace ()
    "Replace vterm with dired in the current directory."
    (interactive)
    (let ((pwd (my-vterm-get-pwd)))
      (kill-process vterm--process)
      (dired pwd))))

(use-package ansi-color
  :straight (:type built-in)
  :hook ((compilation-filter-hook . ansi-color-compilation-filter)))

(use-package eshell
  :straight (:type built-in)
  :init
  (setq eshell-scroll-to-bottom-on-input t)
  (setq eshell-directory-name (expand-file-name "eshell/" user-emacs-directory))
  (setq eshell-review-quick-commands nil)
  (setq eshell-history-size 50)
  (setq eshell-buffer-shorthand t)
  (setq eshell-plain-echo-behavior t)
  (setq eshell-highlight-prompt nil)
  :config
  (defun my-pwd-replace-home (pwd)
    "Replace home in PWD with tilde (~) character."
    (let* ((home (expand-file-name (getenv "HOME")))
           (home-len (length home)))
      (if (and (>= (length pwd) home-len)
               (equal home (substring pwd 0 home-len)))
          (concat "~" (substring pwd home-len))
        pwd)))

  (defun my-pwd-shorten-dirs (pwd)
    "Shorten all directory names in PWD except the last two."
    (let ((p-lst (split-string pwd "/")))
      (if (> (length p-lst) 2)
          (concat
           (mapconcat (lambda (elm)
                        (if (zerop (length elm)) "" (substring elm 0 1)))
                      (butlast p-lst 2) "/")
           "/"
           (mapconcat #'identity (last p-lst 2) "/"))
        pwd)))

  (defun my-split-directory-prompt (directory)
    "Split DIRECTORY into parent and base name components."
    (if (string-match-p ".*/.*" directory)
        (list (file-name-directory directory) (file-name-base directory))
      (list "" directory)))

  (setq-default eshell-prompt-function
                (lambda ()
                  (let* ((directory (my-split-directory-prompt
                                     (my-pwd-shorten-dirs
                                      (my-pwd-replace-home (eshell/pwd)))))
                         (parent (car directory))
                         (name (cadr directory)))
                    (concat parent name " $ "))))

  :commands (eshell eshell-command)
  :hook (eshell-mode-hook . my-eshell-mode-setup))

(defun my-eshell-mode-setup ()
  "Configure eshell buffers."
  (setq-local global-hl-line-mode nil)
  (setq-local whitespace-line-column 100)
  (setq-local blink-matching-paren nil)
  (flycheck-mode -1)
  (show-smartparens-mode -1))

(use-package web-mode
  :mode "\\.html?\\'"
  :init
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))

(use-package browse-url
  :straight (:type built-in)
  :init
  (setq browse-url-browser-function
        (cond ((or (executable-find "google-chrome-stable")
                   (executable-find "google-chrome")) #'browse-url-chrome)
              ((executable-find "firefox") #'browse-url-firefox)
              (t #'browse-url-default-browser))))

(use-package ffap
  :straight (:type built-in)
  :init
  (setq ffap-machine-p-known 'reject)
  :hook (after-init-hook . ffap-bindings))

(use-package ellama
  :init
  (setopt ellama-keymap-prefix "C-c e"))

(use-package gptel
  :straight (gptel
             :includes (gptel-integrations))
  :init
  (setq-default gptel-model "gpt-5.4")
  (setq-default gptel-default-mode 'org-mode)
  (setq-default gptel-playback t)
  (setq gptel-api-key (auth-source-pick-first-password :host "openai.com"))
  :config
  (require 'gptel-integrations)

  (setq gptel-use-curl t)
  (setq gptel-use-tools t)
  (setq gptel-confirm-tool-calls 'always)
  (setq gptel-include-tool-results 'auto)
  (setq gptel-prompt-prefix-alist '((org-mode . "* ")))
  (setq gptel-log-level 'info)
  (setq gptel-backend (gptel-make-gh-copilot "Copilot" :stream t))

  (gptel-make-tool
   :name "read_buffer"
   :function (lambda (buffer)
               (unless (buffer-live-p (get-buffer buffer))
                 (error "Buffer %s is not live" buffer))
               (with-current-buffer buffer
                 (buffer-substring-no-properties (point-min) (point-max))))
   :description "Return the contents of an Emacs buffer"
   :args (list '(:name "buffer"
                 :type string
                 :description "Name of buffer whose contents are to be retrieved"))
   :category "emacs")

  (gptel-make-tool
   :name "create_file"
   :function (lambda (path filename content)
               (let ((full-path (expand-file-name filename path)))
                 (with-temp-buffer
                   (insert content)
                   (write-file full-path))
                 (format "Created file %s in %s" filename path)))
   :description "Create a new file with the specified content"
   :args (list '(:name "path"
                 :type string
                 :description "The directory where to create the file")
               '(:name "filename"
                 :type string
                 :description "The name of the file to create")
               '(:name "content"
                 :type string
                 :description "The content to write to the file"))
   :category "filesystem")

  (gptel-make-preset 'proofreader
                     :description "Preset for proofreading tasks"
                     :backend "ChatGPT"
                     :model "gpt-5.4"
                     :tools '("read_buffer" "spell_check" "grammar_check")
                     :temperature 0.7
                     :use-context 'system)

  (gptel-make-preset 'gpt4coding
                     :description "A preset optimized for coding tasks"
                     :backend "ChatGPT"
                     :model "gpt-5.4"
                     :system "You are an expert coding assistant. You provide high-quality code solutions, refactorings, and explanations."
                     :tools '("read_buffer" "modify_buffer"))

  (gptel-make-preset 'websearch
                     :description "Basic web search capability."
                     :backend "ChatGPT"
                     :model "gpt-5.4"
                     :tools '("search_web" "read_url" "get_youtube_meta"))

  (defun my-ai-from-anywhere ()
    "Open a gptel chat in a new frame on the right third of the screen."
    (interactive)
    (let* ((ws (frame-parameter nil 'window-system))
           (screen-width (display-pixel-width))
           (screen-height (display-pixel-height))
           (frame-width (/ screen-width 3))
           (chat-frame (make-frame `((window-system . ,ws)
                                     (top . 0)
                                     (left . ,(- screen-width frame-width))
                                     (width . (text-pixels . ,frame-width))
                                     (height . (text-pixels . ,screen-height))
                                     (minibuffer . t)))))
      (select-frame chat-frame)
      (gptel "My:AI Chat" gptel-api-key nil)
      (switch-to-buffer "My:AI Chat")
      (delete-other-windows)))

  :bind (("C-c l l" . gptel)
         ("C-c l r" . gptel-rewrite)
         ("C-c l m" . gptel-menu))
  :hook (gptel-post-response-hook . (lambda () (goto-char (point-max)))))

(use-package gptel-fn-complete
  :preface
  (defvar my-gptel-map
    (let ((map (make-sparse-keymap)))
      (define-key map (kbd "c") #'gptel-fn-complete)
      map)
    "Keymap for gptel code completion.")
  :bind ("C-c ." . my-gptel-map))

(use-package gptel-autocomplete
  :straight (gptel-autocomplete :type git
                                :host github
                                :repo "JDNdeveloper/gptel-autocomplete")
  :init
  (setq gptel-autocomplete-temperature 0.1)
  (setq gptel-autocomplete-use-context t)
  (setq gptel-autocomplete-debug t))

(use-package editorconfig
  :commands editorconfig-mode)

(use-package copilot
  :straight (copilot :host github
                     :repo "copilot-emacs/copilot.el"
                     :files ("dist" "*.el"))
  :diminish
  :init
  (setq copilot-max-char 300000)
  (setq copilot-indent-offset-warning-disable t)
  :config
  (delq 'company-preview-if-just-one-frontend company-frontends)

  (defvar rk/copilot-manual-mode nil
    "When non-nil, only show completions when manually triggered.")

  (defvar rk/copilot-no-complete-modes
    '(shell-mode eshell-mode comint-mode debugger-mode
      dired-mode compilation-mode minibuffer-inactive-mode)
    "Modes in which copilot should not show completions.")

  (defun rk/copilot-disable-predicate ()
    "Return non-nil when copilot should not show completions."
    (or rk/copilot-manual-mode
        (member major-mode rk/copilot-no-complete-modes)
        (bound-and-true-p company--active-p)))

  (add-to-list 'copilot-disable-predicates #'rk/copilot-disable-predicate)

  (defun rk/copilot-change-activation ()
    "Cycle copilot activation: automatic -> manual -> off."
    (interactive)
    (cond
     ((and copilot-mode rk/copilot-manual-mode)
      (message "Deactivating copilot")
      (global-copilot-mode -1)
      (setq rk/copilot-manual-mode nil))
     (copilot-mode
      (message "Activating copilot manual mode")
      (setq rk/copilot-manual-mode t))
     (t
      (message "Activating copilot")
      (global-copilot-mode))))

  (defun rk/copilot-complete-or-accept ()
    "Trigger a completion or accept one if available."
    (interactive)
    (if (copilot--overlay-visible)
        (progn
          (copilot-accept-completion)
          (open-line 1)
          (forward-line 1))
      (copilot-complete)))

  (defun rk/copilot-quit ()
    "Clear copilot overlay and suppress it briefly."
    (interactive)
    (when (bound-and-true-p copilot--overlay)
      (let ((saved-predicates copilot-disable-predicates))
        (setq copilot-disable-predicates (list (lambda () t)))
        (copilot-clear-overlay)
        (run-with-idle-timer 1.0 nil
                             (lambda ()
                               (setq copilot-disable-predicates saved-predicates))))))

  (advice-add #'keyboard-quit :before #'rk/copilot-quit)
  (add-to-list 'warning-suppress-types '(copilot copilot-exceeds-max-char))

  :bind (:map copilot-mode-map
              ("<tab>"        . copilot-accept-completion)
              ("M-C-<escape>" . rk/copilot-change-activation)
              ("M-C-<return>" . rk/copilot-complete-or-accept)
              ("M-C-n"       . copilot-next-completion)
              ("M-C-p"       . copilot-previous-completion)
              ("M-C-w"       . copilot-accept-completion-by-word)
              ("M-C-l"       . copilot-accept-completion-by-line)))

(use-package js2-mode
  :mode "\\.js\\'")

(use-package gud
  :straight (:type built-in)
  :commands gud-gdb)

(use-package company
  :straight (company
             :includes (company-yasnippet company-capf))
  :init
  (setq company-global-modes '(not magit-status-mode help-mode))
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 2)
  (setq company-selection-wrap-around t)
  :config
  (add-to-list 'company-backends '(:with company-yasnippet company-capf))
  (company-tng-configure-default)
  :hook (after-init-hook . global-company-mode))

(use-package gptel-mcp
  :straight nil
  :load-path "lisp/"
  :after (gptel mcp)
  :bind (:map gptel-mode-map
              ("C-c m" . gptel-mcp-dispatch)))

(use-package mcp
  :straight (mcp :includes (mcp-hub))
  :after gptel)

(use-package mcp-hub
  :straight (:type built-in)
  :after mcp
  :config
  (setq mcp-hub-servers
        `(("filesystem" . (:command "npx"
                           :args ("-y"
                                  "@modelcontextprotocol/server-filesystem"
                                  ,(expand-file-name "~/projects/"))))
          ("everything" . (:command "npx"
                           :args ("-y"
                                  "@modelcontextprotocol/server-everything")))
          ("fetch" . (:command "uvx"
                      :args ("mcp-server-fetch")))
          ("qdrant" . (:url "http://localhost:6333/stdio"))
          ("github" . (:command "github-mcp-server"
                       :args ("stdio")))
          ("sequential-thinking" . (:command "npx"
                                    :args ("-y"
                                           "@modelcontextprotocol/server-sequential-thinking")))
          ("context7" . (:command "npx"
                         :args ("-y" "@upstash/context7-mcp@latest")))
          ("graphlit" . (:command "npx"
                         :args ("-y" "graphlit-mcp-server")
                         :env (:GRAPHLIT_ORGANIZATION_ID
                               ,(auth-source-pick-first-password
                                 :host "graphlit.io" :user "organization-id")
                               :GRAPHLIT_ENVIRONMENT_ID
                               ,(auth-source-pick-first-password
                                 :host "graphlit.io" :user "environment-id")
                               :GRAPHLIT_JWT_SECRET
                               ,(auth-source-pick-first-password
                                 :host "graphlit.io" :user "jwt-secret")))))))

(use-package claude-code-ide
  :straight (:type git
                   :host github
                   :repo "manzaltu/claude-code-ide.el")
  :bind ("C-c C-'" . claude-code-ide-menu)
  :config
  (claude-code-ide-emacs-tools-setup))

(use-package elisa
  :commands (elisa-chat elisa-download-web elisa-download-wiki)
  :config
  (require 'llm-openai)

  (setopt elisa-limit 5)
  (setopt elisa-reranker-enabled t)
  (setopt elisa-prompt-rewriting-enabled t)
  (setopt elisa-batch-embeddings-enabled t)
  (setopt elisa-web-search-function #'elisa-search-searxng)
  (setopt elisa-chat-provider
          (make-llm-openai
           :chat-model "GPT-5.4"
           :embedding-model "text-embedding-3-small"
           :default-chat-temperature 0.1
           :default-chat-non-standard-params '(("num_ctx" . 32768))))
  (setopt elisa-embeddings-provider
          (make-llm-openai
           :embedding-model "text-embedding-3-small")))

(use-package tldr
  :init
  (setq tldr-directory-path (expand-file-name "tldr/" user-cache-directory))
  (setq tldr-saved-zip-path (expand-file-name "tldr-source.zip" user-cache-directory))
  :bind ("C-c s-t" . tldr-find-page))

(use-package server
  :straight (:type built-in)
  :config
  (unless (server-running-p)
    (server-start))
  (global-unset-key (kbd "C-x C-c"))
  (global-unset-key (kbd "C-x C-z")))

(use-package dbus
  :straight (:type built-in)
  :when (getenv "DESKTOP_AUTOSTART_ID")
  :config
  (defvar my-gnome-client-path nil
    "D-Bus client path for GNOME SessionManager registration.")

  (defun my-gnome-register-signals (client-path)
    "Register for QueryEndSession and EndSession signals from GNOME SessionManager."
    (setq my-gnome-client-path client-path)
    (let ((end-session-response
           (lambda (&optional _arg)
             (dbus-call-method-asynchronously
              :session "org.gnome.SessionManager"
              my-gnome-client-path
              "org.gnome.SessionManager.ClientPrivate"
              "EndSessionResponse" nil t ""))))
      (dbus-register-signal
       :session "org.gnome.SessionManager" my-gnome-client-path
       "org.gnome.SessionManager.ClientPrivate" "QueryEndSession"
       end-session-response)
      (dbus-register-signal
       :session "org.gnome.SessionManager" my-gnome-client-path
       "org.gnome.SessionManager.ClientPrivate" "EndSession"
       (lambda (_arg)
         (add-hook 'kill-emacs-hook end-session-response t)
         (kill-emacs)))))

  (dbus-call-method-asynchronously
   :session
   "org.gnome.SessionManager" "/org/gnome/SessionManager" "org.gnome.SessionManager"
   "RegisterClient" #'my-gnome-register-signals "Emacs server"
   (getenv "DESKTOP_AUTOSTART_ID")))

(mapc #'disable-theme custom-enabled-themes)

(use-package modus-themes
  :init
  (setq modus-themes-to-toggle '(modus-vivendi modus-operandi))
  (setq modus-themes-italic-constructs t)
  (setq modus-themes-bold-constructs t)
  (setq modus-themes-variable-pitch-ui t)
  (setq modus-themes-mixed-fonts t)
  (setq modus-themes-prompts '(bold))
  (setq modus-themes-headings '((1 . (light variable-pitch 1.3))
                                (2 . (rainbow background 1.2))
                                (3 . (rainbow bold 1.1))
                                (agenda-date . (1.1))
                                (agenda-structure . (variable-pitch light 1.3))
                                (t . (medium))))
  (setq modus-themes-common-palette-overrides
        '((bg-mode-line-active bg-lavender)
          (fg-mode-line-active fg-main)
          (border-mode-line-active bg-magenta-intense)
          (bg-hover bg-green-subtle)
          (bg-mode-line-inactive bg-inactive)
          (fg-mode-line-inactive fg-dim)
          (border-mode-line-inactive bg-inactive)
          (bg-tab-bar bg-cyan-nuanced)
          (bg-tab-current bg-magenta-intense)
          (bg-tab-other bg-cyan-subtle)))
  (setq modus-operandi-palette-overrides
        '((bg-inactive "#efefef")))
  (setq modus-vivendi-palette-overrides
        '((bg-inactive "#202020")))
  :config
  (defun my-modus-themes-fill-column-face ()
    "Make fill-column-indicator visible as a green line."
    (set-face-attribute 'fill-column-indicator nil
                        :foreground "green"
                        :background 'unspecified
                        :height 1.0))

  (defun my-modus-themes-init ()
    "Load the first theme from `modus-themes-to-toggle'."
    (modus-themes-load-theme (car modus-themes-to-toggle))
    (my-modus-themes-fill-column-face))

  (add-hook 'modus-themes-after-load-theme-hook #'my-modus-themes-fill-column-face)

  :bind ("<f5>" . modus-themes-toggle)
  :hook (after-init-hook . my-modus-themes-init))

(use-package spacious-padding
  :custom
  (spacious-padding-subtle-mode-line t)
  (spacious-padding-widths
   '(:internal-border-width 20
     :header-line-width 4
     :mode-line-width 10
     :tab-width 8
     :right-divider-width 20
     :scroll-bar-width 4
     :fringe-width 8))
  :config
  (spacious-padding-mode 1))

(use-package fontaine
  :custom
  (fontaine-presets
   '((regular
      :default-family "JetBrains Mono"
      :default-weight normal
      :default-height 120
      :fixed-pitch-family "JetBrains Mono"
      :fixed-pitch-weight nil
      :fixed-pitch-height 1.0
      :variable-pitch-family "Iosevka Aile"
      :variable-pitch-weight normal
      :variable-pitch-height 1.2
      :line-spacing 1)
     (large
      :inherit regular
      :default-height 140
      :variable-pitch-height 1.3)))
  :config
  (fontaine-set-preset 'regular)
  :hook (enable-theme-functions-hook . fontaine-apply-current-preset))

(add-hook 'org-mode-hook #'variable-pitch-mode)

(add-to-list 'global-mode-string
             `(t (,(user-login-name) "@" system-name " ")) t)

(defun my-startup-reset-gc ()
  "Restore GC settings after startup and GC when losing focus."
  (setq gc-cons-threshold (* 128 1024 1024)
        gc-cons-percentage 0.1)
  (add-function :after after-focus-change-function
                (lambda ()
                  (unless (frame-focus-state)
                    (garbage-collect))))
  (message "Emacs ready in %.2f seconds with %d garbage collections."
           (float-time (time-subtract after-init-time before-init-time))
           gcs-done))

(add-hook 'emacs-startup-hook #'my-startup-reset-gc)

(provide 'config)
;;; config.el ends here
