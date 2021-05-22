;;; early-init.el -*- lexical-binding: t; -*-

;; Performance improvements
(setq gc-cons-threshold most-positive-fixnum)

;; Disable some visual elements
(add-to-list 'default-frame-alist '(tool-bar-lines . 0))
(add-to-list 'default-frame-alist '(menu-bar-lines . 0))
(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))
(add-to-list 'default-frame-alist '(horizontal-scroll-bars . nil))
;; Disable WM decorations
;; (add-to-list 'default-frame-alist '(undecorated . t))

;; Ignore X resources
(advice-add #'x-apply-session-resources :override #'ignore)

;; Don't init `package.el', using `straight.el' instead
(setq package-enable-at-startup nil)

;; Font compacting can be very expensive
(setq inhibit-compacting-font-caches t)

;; Inhibits loading the default library
(setq inhibit-default-init t)

;; Inhibit resizing frame
(setq frame-inhibit-implied-resize t)

;; Frame sizes can increase/decrease by one pixel
(setq frame-resize-pixelwise t)

;; Disable startup features
(setq inhibit-startup-screen t
      inhibit-startup-message t)

;; Suppress GUI features
(setq use-dialog-box nil)

;; Auto-compile options
(setq load-prefer-newer t)
(setq auto-compile-mode-line-counter t)
(setq auto-compile-update-autoloads t)

;;; early-init.el ends here
