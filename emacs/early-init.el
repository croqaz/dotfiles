;;; early-init.el --- Early Init File -*- lexical-binding: t -*-
;;
;; THIS FILE IS TANGLED, DON'T EDIT

;; Performance improvements
(setq gc-cons-threshold most-positive-fixnum)

;; Disable some visual elements early
(add-to-list 'default-frame-alist '(border-width . 0))
(add-to-list 'default-frame-alist '(tool-bar-lines . 0))
(add-to-list 'default-frame-alist '(menu-bar-lines . 0))
(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))
(add-to-list 'default-frame-alist '(horizontal-scroll-bars . nil))
;; Disable all WM decorations (maybe)
;; (add-to-list 'default-frame-alist '(undecorated . t))

;; Ignore X resources
(advice-add #'x-apply-session-resources :override #'ignore)

;; Don't init `package.el', using `straight.el' instead
(setq package-enable-at-startup nil)

;; Inhibits loading the default library
(setq inhibit-default-init t)

;; Font compacting can be very expensive
(setq inhibit-compacting-font-caches t)

;; Inhibit resizing frame
(setq frame-inhibit-implied-resize t)

;; Frame sizes can increase/decrease by one pixel
(setq frame-resize-pixelwise t)

;; Disable startup features
(setq inhibit-startup-screen t
      inhibit-startup-message t
      initial-scratch-message ";; scratch\n")

;; Auto-compile options
(setq load-prefer-newer t)
(setq auto-compile-mode-line-counter t)
(setq auto-compile-update-autoloads t)

;; THIS FILE IS TANGLED, DON'T EDIT
;;
;;; early-init.el ends here
