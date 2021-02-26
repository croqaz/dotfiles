;;; init.el

;;; Code:

;; Set font size
(set-face-attribute 'default nil :font "Hack-12")
(set-frame-font "Hack-12" nil t)

(defun --set-emoji-font (frame)
  "Adjust the font settings of FRAME so Emacs can display emoji properly."
  (set-fontset-font t 'symbol (font-spec :family "Noto Color Emoji") frame 'prepend))

;; When Emacs is started in GUI mode:
(--set-emoji-font nil)
;; Hook for when a frame is created with emacsclient
;; see https://www.gnu.org/software/emacs/manual/html_node/elisp/Creating-Frames.html
(add-hook 'after-make-frame-functions '--set-emoji-font)

;; Disable tool bar and scroll bar
(when (featurep 'tool-bar) (tool-bar-mode 0))
(when (featurep 'scroll-bar) (scroll-bar-mode 0))
;; Some internal padding
(fringe-mode 8)

;; Show column number
(column-number-mode)
;; Highlight the current line
(global-hl-line-mode +1)

;; Enable recent files
(require 'recentf)
(setq recentf-max-menu-items 15)
(setq recentf-max-saved-items 25)
(recentf-mode 1)

(require 'dired )
(define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file) ; was dired-advertised-find-file
(define-key dired-mode-map (kbd "^") (lambda () (interactive) (find-alternate-file ".."))) ; was dired-up-directory

;; Set up the visible bell
(setq visible-bell t)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
;; Org-mode useful keys
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

(defun smart-open-line-above ()
  "Insert an empty line above the current line.
Position the cursor at its beginning, according to the current mode."
  (interactive)
  (move-beginning-of-line nil)
  (insert "\n")
  (forward-line -1)
  (indent-according-to-mode))

(defun smart-open-line (arg)
  "Insert an empty line after the current line.
Position the cursor at its beginning, according to the current mode.
With a prefix ARG open line above the current line."
  (interactive "P")
  (if arg
      (smart-open-line-above)
    (move-end-of-line nil)
    (newline-and-indent)))

(global-set-key (kbd "M-o") 'smart-open-line)
(global-set-key (kbd "M-O") 'smart-open-line-above)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("elpa" . "https://elpa.gnu.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")))

;; Packages
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

(defun cro/org-font-setup ()
  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.0)
                  (org-level-6 . 1.0)
                  (org-level-7 . 1.0)
                  (org-level-8 . 1.0)))))

(defun cro/org-mode-setup ()
  (org-indent-mode)
  (visual-line-mode 1))

(use-package org
  :pin org
  :hook (org-mode . cro/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")
  (cro/org-font-setup))

(defun cro/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . cro/org-mode-visual-fill))


(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-gruvbox t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :after ivy
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("C-M-j" . 'counsel-switch-buffer)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (counsel-mode 1))

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package flycheck
  :ensure t
  :defer t
  :init (global-flycheck-mode))

(use-package markdown-mode
  :ensure t
  :defer t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package elpy
  :ensure t
  :defer t
  :init
  (advice-add 'python-mode :before 'elpy-enable))

;;; Footer:
(provide 'init)
;;; init.el ends here
(put 'dired-find-alternate-file 'disabled nil)
