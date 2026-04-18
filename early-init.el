;;; early-init.el --- early init file -*- lexical-binding: t; -*-
;; Time-stamp: "Last changed on 20260330T2215"
;;
;;; Commentary:
;; The file loaded before the init file that starts it all.
;;
;;; Code:
;;---------------------------------------------------------------------
;; Startup behavior & noise reduction
;;---------------------------------------------------------------------
;; Disable package.el entirely; straight.el handles everything
(setq package-enable-at-startup nil
      package-quickstart nil)

;; Remove command line options that aren't relevant to the current OS; this
;; results in slightly less processing at startup.
(unless (eq system-type 'gnu/linux)
  (setq command-line-x-option-alist nil))
(unless (eq system-type 'darwin)
  (setq command-line-ns-option-alist nil))

(setq site-run-file nil)

;; Set UTF-8 as the default coding system
(set-language-environment "UTF-8")

;; `set-language-environment' sets `default-input-method', which is unwanted.
(setq default-input-method nil)

;; Reduce rendering/line scan work by not rendering cursors or regions in
;; non-focused windows.
(setq-default cursor-in-non-selected-windows nil)

(setq inhibit-default-init nil)

;; Quiet startup
(setq inhibit-startup-screen t
      inhibit-startup-echo-area-message user-login-name
      inhibit-startup-message t
      inhibit-splash-screen t
      inhibit-startup-buffer-menu t
      initial-scratch-message "")

;; Less visual noise: no menu/toolbar/scrollbar in GUI.
;; Re-enable any of these later in init.el if desired.
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq ring-bell-function #'ignore
      server-client-instructions nil)

(add-to-list 'load-path
             (expand-file-name "straight/repos/org/lisp/" user-emacs-directory))

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 1.5)

(defvar my-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist my-file-name-handler-alist)))

(setq byte-compile-warnings nil)

(when (featurep 'native-compile)
  (setq native-comp-async-report-warnings-errors 'silent
        native-comp-jit-compilation t
        native-comp-async-jobs-number (max 1 (- (num-processors) 2))
        native-comp-speed 2
        native-compile-prune-cache t
        package-native-compile t)

  (let ((eln-cache (expand-file-name "eln-cache/" user-emacs-directory)))
    (when (file-directory-p eln-cache)
      (startup-redirect-eln-cache eln-cache))))

(setq use-dialog-box nil
      use-file-dialog nil)

(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode 1))

(setq load-prefer-newer t)

;; Allow switching configs via: emacs -q -l ~/other-config/init.el
(defconst user-emacs-directory
  (file-name-directory (or load-file-name (buffer-file-name)))
  "My emacs config directory.")

(defconst user-cache-directory
  (file-name-as-directory (concat user-emacs-directory ".cache"))
  "My emacs storage area for persistent files.")

(make-directory user-cache-directory t)

(setq inhibit-compacting-font-caches t
      redisplay-skip-fontification-on-input t
      fast-but-imprecise-scrolling nil
      jit-lock-defer-time 0)

;; Scroll behavior
(setq mouse-wheel-scroll-amount '(1
                                  ((shift) . 3)
                                  ((meta) . 6)
                                  ((control) . nil))
      mouse-wheel-progressive-speed nil
      mouse-wheel-follow-mouse t
      scroll-step 1
      scroll-conservatively 101
      scroll-margin 3
      scroll-preserve-screen-position t)

;; Set frame defaults early to reduce flicker/resizing on PGTK/Wayland.
;; Apply to both alists so daemon/client + normal startup behave consistently.
(let ((params '((frame-inhibit-implied-resize . t)
                (frame-resize-pixelwise . nil)
                (undecorated . nil)
                (left . 1000)
                (top . 100)
                (width  . 130)
                (height . 50)
                (title . "Emacs")
                (internal-border-width . 4))))
  (dolist (alist-var '(default-frame-alist initial-frame-alist))
    (dolist (p params)
      (setf (alist-get (car p) (symbol-value alist-var) nil nil #'eq)
            (cdr p)))))

(setq inhibit-double-buffering t)

;; Dark face early to prevent white flash before theme loads
(set-face-attribute 'default nil
                    :family "JetBrains Mono"
                    :height 120
                    :background "#282c34"
                    :foreground "#bbc2cf")

;; No bidirectional text — pure LTR for faster redisplay
(setq-default bidi-display-reordering nil
              bidi-paragraph-direction 'left-to-right
              bidi-inhibit-bpa t)

(provide 'early-init)

;;; early-init.el ends here
