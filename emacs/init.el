;;; init.el -*- lexical-binding: t; -*-

(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

(setq user-full-name "Cristi Ctin"
      user-mail-address "john@doe.com")

;; No auto-save, backups or lockfiles
(setq auto-save-default nil
      backup-by-copying t
      create-lockfiles nil
      delete-old-versions t
      make-backup-files nil
      backup-inhibited t)

;; My fonts
(setq my-font "JetBrains Mono Light-11")
(set-face-attribute 'default nil :font my-font)
(set-frame-font my-font nil t)

(set-keyboard-coding-system  'utf-8)
(set-selection-coding-system 'utf-8)
(set-terminal-coding-system  'utf-8)
(prefer-coding-system 'utf-8)

;; Display Emojis
(set-fontset-font t 'unicode (font-spec :family "Noto Sans Symbols") nil 'prepend)
(set-fontset-font t 'symbol (font-spec :family "Noto Color Emoji") nil 'prepend)

;; Ask y/n instead of yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;; Don't stretch the cursor to fit wide characters
(setq-default x-stretch-cursor nil)

;; Supress GUI features #2
(when (featurep 'tooltip)    (tooltip-mode 0))
(when (featurep 'tool-bar)   (tool-bar-mode 0))
(when (featurep 'menu-bar)   (menu-bar-mode 0))
(when (featurep 'scroll-bar) (scroll-bar-mode 0))

;; Set window title
(setq-default frame-title-format '("%F - %b"))

;; Default major mode
(setq-default major-mode 'text-mode)

;; Resolve symlinks when opening files
(setq find-file-visit-truename t)
;; Suppress warning messages for symlinked files
(setq find-file-suppress-same-file-warnings t)

;; More performant rapid scrolling over unfontified regions
(setq-default fast-but-imprecise-scrolling t
              mouse-wheel-progressive-speed nil)

;; Hide cursor in other windows
(setq-default cursor-in-non-selected-windows nil)

;; More scroll settings
(setq hscroll-margin 1
      scroll-margin 1
      auto-window-vscroll nil
      mouse-wheel-scroll-amount '(2 ((shift) . hscroll)))

;; All commands work normally
(setq-default disabled-command-function nil)

;; Enable shifted motion keys
(setq-default shift-select-mode t)

(setq electric-pair-pairs '(
                           (?\{ . ?\})
                           (?\( . ?\))
                           (?\[ . ?\])
			               (?\" . ?\")
			               ))

(add-hook 'emacs-startup-hook
          (lambda ()
            ;; Visualize matching parens
            (show-paren-mode t)
            ;; Auto-match parentheses
            (electric-pair-mode t)
            ;; Highlight current line
            (global-hl-line-mode t)
            ;; Typed text replaces the selection
            (delete-selection-mode t)
            ))

;; Enable the visible bell
(setq visible-bell t)

;; Maximum length of kill ring before old elements are thrown away
(setq kill-ring-max 100)

;; Reduce bloat from kill-ring
(setq kill-do-not-save-duplicates t)

;; Spaces vs tabs
(setq-default indent-tabs-mode nil
              tab-always-indent nil
              default-tab-width 4
              tab-width 4)

;; Line numbers
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'conf-mode-hook #'display-line-numbers-mode)
;;
(setq-default display-line-numbers-width 3
              display-line-numbers-widen t
              display-line-numbers-type 'absolute)

;; All automatic configurations in separate file
(setq custom-file (concat user-emacs-directory "custom.el"))
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file 'noerror)


;; External Packages !!
;;
(setq package-enable-at-startup nil)
;; use-package automatically invokes straight.el
(setq straight-use-package-by-default t
      straight-check-for-modifications nil
      straight-vc-git-default-protocol 'https)
;; straight.el bootstrap code
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Integration with use-package
(straight-use-package 'use-package)

;; use-package initialization
(setq init-file-debug nil)
(if init-file-debug
    (setq use-package-verbose t
          use-package-expand-minimally nil
          use-package-compute-statistics t
          debug-on-error t)
  (setq use-package-verbose nil
        use-package-expand-minimally t))
(eval-when-compile (require 'use-package))

;; (use-package auto-compile
;;   :demand t
;;   :init
;;   (progn
;;     (setq load-prefer-newer t)
;;     (setq auto-compile-mode-line-counter t)
;;     (setq auto-compile-source-recreate-deletes-dest t)
;;     (setq auto-compile-toggle-deletes-nonlib-dest t)
;;     (setq auto-compile-update-autoloads t))
;;   :hook (auto-compile-inhibit-compile . auto-compile-inhibit-compile-detached-git-head)
;;   :config
;;   (auto-compile-on-load-mode)
;;   (auto-compile-on-save-mode))

;; Dired config
;;
(use-package dired
  :ensure nil
  :straight nil
  :init
  ;; Always delete and copy recursively
  (setq dired-recursive-deletes 'top
        dired-recursive-copies 'always
        ;; Ask if destination dirs should get created when copying/removing
        dired-create-destination-dirs 'ask
        ;; Human readable units
        dired-listing-switches "-alh -v --group-directories-first"))

;; Asynchronous processing lib
;;
(use-package async
  :init
  (dired-async-mode 1)
  (async-bytecomp-package-mode 1))

(use-package diminish
  :defer t)

;; Enable visual-line almost everywhere
;;
(use-package simple
  :ensure nil
  :straight nil
  :init
  (setq-default fill-column 100
                word-wrap t)
  :hook
  (prog-mode . visual-line-mode)
  (text-mode . visual-line-mode))

;; Highlight trailing space-like characters
(use-package whitespace
  :ensure nil
  :straight nil
  :hook
  (prog-mode . whitespace-mode)
  (text-mode . whitespace-mode)
  :custom
  (whitespace-style '(face empty indentation::space tab trailing)))

;; ;; Automatically refresh the buffer when the file changes
;; ;;
;; (use-package autorevert
;;   :demand t
;;   :ensure nil
;;   :straight nil
;;   :init
;;   ;; Only rely on the OS notification mechanism
;;   (setq auto-revert-avoid-polling t)
;;   :config
;;   (global-auto-revert-mode t))

;; Nice color theme
;; (use-package kaolin-themes
;;   :config
;;   (load-theme 'kaolin-galaxy t))

(use-package doom-themes
  :init
  ;; Global settings (defaults)
  (setq doom-theme 'doom-sourcerer
        doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  :config
  (load-theme doom-theme t)
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Corrects (and improves) org-mode's native fontification
  (doom-themes-org-config))

;; ;; Nice terminal
;; (use-package vterm
;;   :defer t
;;   ;; :commands (vterm
;;   ;;            vterm-other-window)
;;   (:map vterm-mode-map
;;         ("C-c C-c" . vterm-send-C-c)))

;; Evil Mode
;;
(use-package evil
  :init
  (setq evil-respect-visual-line-mode t
        evil-undo-system 'undo-tree
        evil-want-fine-undo t
        evil-want-keybinding nil
        evil-want-integration t)
  :config
  (evil-mode t))

(use-package undo-tree
  :init
  (setq undo-tree-visualizer-diff t
        undo-tree-visualizer-timestamps t)
  :config
  (global-undo-tree-mode t))

(use-package evil-collection
  :after (evil magit)
  :config
  (evil-collection-init 'magit))

;; Select and edit matches interactively
;;
(use-package evil-multiedit
  :after evil
  :config
  ;; Match the word under cursor (i.e. make it an edit region)
  ;; Consecutive presses will incrementally add the next unmatched match
  (define-key evil-normal-state-map (kbd "M-d") 'evil-multiedit-match-and-next)
  ;; Match selected region
  (define-key evil-visual-state-map (kbd "M-d") 'evil-multiedit-match-and-next)
  ;; Insert marker at point
  (define-key evil-insert-state-map (kbd "M-d") 'evil-multiedit-toggle-marker-here)
  ;; Same as M-d but in reverse
  (define-key evil-normal-state-map (kbd "M-D") 'evil-multiedit-match-and-prev)
  (define-key evil-visual-state-map (kbd "M-D") 'evil-multiedit-match-and-prev)
  ;; For moving between edit regions
  (define-key evil-multiedit-state-map (kbd "C-n") 'evil-multiedit-next)
  (define-key evil-multiedit-state-map (kbd "C-p") 'evil-multiedit-prev)
  (define-key evil-multiedit-insert-state-map (kbd "C-n") 'evil-multiedit-next)
  (define-key evil-multiedit-insert-state-map (kbd "C-p") 'evil-multiedit-prev))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode t))

(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode t))

(use-package expand-region
  :after evil
  :bind ("C-=" . er/expand-region))


(use-package popup-kill-ring
  :after evil
  :bind ("C-M-y" . popup-kill-ring))


(use-package yasnippet
  :bind
  (:map yas-minor-mode-map
        ("TAB" . nil)
        ([tab] . nil))
  :hook
  (prog-mode . yas-minor-mode)
  (text-mode . yas-minor-mode)
  :custom
  (yas-verbosity 2)
  :config
  (yas-reload-all))


;; General keys
(use-package general
  :config
  (general-create-definer global-definer
    :keymaps 'override
    :prefix  "SPC"
    :non-normal-prefix "C-SPC"
    :states  '(normal visual))
  (global-definer
    ;; unbind SPC and give it a title for which-key
    ""  '(nil :which-key "Lieutenant General prefix")
    "!"  'shell-command
    ";"  'eval-expression
    ":"  'counsel-M-x
    ;;
    "b" '(:ignore t :wk "B")
    "bB"  'ibuffer-other-window
    "bI"  'counsel-ibuffer
    "bb"  'ivy-switch-buffer
    "bk"  'kill-buffer
    "bn"  'next-buffer
    "bp"  'previous-buffer
    "br"  'revert-buffer
    "bx"  'kill-current-buffer
    ;;
    "c" '(:ignore t :wk "C")
    "cl"  'comment-line
    "cr"  'comment-or-uncomment-region
    ;;
    "F" '(:ignore t :wk "Frame")
    "FD"  'delete-other-frames
    "Fd"  'delete-frame
    "Fm"  'toggle-frame-maximized
    "Fo"  'other-frame
    ;;
    "f" '(:ignore t :wk "File")
    "f."  'find-file
    "fd"  'dired
    "fr"  'recentf-open-files
    "fs"  'save-buffer
    ;;
    "g" '(:ignore t :wk "G")
    "gg"  'magit-status
    "gf"  'find-function
    "gv"  'find-variable
    ;;
    "i" '(:ignore t :wk "I")
    "ii"  'insert-char
    "iu"  'counsel-unicode-char
    "iy"  'counsel-yank-pop
    ;;
    "n" '(:ignore t :wk "N")
    "nf"  'narrow-to-defun
    "np"  'narrow-to-page
    "nr"  'narrow-to-region
    "nw"  'widen
    ;;
    "o" '(:ignore t :wk "O")
    "op" 'treemacs
    ;;
    "t" '(:ignore t :wk "T")
    "tF" 'toggle-frame-fullscreen
    "tn" 'centaur-tabs-forward
    "tp" 'centaur-tabs-backward
    ;;
    "w" '(:ignore t :wk "W")
    "wB" #'balance-windows-area
    "wb" #'balance-windows
    "wk" #'kill-buffer-and-window
    "wo" #'delete-other-windows
    "wp" #'evil-window-prev
    "ws" #'evil-window-split
    "wv" #'evil-window-vsplit
    "ww" #'evil-window-next
    "wx" #'evil-window-delete
    ;;
    "x" '(:ignore t :wk "Text manip")
    "xl" #'sort-lines))

(use-package which-key
  :diminish
  :init
  (setq which-key-sort-order 'which-key-key-order-alpha
        which-key-sort-uppercase-first nil
        which-key-popup-type 'minibuffer
        which-key-add-column-padding 1
        which-key-allow-evil-operators t
        which-key-idle-delay 1.5
        which-key-min-display-lines 5
        which-key-side-window-slot -10
        which-key-show-operator-state-maps t)
  :config
  (which-key-mode t))


(use-package all-the-icons)

;; Top visual tabs
(use-package centaur-tabs
  :init
  (setq centaur-tabs-height 26
        centaur-tabs-style "bar"
        centaur-tabs-set-bar 'left
        centaur-tabs-close-button "✕"
        centaur-tabs-modified-marker "•"
        centaur-tabs-gray-out-icons 'buffer
        centaur-tabs-set-modified-marker t)
  :config
  (centaur-tabs-headline-match)
  (centaur-tabs-mode t))

;; Bottom visual mode-line
(use-package doom-modeline
  :init
  (setq doom-modeline-height 24
        doom-modeline-irc nil
        doom-modeline-gnus nil
        doom-modeline-mu4e nil)
  :config
  (doom-modeline-mode t))


(defun +magit/quit (&optional kill-buffer)
  "Bury the current magit buffer.
If KILL-BUFFER, kill this buffer instead of burying it.
If the buried/killed magit buffer was the last magit buffer open for this repo,
kill all magit buffers for this repo."
  (interactive "P")
  (let ((topdir (magit-toplevel)))
    (funcall magit-bury-buffer-function kill-buffer)
    (or (cl-find-if (lambda (win)
                      (with-selected-window win
                        (and (derived-mode-p 'magit-mode)
                             (equal magit--default-directory topdir))))
                    (window-list))
        (+magit/quit-all))))

(defun +magit/quit-all ()
  "Kill all magit buffers for the current repository."
  (interactive)
  (mapc #'+magit--kill-buffer (magit-mode-get-buffers))
  (+magit-mark-stale-buffers-h))

(defun +magit--kill-buffer (buf)
  (when (and (bufferp buf) (buffer-live-p buf))
    (let ((process (get-buffer-process buf)))
      (if (not (processp process))
          (kill-buffer buf)
        (with-current-buffer buf
          (if (process-live-p process)
              (run-with-timer 5 nil #'+magit--kill-buffer buf)
            (kill-process process)
            (kill-buffer buf)))))))

;; Git
;;
(use-package magit
  :init
  (setq magit-refresh-status-buffer nil
        magit-save-repository-buffers nil
        magit-revision-insert-related-refs nil)
  :config
  ;; Clean up after magit by killing leftover magit buffers and reverting
  ;; affected buffers (or at least marking them as need-to-be-reverted).
  (define-key magit-mode-map "q" #'+magit/quit)
  (define-key magit-mode-map "Q" #'+magit/quit-all)
  ;; Close transient with ESC
  (define-key transient-map [escape] #'transient-quit-one)

  ;; Add additional switches that seem common enough
  (transient-append-suffix 'magit-fetch "-p"
    '("-t" "Fetch all tags" ("-t" "--tags")))
  (transient-append-suffix 'magit-pull "-r"
    '("-a" "Autostash" "--autostash")))

;; Git diff gutter
;;
(use-package git-gutter-fringe
  :init
  (setq git-gutter:disabled-modes '(fundamental-mode image-mode pdf-view-mode))
  ;; Only enable the backends that are available, so it doesn't have to check
  ;; when opening each buffer
  (setq git-gutter:handled-backends
        (cons 'git (cl-remove-if-not
                    #'executable-find (list 'hg 'svn 'bzr)
                    :key #'symbol-name)))
  (setq indicate-buffer-boundaries nil
        indicate-empty-lines nil)
  ;; Subtle diff indicators in the fringe
  (if (fboundp 'fringe-mode) (fringe-mode '4))
  :config
  ;; Thin fringe bitmaps
  (define-fringe-bitmap 'git-gutter-fr:added [224]
    nil nil '(top repeated))
  (define-fringe-bitmap 'git-gutter-fr:modified [224]
    nil nil '(top repeated))
  (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240]
    nil nil 'bottom)
  ;; Text modes for now
  (add-hook 'org-mode-hook 'git-gutter-mode)
  (add-hook 'markdown-mode-hook 'git-gutter-mode)
  ;; Update git-gutter when using magit commands
  (advice-add #'magit-stage-file   :after #'+vc-gutter-update-h)
  (advice-add #'magit-unstage-file :after #'+vc-gutter-update-h)
  ;; Update git-gutter on focus (in case of using git externally)
  (add-hook 'focus-in-hook #'git-gutter:update-all-windows))


;; Minibuffer completion tools
(use-package ivy
  :diminish
  :config
  (setq ivy-use-virtual-buffers t)
  (ivy-mode 1))

(use-package counsel
  :diminish
  :after ivy
  :config
  (counsel-mode 1))

(use-package swiper
  :after ivy)

(use-package ivy-rich
  :diminish
  :after counsel
  :config
  (ivy-rich-mode 1))


;; Projects
(use-package projectile
  :defer t
  :init
  (setq projectile-project-search-path '("~/Dev/zyte/" "~/org/" "~/.emacs.default/"))
  (setq projectile-completion-system 'ivy))

;; Tree
(use-package treemacs
  :defer t
  :init
  (setq treemacs-follow-after-init t
        treemacs-follow-mode nil
        treemacs-sorting 'alphabetic-case-insensitive-asc
        treemacs-width 24) ;; Width of the treemacs window
  :config
  (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action)
  :bind
  (:map global-map
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t T"   . treemacs-display-current-project-exclusively)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after (treemacs evil))

;; Tree + Projects = Love
(use-package treemacs-projectile
  :after (treemacs projectile))

(use-package treemacs-icons-dired
  :after (treemacs dired)
  :config (treemacs-icons-dired-mode))


;; Very helpful
(use-package helpful
  :commands (helpful-callable
             helpful-function
             helpful-variable
             helpful-key
             helpful-macro
             helpful-command)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable))

;; Recent files
(use-package recentf
  :hook (emacs-startup . recentf-mode)
  :init (setq recentf-max-saved-items 1000
              recentf-max-menu-items 30
              recentf-auto-cleanup nil
              recentf-exclude
              '("\\.?cache" ".cask" "url" "bookmarks" "COMMIT_EDITMSG\\'"
                "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\|bmp\\|xpm\\)$"
                "\\.last$" "/G?TAGS$" "/.elfeed/" "~$" "\\.log$"
                "^/tmp/" "^/var/folders/.+$" "^/ssh:" "/persp-confs/"
                (lambda (file) (file-in-directory-p file package-user-dir))))
  :config
  (push (expand-file-name recentf-save-file) recentf-exclude)
  (add-to-list 'recentf-filename-handlers #'abbreviate-file-name))

;; Persist variables across sessions
(use-package savehist
  :hook (emacs-startup . savehist-mode)
  :config
  (setq history-length 1000
        savehist-save-minibuffer-history t
        savehist-autosave-interval nil     ; save on kill only
        savehist-additional-variables
        '(kill-ring                        ; persist clipboard
          register-alist                   ; persist macros
          mark-ring global-mark-ring       ; persist marks
          search-ring regexp-search-ring)) ; persist searches
  )

;; Org Mode
;;
(use-package org
  :defer t
  :config
  (setq org-modules nil ;; Faster loading
        org-directory "~/org/"
        ;; Show entities in \name form
        org-pretty-entities nil
        ;; Hide the emphasis marker characters
        org-hide-emphasis-markers t
        org-ellipsis "…"
        ;; invisible region before inserting or deleting a char
        org-catch-invisible-edits 'smart
        org-support-shift-select 'always
        ;; Link is to the current directory below, otherwise fully qualify the link
        org-link-file-path-type 'relative
        ;; Keep track of when a certain TODO item was marked as done
        org-log-done 'time
        ;; No TOC
        org-export-with-toc nil
        ;; Turn on native code fontification
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-cycle-separator-lines 1
        ;; Indentation per level in number of characters
        org-indent-indentation-per-level 1
        ;; Turn on indent for all org files
        org-startup-indented t))

(use-package evil-org
  :after (evil org)
  :config
  (add-hook 'org-mode-hook 'evil-org-mode))


(use-package markdown-mode
  :defer t
  :mode ("README\\(?:\\.md\\)?\\'" . gfm-mode)
  :init
  (setq markdown-command "multimarkdown"
        markdown-asymmetric-header t
        markdown-italic-underscore t
        markdown-fontify-code-blocks-natively t
        markdown-make-gfm-checkboxes-buttons t))

(use-package evil-markdown
  :straight (:type git :host github :repo "Somelauw/evil-markdown")
  :after (evil markdown)
  :config
  (add-hook 'markdown-mode-hook 'evil-markdown-mode))


(use-package beacon
  :config
  (beacon-mode 1))


;; Helpers
;;
(defun close-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))


;; Performance improvements
;; GC runs less often, which speeds up some operations
;; The final values are intentionally defined at the end of the file
(setq gc-cons-threshold 33554432 ; 32MB
      gc-cons-percentage 0.2)


;;; init.el ends here
