;;; init.el

(setq user-full-name "Cristi Ctin"
      user-mail-address "john@doe.com")

;; Performance improvements
;; GC runs less often, which speeds up some operations
(setq gc-cons-threshold 100000000)

;; No auto-save and backups please
(setq auto-save-default nil)
(setq make-backup-files nil)


(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font 12")
(set-frame-font "JetBrainsMono Nerd Font 12" nil t)

;; Display Emoji properly
(set-fontset-font t 'symbol (font-spec :family "Noto Color Emoji") nil 'prepend)


;; Set window title
(setq-default frame-title-format '("%F - %b"))

;; Disable startup screen
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq initial-buffer-choice "index.org")
;; Some internal padding?
;; (fringe-mode 8)

;; Disable tool bar and scroll bar
(when (featurep 'tool-bar) (tool-bar-mode 0))
(when (featurep 'scroll-bar) (scroll-bar-mode 0))
;; Not yet, I still use it
;; (when (featurep 'menu-bar) (menu-bar-mode 0))

;; All commands work normally
(setq disabled-command-function nil)

;; Enable shifted motion keys
(setq shift-select-mode t)

;; Selected text will be overwritten when you start typing
(delete-selection-mode t)

;; Set up the visible bell
(setq visible-bell t)

;; Ask y/n instead of yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;; Automatically refresh the buffer when the file changes
(global-auto-revert-mode t)

;; Highlight current line
(global-hl-line-mode 1)

;; All automatic configurations in separate file
(setq custom-file (concat user-emacs-directory "custom.el"))
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file 'noerror)

;; Dired config
(require 'dired)
;; Human readable units
(setq-default dired-listing-switches "-alh")
(define-key dired-mode-map (kbd "RET")
  'dired-find-alternate-file) ; was dired-advertised-find-file
(define-key dired-mode-map (kbd "^")
  (lambda () (interactive) (find-alternate-file ".."))) ; was dired-up-directory
;; Open dired in current directory
(global-set-key (kbd "C-c d") (lambda () (interactive) (dired ".")))


;; Packages !!
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                        ("elpa" . "https://elpa.gnu.org/packages/")
                        ("org" . "https://orgmode.org/elpa/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'package)
(require 'use-package-ensure)
(setq use-package-always-ensure t)


(use-package general
  :config
  (general-evil-setup))

(use-package evil
  :config
  (evil-mode 1)
  (evil-set-undo-system 'undo-tree)
)

(use-package evil-escape
  :defer t)

;; Exit visual mode with jk
(setq-default evil-escape-delay 0.25)
(setq-default evil-escape-key-sequence "jk")
(evil-escape-mode)


(use-package org
  :defer t)

(use-package evil-org
  :after (evil org)
  :config
  (add-hook 'org-mode-hook 'evil-org-mode))

(setq org-directory "~/org/")
;; Link is to the current directory below, otherwise fully qualify the link
(setq org-link-file-path-type 'relative)
;; Keep track of when a certain TODO item was marked as done
(setq org-log-done 'time)


(use-package markdown-mode
  :defer t
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"
              markdown-make-gfm-checkboxes-buttons t))


(use-package which-key
  :defer t
  :config (which-key-mode))
(setq which-key-allow-evil-operators t)
(setq which-key-show-operator-state-maps t)

(use-package all-the-icons
  :defer t)

(use-package beacon
  :defer t)
(beacon-mode 1)

;;; init.el ends here
