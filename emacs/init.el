;;; init.el -*- lexical-binding: t; -*-
;;
;; THIS FILE IS TANGLED, DON'T EDIT

(setq user-full-name "Cristi Ctin"
      user-mail-address "john@doe.com")

(defconst my-emacs-d (file-name-as-directory user-emacs-directory)
  "My emacs.d folder.")

(defconst my-lisp-dir (concat my-emacs-d "lisp")
  "My lisp folder.")

;; Disable novice, all commands work normally
(setq-default disabled-command-function nil)

;; UTF encoding everywhere
(set-keyboard-coding-system  'utf-8)
(set-selection-coding-system 'utf-8)
(set-terminal-coding-system  'utf-8)
(prefer-coding-system 'utf-8)

;; No auto-save, backups or lockfiles
(setq auto-save-default nil
      backup-by-copying t
      create-lockfiles nil
      delete-old-versions t
      make-backup-files nil
      backup-inhibited t)

;; Supress GUI features
(when (featurep 'tooltip)    (tooltip-mode 0))
(when (featurep 'tool-bar)   (tool-bar-mode 0))
(when (featurep 'menu-bar)   (menu-bar-mode 0))
(when (featurep 'scroll-bar) (scroll-bar-mode 0))
(setq use-dialog-box nil)
(setq use-file-dialog nil)

;; Space on the left side, for git gutter
(set-fringe-mode '(5 . 0))

;; Set window title
(setq-default frame-title-format '("%F - %b"))

(setq my-font "JetBrains Mono Light")
(set-face-attribute 'default nil :family my-font :height 105)
(set-face-attribute 'fixed-pitch nil :family my-font :height 105)
(set-face-attribute 'variable-pitch nil :family "Inter Light" :height 105)
(set-frame-font my-font nil t)

;; Display symbols and emojis
(set-fontset-font t 'unicode (font-spec :family "Noto Sans Symbols") nil 'prepend)
(set-fontset-font t 'symbol (font-spec :family "Noto Color Emoji") nil 'prepend)

(setq uniquify-buffer-name-style 'reverse
      uniquify-separator " • "
      uniquify-ignore-buffers-re "^\\*")

;; Show a symbol at the start and end of the buffer
(setq indicate-buffer-boundaries '((top . left) (bottom . left)))
;; Hide cursor in other windows
(setq-default cursor-in-non-selected-windows nil)

;; Don't stretch the cursor to fit wide characters
(setq-default x-stretch-cursor nil)

;; Performant rapid scrolling
(setq-default fast-but-imprecise-scrolling t
              mouse-wheel-progressive-speed nil
              mouse-wheel-scroll-amount '(2 ((shift) . hscroll)))

;; More scroll settings
(setq scroll-margin 1
      scroll-conservatively 0
      auto-window-vscroll nil)

;; Disable bidirectional writing
(setq bidi-inhibit-bpa t)
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)

;; Reduce bloat from kill-ring
(setq kill-do-not-save-duplicates t)

;; Max len of kill-ring before old elements are thrown away
(setq kill-ring-max 100)

;; Spaces vs tabs
(setq-default indent-tabs-mode nil
              tab-always-indent nil
              default-tab-width 4
              tab-width 4)

(setq electric-pair-pairs '((?\{ . ?\})
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
            ))

;; Enable/ disable debug
(setq init-file-debug nil)

(setq package-enable-at-startup nil
      straight-use-package-by-default t
      straight-check-for-modifications '(check-on-save)
      straight-vc-git-default-clone-depth 1
      straight-vc-git-default-protocol 'https)

;; straight bootstrap code
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

;; use-package initialization
(if init-file-debug
    (setq use-package-verbose t
          use-package-expand-minimally nil
          use-package-compute-statistics t
          debug-on-error t)
  (setq use-package-verbose nil
        use-package-expand-minimally t))

;; straight integration with use-package
(straight-use-package 'use-package)
(eval-when-compile (require 'use-package))

;; Useful macro
(defmacro use-feature (name &rest args)
  "Like `use-package' but with straight and ensure disabled.
NAME and ARGS are in `use-package'."
  (declare (indent defun))
  `(use-package ,name
     :straight nil
     :ensure nil
     ,@args))

(use-package async
  :demand t
  :config
  (dired-async-mode t)
  (async-bytecomp-package-mode t))

;; (use-package doom-themes
;;   :init
;;   (setq doom-theme 'doom-sourcerer
;;         doom-themes-enable-bold t    ; if nil, bold is universally disabled
;;         doom-themes-enable-italic t) ; if nil, italics is universally disabled
;;   :config
;;   (load-theme doom-theme t)
;;   ;; Enable flashing mode-line on errors
;;   (doom-themes-visual-bell-config)
;;   ;; Corrects (and improves) org-mode's native fontification
;;   (doom-themes-org-config))

;; (use-package solo-jazz-theme
;;  :config
;;  (load-theme 'solo-jazz t))

(use-package modus-themes
  :init
  (setq modus-themes-slanted-constructs t
        modus-themes-bold-constructs t
        modus-themes-fringes 'subtle
        modus-themes-no-mixed-fonts t
        modus-themes-scale-headings t
        modus-themes-subtle-line-numbers t)
  (setq modus-themes-mode-line 'borderless-3d)
  (setq modus-themes-org-blocks 'tinted-gray)
  ;; Load the theme files before enabling a theme
  (modus-themes-load-themes)
  :custom
  (modus-themes-operandi-color-overrides
   '((bg-main . "#F0F2F7")
     (fg-main . "#101010")
     (fg-window-divider-inner . "#FAFAFA")))
  (modus-themes-vivendi-color-overrides
   '((bg-main . "#101010")
     (fg-main . "#FAFAFA")
     (fg-window-divider-inner . "#101010")))
  :config
  (modus-themes-load-operandi)
  ;; (modus-themes-load-vivendi)
  :bind ("<f5>" . modus-themes-toggle))

;; (setq modus-themes-vivendi-color-overrides nil)
;; (setq modus-themes-vivendi-color-overrides
;;       '((bg-main . "#282828") (fg-main . "#fdf4c1")
;;         (bg-dim . "#32302f") (fg-dim . "#f4e8ba")
;;         (bg-alt . "#3c3836") (fg-alt . "#ebdbb2")
;;         (bg-hl-line . "#191628")
;;         (bg-active . "#282e46")
;;         (bg-inactive . "#1a1e39")
;;         (bg-region . "#393a53")
;;         (bg-header . "#202037")
;;         (bg-tab-bar . "#262b41")
;;         (bg-tab-active . "#120f18")
;;         (bg-tab-inactive . "#3a3a5a")
;;         (fg-unfocused . "#9a9aab")))
;; (load-theme 'modus-vivendi t)

;; Resolve symlinks when opening files
(use-feature files
  :init
  (setq require-final-newline t
        find-file-visit-truename t
        find-file-suppress-same-file-warnings t))

;; Builtin dired config
(use-feature dired
  :init
  ;; Always delete and copy recursively
  (setq dired-recursive-deletes 'top
        dired-recursive-copies 'always
        dired-dwim-target t
        ;; Ask if destination dirs should get created when copying/removing
        dired-create-destination-dirs 'ask
        ;; Human readable units
        dired-listing-switches "-alh -v --group-directories-first")
  :config
  (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
  (define-key dired-mode-map (kbd "^") (lambda () (find-alternate-file ".."))))

(use-feature dired-x)

;; Colourful dired
(use-package diredfl
  :after dired
  :hook (dired-mode . diredfl-mode))

;; Use zsh as default term shell
(setq-default explicit-shell-file-name "zsh")

(use-package vterm
  :defer t
  :commands (vterm vterm-other-window)
  :bind
  (:map vterm-mode-map
        ("C-c C-c" . vterm-send-C-c))
  :config
  (evil-set-initial-state 'vterm-mode 'emacs))

;; Enable visual-line, line and column almost everywhere
;;
(use-feature simple
  :defer t
  :custom
  (fill-column 100)
  (display-line-numbers-grow-only t)
  (display-line-numbers-type 'absolute)
  (display-line-numbers-widen t)
  (display-line-numbers-width 3)
  :hook
  (prog-mode . visual-line-mode)
  (text-mode . visual-line-mode)
  (prog-mode . display-line-numbers-mode)
  (text-mode . display-line-numbers-mode)
  (prog-mode . column-number-mode)
  (text-mode . column-number-mode))

;; Highlight space-like characters
;;
(use-feature whitespace
  :defer t
  :custom
  (whitespace-style '(face tabs empty trailing))
  :hook
  (text-mode . whitespace-mode)
  (prog-mode . whitespace-mode)
  ;; Trim whitespaces on save
  (before-save . delete-trailing-whitespace))

;; Highlight the current line
;;
(use-feature hl-line
  :defer t
  :hook
  (dired-mode . hl-line-mode)
  (prog-mode . hl-line-mode)
  (text-mode . hl-line-mode)
  :custom
  (hl-line-sticky-flag nil))

;; Automatically refresh the buffer when the file changes
;; Not enabled yet
;;
;; (use-feature autorevert
;;   :init
;;   ;; Only rely on the OS notification mechanism
;;   (setq auto-revert-avoid-polling t)
;;   :config
;;   (global-auto-revert-mode t))

(use-package evil
  :init
  (setq evil-respect-visual-line-mode t
        evil-kill-on-visual-paste nil
        evil-shift-width 2
        evil-undo-system 'undo-tree
        evil-kbd-macro-suppress-motion-error t
        evil-move-cursor-back nil
        evil-split-window-below  t  ;; move cursor below after split
        evil-vsplit-window-right t  ;; move cursor right after split
        evil-want-fine-undo   t     ;; remember changes in insert mode
        evil-want-integration t     ;; load evil-integration
        evil-want-Y-yank-to-eol t
        evil-want-keybinding nil)
  :config
  (evil-mode t))

(use-package evil-collection
  :after evil
  :custom
  (evil-collection-mode-list '(dired
                               flycheck
                               apropos
                               help
                               helpful
                               info
                               magit
                               man
                               simple
                               ))
  :config
  (evil-define-key 'normal 'global "zx" #'kill-current-buffer)
  (evil-define-key 'visual 'global "g<" #'evil-visual-shift-left)
  (evil-define-key 'visual 'global "g>" #'evil-visual-shift-right)
  (evil-collection-init))

(defun evil-visual-shift-left()
  (interactive)
  ;; (call-interactively #'evil-shift-left)
  (evil-shift-left (region-beginning) (region-end))
  (evil-normal-state)
  (evil-visual-restore))

(defun evil-visual-shift-right()
  (interactive)
  ;; (call-interactively #'evil-shift-right)
  (evil-shift-right (region-beginning) (region-end))
  (evil-normal-state)
  (evil-visual-restore))

;; Will re-use these keys
(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "SPC") nil)
  (define-key evil-motion-state-map (kbd "RET") nil))

(use-package undo-tree
  :hook
  (prog-mode . undo-tree-mode)
  (text-mode . undo-tree-mode)
  :init
  (setq undo-tree-visualizer-diff t
        undo-tree-visualizer-timestamps t))

(use-package origami
  :hook
  (prog-mode . origami-mode)
  (text-mode . origami-mode))

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
  (define-key evil-visual-state-map (kbd "M-D") 'evil-multiedit-match-and-prev))

;; For moving between edit regions?
;; (define-key evil-multiedit-state-map (kbd "C-n") 'evil-multiedit-next)
;; (define-key evil-multiedit-state-map (kbd "C-p") 'evil-multiedit-prev)
;; (define-key evil-multiedit-insert-state-map (kbd "C-n") 'evil-multiedit-next)
;; (define-key evil-multiedit-insert-state-map (kbd "C-p") 'evil-multiedit-prev)

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

;; Pretty eye candy 🍬
(use-package evil-goggles
  :after evil
  :config
  (evil-goggles-mode)
  (evil-goggles-use-diff-faces))

(use-package company
  :defer 5
  :hook
  ;; (text-mode . company-mode)
  (prog-mode . company-mode)
  :init
  (setq company-minimum-prefix-length 2
        company-require-match 'never
        company-selection-wrap-around t
        company-tooltip-align-annotations t
        company-dabbrev-ignore-case t
        company-tooltip-limit 14
        company-tooltip-maximum-width 50
        company-global-modes
        '(not message-mode
              help-mode
              vterm-mode
              minibuffer-inactive-mode)
        company-frontends
        '(company-pseudo-tooltip-frontend ;; always show candidates in overlay tooltip
          company-echo-metadata-frontend) ;; show selected candidate docs in echo area
        company-auto-complete nil
        company-auto-complete-chars nil))

(use-package yasnippet
  :disabled
  ;; :commands yas-global-mode
  :custom
  (yas-verbosity 3))

;; Loading the doom snippets takes forever
;; (use-package doom-snippets
;;   :after yasnippet
;;   :hook (window-setup . yas-reload-all)
;;   :straight (:host github :repo "hlissner/doom-snippets" :files ("*.el" "*")))

(use-package auto-yasnippet
  :defer t)

;; Very helpful
(use-package helpful
  :defer 2
  :commands (helpful-callable
             helpful-function
             helpful-variable
             helpful-key
             helpful-macro
             helpful-command)
  :init
  (setq apropos-do-all t)
  :custom
  ;; Integrate with counsel
  (counsel-describe-function-function  #'helpful-callable)
  (counsel-describe-symbol-function    #'helpful-symbol)
  (counsel-describe-variable-function  #'helpful-variable))

;; Incredibly useful
(use-package which-key
  :defer 3
  :hook (after-init . which-key-mode)
  :init
  (setq which-key-sort-order 'which-key-key-order-alpha
        which-key-sort-uppercase-first nil
        which-key-popup-type 'minibuffer
        which-key-add-column-padding 2
        which-key-allow-evil-operators t
        which-key-idle-delay 1.5
        which-key-min-display-lines 5
        which-key-side-window-slot -10
        which-key-show-operator-state-maps t))

(use-package ivy
  :hook (after-init . ivy-mode)
  :init
  (setq ivy-wrap t
        ivy-fixed-height-minibuffer t
        ivy-sort-max-size 7500
        ivy-use-selectable-prompt t
        ivy-use-virtual-buffers t))

(use-package counsel
  :after ivy
  :config
  (counsel-mode t))

(use-package swiper
  :after ivy)

(use-package ivy-rich
  :after ivy
  :init
  (setq ivy-rich-parse-remote-buffer nil)
  :config
  (ivy-rich-mode t)
  (ivy-rich-project-root-cache-mode t))

;; Recent files
;;
(use-package recentf
  :hook (emacs-startup . recentf-mode)
  :init
  (setq recentf-auto-cleanup 'never
        recentf-max-menu-items 50
        recentf-max-saved-items 1000
        recentf-save-file (expand-file-name "etc/recentf" my-emacs-d)
        recentf-exclude
        '("\\.?cache" ".cask" "url" "bookmarks" "COMMIT_EDITMSG\\'"
          "\\.\\(?:gz\\|zip\\|gif\\|svg\\|png\\|jpe?g\\|bmp\\|xpm\\)$"
          "\\.last$" "/G?TAGS$" "/.elfeed/" "~$" "\\.log$"
          "^/tmp/" "^/var/folders/.+$" "^/ssh:" "/persp-confs/"
          (lambda (file) (file-in-directory-p file package-user-dir))))
  :config
  (push (expand-file-name recentf-save-file) recentf-exclude)
  (add-to-list 'recentf-filename-handlers #'abbreviate-file-name))

;; Persist variables across sessions
;;
(use-package savehist
  :hook (emacs-startup . savehist-mode)
  :init
  (setq history-length 10000
        savehist-autosave-interval nil     ; save on kill only
        savehist-save-minibuffer-history t
        savehist-file (expand-file-name "etc/savehist" my-emacs-d)
        savehist-additional-variables
        '(kill-ring                        ; persist clipboard
          register-alist                   ; persist macros
          search-ring regexp-search-ring)) ; persist searches
  )

;; ;; Save Emacs Session
;; (use-feature desktop
;;   :bind ("C-c s" . desktop-save-in-desktop-dir)
;;   :hook
;;   (after-init . desktop-read)
;;   (after-init . desktop-save-mode)
;;   :init
;;   (setq desktop-files-not-to-save "^$"
;;         desktop-load-locked-desktop t
;;         desktop-restore-eager 3
;;         desktop-restore-frames nil
;;         desktop-path '("~/.emacs.default/"))
;;   (add-to-list 'desktop-modes-not-to-save 'dired-mode)
;;   (add-to-list 'desktop-modes-not-to-save 'help-mode)
;;   (add-to-list 'desktop-modes-not-to-save 'magit-mode)
;;   (add-to-list 'desktop-modes-not-to-save 'special-mode)
;;   (add-to-list 'desktop-modes-not-to-save 'fundamental-mode)
;;   (add-to-list 'desktop-modes-not-to-save 'completion-list-mode))

;; (use-package projectile
;;   :defer t
;;   :init
;;   (setq projectile-project-search-path '("~/Dev/" "~/org/"))
;;   (setq projectile-completion-system 'ivy))

;; (use-package counsel-projectile
;;   :after projectile
;;   :init
;;   ;; No highlighting visited files
;;   (ivy-set-display-transformer #'counsel-projectile-find-file nil))

(use-package org
  :defer t
  :init
  (setq org-modules nil ;; Faster loading
        org-directory "~/org/"
        ;; Show entities in \name form
        org-pretty-entities nil
        ;; Hide the emphasis marker characters
        org-ellipsis "…"
        org-hide-emphasis-markers t
        org-edit-src-content-indentation 0
        org-tags-column -66
        ;; invisible region before inserting or deleting a char
        org-catch-invisible-edits 'smart
        ;; shift-cursor commands select text when possible
        org-support-shift-select t
        ;; Link is to the current directory below, otherwise fully qualify the link
        org-link-file-path-type 'relative
        ;; Keep track of when a certain TODO item was marked as done
        org-log-done 'time
        ;; No TOC
        org-export-with-toc nil
        ;; Turn on native code fontification
        org-confirm-babel-evaluate nil
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-cycle-separator-lines 1
        ;; Indentation per level in number of characters
        org-indent-indentation-per-level 1
        ;; Turn on indent for all org files
        org-startup-indented t)
  :config
  ;; Enable org structure templates
  (add-to-list 'org-modules 'org-tempo t)
  ;; Add a few more templates
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  ;; Enable these babel languages:
  (org-babel-do-load-languages
   'org-babel-load-languages '(
                               (emacs-lisp . t)
                               (shell . t)
                               (python . t)
                               (ruby . t))
   ))

(use-package evil-org
  :after org
  :hook ((org-mode . evil-org-mode)))


(setq org-publish-project-alist
      '(("memex"
         :base-directory "~/org/mem/"
         :base-extension "org"
         :publishing-directory "/tmp/mem/"
         :publishing-function org-html-publish-to-html
         :html-doctype "html5"
         :html-head ""
         :html-head-extra ""
         :html-head-include-default-style nil
         :html-head-include-scripts nil
         :html-link-home ""
         :html-link-up ""
         :html-postamble nil
         :html-preamble nil
         :html-style nil
         :html-use-infojs nil
         :html-xml-declaration nil
         :section-numbers nil
         :with-creator nil
         :with-timestamps nil
         :with-title nil
         :with-toc nil)))

(use-package markdown-mode
  :defer t
  :mode ("README\\(?:\\.md\\)?\\'" . gfm-mode)
  :commands (markdown-mode gfm-mode)
  :init
  (setq markdown-command "multimarkdown"
        markdown-asymmetric-header t
        markdown-italic-underscore t
        markdown-fontify-code-blocks-natively t
        markdown-make-gfm-checkboxes-buttons t))

(use-package evil-markdown
  :straight (:type git :host github :repo "Somelauw/evil-markdown")
  :after markdown
  :hook ((markdown-mode . evil-markdown-mode)))

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

(use-package magit
  :init
  (setq magit-refresh-status-buffer nil
        magit-save-repository-buffers nil
        magit-revision-insert-related-refs nil
        magit-bury-buffer-function #'magit-mode-quit-window)
  :config
  ;; Clean up after magit by killing leftover magit buffers and reverting
  ;; affected buffers (or at least marking them as need-to-be-reverted).
  (define-key magit-mode-map "Q" #'+magit/quit-all)
  ;; Close transient with ESC
  (define-key transient-map [escape] #'transient-quit-one)
  ;; Jump on the other window
  (define-key magit-hunk-section-map (kbd "S-<return>") 'magit-diff-visit-file-other-window)

  ;; Add additional switches
  (transient-append-suffix 'magit-fetch "-p"
    '("-t" "Fetch all tags" ("-t" "--tags")))
  (transient-append-suffix 'magit-pull "-r"
    '("-a" "Autostash" "--autostash")))

(use-package git-gutter-fringe
  :after magit
  :init
  (setq indicate-buffer-boundaries nil
        indicate-empty-lines nil)
  (setq git-gutter:disabled-modes '(fundamental-mode
                                    help-mode
                                    vterm-mode
                                    image-mode
                                    pdf-view-mode
                                    ))
  ;; Only enable the backends that are available, so it doesn't have to check
  ;; when opening each buffer
  (setq git-gutter:handled-backends
        (cons 'git (cl-remove-if-not
                    #'executable-find (list 'hg 'svn 'bzr)
                    :key #'symbol-name)))
  :config
  ;; Thin fringe bitmaps
  (define-fringe-bitmap 'git-gutter-fr:added
    [224] nil nil '(top repeated))
  (define-fringe-bitmap 'git-gutter-fr:modified
    [224] nil nil '(top repeated))
  (define-fringe-bitmap 'git-gutter-fr:deleted
    [128 192 224 240] nil nil 'bottom)

  ;; Enable only for specific modes
  (add-hook 'prog-mode-hook 'git-gutter-mode)
  (add-hook 'text-mode-hook 'git-gutter-mode)

  ;; Update git-gutter on focus (in case of using git externally)
  (add-hook 'focus-in-hook #'git-gutter:update-all-windows)
  ;; Update git-gutter when using magit commands
  (advice-add #'magit-stage-file   :after #'+vc-gutter-update-h)
  (advice-add #'magit-unstage-file :after #'+vc-gutter-update-h))

(use-package flycheck
  :defer 3
  :init
  ;; Don't recheck on idle too often
  (setq flycheck-idle-change-delay 2.5)
  ;; Display errors a little quicker
  (setq flycheck-display-errors-delay 0.5))

;; My custom python path
(setq my-python "~/Dev/py-env8/bin/python")

;; The package is "python" but the mode is "python-mode"
(use-feature python
  :defer t
  :mode ("\\.py\\'" . python-mode)
  :hook
  (python-mode . flycheck-mode)
  (python-mode . company-mode)
  (python-mode . yas-minor-mode)
  :init
  (setq python-indent 4)
  (setq python-indent-offset 4)
  (setq python-shell-interpreter "ipython"
        python-shell-interpreter-args "-i --colors=Linux --no-confirm-exit"))

(use-package elpy
  :after python
  :init
  (setq python-shell-interpreter "ipython"
        python-shell-interpreter-args "-i --colors=Linux --no-confirm-exit"
        elpy-formatter 'yapf
        elpy-rpc-python-command my-python
        elpy-rpc-virtualenv-path 'current
        python-indent-guess-indent-offset-verbose nil
        python-shell-prompt-detect-failure-warning nil)
  (advice-add 'python-mode :before 'elpy-enable)
  ;; (reformatter-define black :program "black")
  ;; (reformatter-define yapf :program "yapf"
  ;;  :args '("--style='{based_on_style: yapf, column_limit: 100}'"))
  :config
  (when (load "flycheck" t t)
    ;; Remove flymake and django mode from modules
    (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
    (setq elpy-modules (delq 'elpy-module-django elpy-modules))
    (add-hook 'elpy-mode-hook 'flycheck-mode)))


;; Emacs Language Server Protocol client
;; https://emacs-lsp.github.io/lsp-mode
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook
  (lsp-mode . lsp-enable-which-key-integration)
  :custom
  (lsp-diagnostics-provider :flycheck)
  (lsp-disabled-clients '((python-mode . pyls)))
  (lsp-enable-folding nil)
  (lsp-enable-text-document-color nil)
  (lsp-headerline-breadcrumb-enable t)
  (lsp-headerline-breadcrumb-segments '(project file symbols))
  (lsp-lens-enable nil)
  (lsp-ui-doc-enable nil)
  (lsp-ui-doc-show-with-cursor nil)
  :init
  (setq lsp-keymap-prefix "C-c l") ;; Or 'C-l', 's-l'
  :config
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.mypy_cache\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.pytest_cache\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\data\\'"))

;; (use-package lsp-ivy
;;   :after lsp-mode)

;; https://github.com/microsoft/pyright
(use-package lsp-pyright
  :hook
  (python-mode . (lambda ()
                   (require 'lsp-pyright)
                   (lsp-deferred))))

(use-package js2-mode
  :defer t
  :mode ("\\.js\\'" . js2-mode)
  :init
  (setq js2-basic-offset 2
        css-indent-offset 4
        js-indent-level 4
        javascript-indent-level 4
        typescript-indent-level 4)
  (setq js2-mode-assume-strict t
        js2-mode-show-strict-warnings nil
        js2-strict-missing-semi-warning nil
        js2-strict-trailing-comma-warning nil))

(use-package typescript-mode
  :defer t
  :mode ("\\.ts\\'" . typescript-mode)
  :init
  (setq javascript-indent-level 4
        typescript-indent-level 4)
  :hook (typescript-mode . lsp-deferred))

(use-package yaml-mode
  :defer t
  :mode ("\\.ya?ml\\'" . yaml-mode))

;; (use-package pug-mode
;;   :defer t
;;   :mode ("\\.pug\\'" . pug-mode))

(use-package lua-mode
  :defer t
  :mode ("\\.lua\\'" . lua-mode)
  :init
  (setq lua-indent-level 2))

;; I don't want ESC as a modifier
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package general
  :demand t
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
    "."  'counsel-projectile-find-file
    "SPC" 'counsel-file-jump
    ;;
    "b" '(:ignore t :wk "Buffer")
    "bB"  'ibuffer-other-window
    "bI"  'counsel-ibuffer
    "bM"  '((lambda () (switch-to-buffer "*Messages*")) :which-key "messages-buffer")
    "bS"  '((lambda () (switch-to-buffer "*scratch*"))  :which-key "scratch-buffer")
    "bb"  'counsel-switch-buffer
    "bk"  'kill-buffer
    "bn"  'next-buffer
    "bp"  'previous-buffer
    "br"  'revert-buffer
    "bx"  'kill-current-buffer
    ;;
    "c" '(:ignore t :wk "Comment")
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
    "fD"  'counsel-dired-jump
    "fd"  'counsel-dired
    "ff"  'counsel-find-file  ;; visit or create file
    "fg"  'counsel-git        ;; find file in the current Git repo
    "fr"  'counsel-recentf    ;; find a file in recentf list
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
    "n" '(:ignore t :wk "Narrow")
    "nf"  'narrow-to-defun
    "np"  'narrow-to-page
    "nr"  'narrow-to-region
    "nw"  'widen
    ;;
    "o" '(:ignore t :wk "O")
    "op"  'treemacs
    "ot"  'org-babel-tangle
    "oT"  'org-babel-tangle-file
    ;;
    "t" '(:ignore t :wk "T")
    "t."  'vterm
    "tF"  'toggle-frame-fullscreen
    "tn"  'centaur-tabs-forward
    "tp"  'centaur-tabs-backward
    "tr"  'counsel-evil-registers
    "tt"  'vterm-other-window
    "tu"  'undo-tree-visualize
    ;;
    "w" '(:ignore t :wk "Window")
    "wB"  'balance-windows-area
    "wT"  'tear-off-window
    "wb"  'balance-windows
    "wd"  'kill-buffer-and-window
    "wh"  'evil-window-left
    "wj"  'evil-window-down
    "wk"  'evil-window-up
    "wl"  'evil-window-right
    "wo"  'delete-other-windows
    "wp"  'evil-window-prev
    "ws"  'evil-window-split
    "wv"  'evil-window-vsplit
    "ww"  'evil-window-next
    "wx"  'evil-window-delete
    ;;
    "x" '(:ignore t :wk "Text")
    "jj"  'json-pretty-print
    "jo"  'json-pretty-print-ordered
    "xh"  'mark-whole-buffer
    "xr"  'reverse-region
    "xs"  'counsel-grep-or-swiper
    "xx"  'delete-duplicate-lines
    "xl"  'sort-lines))

;; (use-package treemacs
;;   :defer t
;;   :init
;;   (setq treemacs-follow-after-init t
;;         treemacs-follow-mode nil
;;         treemacs-sorting 'alphabetic-case-insensitive-asc
;;         treemacs-width 24) ;; Width of the treemacs window
;;   :config
;;   (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action)
;;   :bind
;;   (:map global-map
;;         ("C-x t 1"   . treemacs-delete-other-windows)
;;         ("C-x t t"   . treemacs)
;;         ("C-x t T"   . treemacs-display-current-project-exclusively)
;;         ("C-x t C-t" . treemacs-find-file)
;;         ("C-x t M-t" . treemacs-find-tag)))

;; (use-package treemacs-evil
;;   :after treemacs)

;; (use-package treemacs-icons-dired
;;   :after treemacs
;;   :config (treemacs-icons-dired-mode))

;; ;; Tree + Projects = Love
;; (use-package treemacs-projectile
;;   :after (treemacs projectile))

(use-package all-the-icons)

;; Top tabs
(use-package centaur-tabs
  :hook (after-init . centaur-tabs-mode)
  :init
  (setq centaur-tabs-height 26
        centaur-tabs-style "bar"
        centaur-tabs-set-bar 'over
        centaur-tabs-close-button "✕"
        centaur-tabs-modified-marker "•"
        centaur-tabs-gray-out-icons 'buffer
        centaur-tabs-set-modified-marker t)
  :config
  (centaur-tabs-headline-match)
  (defun centaur-tabs-buffer-groups ()
    "`centaur-tabs-buffer-groups' control buffers' group rules."
    (list
     (cond
      ((or (string-equal "*" (substring (buffer-name) 0 1))
           (memq major-mode '(help-mode
                              helpful-mode
                              info-mode
                              man-mode)))
       "Emacs")
      ((or
        (derived-mode-p 'dired-mode)
        (derived-mode-p 'image-mode))
       "Explore")
      ((or (derived-mode-p 'text-mode)
           (derived-mode-p 'prog-mode)
           (derived-mode-p 'org-mode)
           (memq major-mode '(org-src-mode
                              org-agenda-mode
                              org-beamer-mode
                              org-indent-mode
                              org-bullets-mode
                              org-cdlatex-mode)))
       "Editing")
      (t
       (centaur-tabs-get-group-name (current-buffer)))))
    ))

;; Bottom mode-line
(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :init
  (setq doom-modeline-height 24
        doom-modeline-irc nil
        doom-modeline-gnus nil
        doom-modeline-mu4e nil))

;; Dimm inactive buffers
(use-package dimmer
  :hook (after-init . dimmer-mode)
  :custom
  (dimmer-use-colorspace :rgb)
  (dimmer-adjustment-mode :both)
  :config
  (dimmer-configure-magit)
  (dimmer-configure-which-key))

;; From: https://www.emacswiki.org/emacs/SortWords
;;
(defun sort-words (reverse beg end)
  "Sort words in region alphabetically, in REVERSE if negative.
Prefixed with negative \\[universal-argument], sorts in reverse.
The variable `sort-fold-case' determines whether alphabetic case
affects the sort order."
  (interactive "*P\nr")
  (sort-regexp-fields reverse "\\w+" "\\&" beg end))

(defun sort-symbols (reverse beg end)
  "Sort symbols in region alphabetically, in REVERSE if negative."
  (interactive "*P\nr")
  (sort-regexp-fields reverse "\\(\\sw\\|\\s_\\)+" "\\&" beg end))

(defalias 'sw 'sort-words)
(defalias 'ss 'sort-symbols)

;; From: https://www.emacswiki.org/emacs/InsertingTodaysDate
;;
(defun date-now (arg)
  (interactive "P")
  (insert (if arg
              (format-time-string "%d.%m.%Y")
            (format-time-string "%Y-%m-%d"))))

(defun timestamp-now ()
  (interactive)
  (insert (format-time-string "%Y-%m-%d %H:%M:%S")))

(defalias 'dt 'date-now)
(defalias 'ts 'timestamp-now)

;; From: https://stackoverflow.com/questions/18812938/copy-full-file-path-into-copy-paste-clipboard
;;
(defun copy-file-name-as-kill (choice)
  "Copy the buffer file name to the kill-ring"
  (interactive "cCopy Buffer Name (F) Full, (D) Directory, (N) Name")
  (let ((new-kill-string)
        (name (if (eq major-mode 'dired-mode)
                  (dired-get-filename)
                (or (buffer-file-name) ""))))
    (cond ((eq choice ?f)
           (setq new-kill-string name))
          ((eq choice ?d)
           (setq new-kill-string (file-name-directory name)))
          ((eq choice ?n)
           (setq new-kill-string (file-name-nondirectory name)))
          (t (message "Quit")))
    (when new-kill-string
      (message "%s copied" new-kill-string)
      (kill-new new-kill-string))))

;; Ask y/n instead of yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;; All automatic custom config in a separate file
(setq custom-file (concat my-emacs-d "custom.el"))
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file 'noerror)

;; Performance improvements
;; GC runs less often, which should speed up some operations
(add-hook 'after-init-hook
          (lambda ()
            (setq gc-cons-threshold 33554432 ; 32MB
                  gc-cons-percentage 0.2)
            (garbage-collect)))

;; Display benchmark message at startup
(add-hook 'window-setup-hook
          (lambda ()
            (setq diff-init-time
                  (float-time (time-subtract (current-time) before-init-time)))
            (message "Emacs loaded %d packages in %s with %d garbage collections."
                     (- (length load-path) (length (get 'load-path 'initial-value)))
                     (format "%.2f seconds" diff-init-time)
                     gcs-done)))

;; THIS FILE IS TANGLED, DON'T EDIT
;;
;;; init.el ends here
