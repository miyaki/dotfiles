;;; init.el

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

;; Packages to install from MELPA
(defvar my/packages
  '(
    ace-jump-mode
    anzu
    async
    auctex
    auctex-latexmk
    auto-async-byte-compile
    auto-install
    bind-key
    cider
    clang-format
    clmemo
    clojure-mode
    cmake-ide
    cmake-mode
    cmake-project
    coffee-mode
    company
    company-go
    company-irony
    company-irony-c-headers
    company-sourcekit
    dash
    dash-at-point
    diminish
    direx
    dockerfile-mode
    drag-stuff
    edit-server
    egg
    eldoc-extension
    elscreen
    elscreen-persist
    epl
    esup
    exec-path-from-shell
    expand-region
    f
    flycheck
    flycheck-clojure
    flycheck-google-cpplint
    flycheck-irony
    fringe-helper
    ghq
    git-dwim
    git-gutter
    github-browse-file
    glsl-mode
    go-autocomplete
    go-eldoc
    go-mode
    highlight-symbol
    hl-line+
    htmlize
    idle-highlight-mode
    irony
    js2-mode
    json-mode
    json-reformat
    json-snatcher
    key-intercept
    keyfreq
    langtool
    let-alist
;    magit
    markdown-mode
    migemo
    mkdown
    multiple-cursors
    nyan-mode
    open-junk-file
    org-tree-slide
    package-build
    pallet
    pkg-info
    popup
    popwin
    powerline
    prodigy
    projectile
    projectile-speedbar
    queue
    rainbow-delimiters
    s
    savekill
    scratch-log
    sequential-command
    shut-up
    slamhound
    smart-mode-line
    smart-mode-line-powerline-theme
    smart-newline
    smart-tabs-mode
    smartparens
    smex
    sr-speedbar
    tab-group
    tabbar
    term+
    term+key-intercept
    term+mux
    terraform-mode
    use-package
    wakatime-mode
    web-mode
    wgrep
    yaml-mode
    yasnippet
    zenburn-theme
    )
  "A list of packages to install from MELPA at launch.")

;; Install Melpa packages
(dolist (package my/packages)
  (when (or (not (package-installed-p package)))
    (package-install package)))

(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp"))

(unless (require 'use-package nil t)
  (message "use-package is unavailable!")
  (defmacro use-package (&rest _args)))

;; visual settings
(load-theme 'zenburn t)

(when (eq system-type 'darwin)
  (set-frame-font "ricty-12")
  )
(create-fontset-from-fontset-spec
 "-ipa-uigothic-medium-r-normal--12-*-*-*-*-*-fontset-ipaui")

;; kill splash screen
(setq inhibit-startup-screen t)

(fset 'yes-or-no-p 'y-or-n-p)

(setq frame-title-format
      (format "%%f - Emacs@%s" (system-name)))

(setq show-trailing-whitespace t)

(global-auto-revert-mode 1)

;;;;; (emacs) Optional Mode Line Features
(setq line-number-display-limit 10000000)
(setq line-number-display-limit-width 1000)

;;左に行数を表示
(require 'linum)
(global-linum-mode t)
(setq linum-delay t)
(setq linum-format "%5d")

;;行数と列数を下部に表示
(line-number-mode t)
(column-number-mode t)

;;保存時、最後に改行を追加
(setq require-final-newline t)

;; time.el
(setq display-time-day-and-date t)
(setq display-time-24hr-format t)
(setq display-time-string-forms
      '(24-hours ":" minutes))
(display-time)

;;;;; Line Height
(setq-default line-spacing 1)           ; 行間を2ピクセルあける
(setq-default tab-width 2)

;(setq compilation-window-height 20)
(setq compilation-scroll-output t)
(defun my-compile ()
  "Run compile and resize the compile window"
  (interactive)
  (progn
    (call-interactively 'compile)
    (setq cur (selected-window))
    (setq w (get-buffer-window "*compilation*"))
    (select-window w)
    (setq h (window-height w))
    (shrink-window (- h 20))
    (select-window cur)
    )
  )
(defun my-compilation-hook ()
  "Make sure that the compile window is splitting vertically"
  (progn
    (if (not (get-buffer-window "*compilation*"))
        (progn
          (split-window-vertically)
          )
      )
    )
  )
(add-hook 'compilation-mode-hook 'my-compilation-hook)


(setq visible-bell t)

;(menu-bar-mode 1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq make-backup-files nil)
(setq delete-auto-save-files t)

(desktop-save-mode 1)

;; line coding

(set-language-environment 'Japanese)
(prefer-coding-system 'utf-8)
(setq default-input-method "MacOSX")
(when (functionp 'mac-auto-ascii-mode)
  (mac-auto-ascii-mode 1))

;; keybinding

(bind-key* "C-h" 'backward-delete-char)
(bind-key* "H-p" 'projectile-compile-project)
(bind-key* "M-p" 'my-compile)
(bind-key "C-+" 'text-scale-increase)
(bind-key "C--" 'text-scale-decrease)
(bind-key "H-/" 'comment-or-uncomment-region)

; Mac like keybinding
(bind-key "H-a" 'mark-whole-buffer)
(bind-key "H-v" 'yank)
(bind-key "H-c" 'kill-ring-save)
(bind-key "H-s" 'save-buffer)
(bind-key "H-l" 'goto-line)
(bind-key "H-w"
          (lambda () (interactive) (kill-buffer)))
(bind-key "H-z" 'undo)

;; switch meta key for mac
(setq mac-option-modifier 'meta)
(setq mac-command-modifier 'hyper)

(if (eq system-type 'gnu/linux)
    (setq x-super-keysym 'hyper))

(setq compile-command "make -k -j4")

;; package specific settings

(use-package ace-jump-mode
  :bind ("C-." . ace-jump-mode))

(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

(use-package anzu
  :diminish anzu-mode
  :init (global-anzu-mode 1))

(use-package auctex
  :ensure t
  :mode ("\\.tex\\'" . latex-mode)
  :commands (latex-mode LaTeX-mode plain-tex-mode)
  :init
  (progn
    (add-hook 'LaTeX-mode-hook (lambda () (setq compile-command "latexmk -pdf")))
    )
  )

(use-package cc-mode
  :mode (("\\.h\\'" . c++-mode)
         ("\\.pde\\'" . c-mode)
         ("\\.ino\\'" . c-mode))
  :config
  (progn
    (setq-default c-default-style '((java-mode . "java")
                                    (awk-mode . "awk")
                                    (other . "linux"))
                  c-basic-offset 4)
    (with-eval-after-load 'smartparens
      (sp-local-pair '(c-mode c++-mode) "{" nil
                     :post-handlers '((my-create-newline-and-enter-sexp "RET"))))
    (defun my-create-newline-and-enter-sexp (&rest _ignored)
      "Open a new brace or bracket expression, with relevant newlines and indent."
      (newline)
      (indent-according-to-mode)
      (forward-line -1)
      (indent-according-to-mode))
		(add-hook 'c-mode-common-hook 'flycheck-mode)
		(add-hook 'c-mode-common-hook
              (lambda ()
                ;; Delete all whitespace until next non-whitespace.
                (c-toggle-hungry-state 1)
                ;; Do not indent open curly in in-class inline method.
                (c-set-offset 'inline-open 0)))
    (add-hook 'c-mode-hook
              '(lambda()
                 (c-set-style "stroustrup")
                 (c-set-offset 'innamespace 0)
                 (setq c-auto-newline t)
                 (setq c-toggle-hungry-state 1)
                 (setq c-basic-offset 2)
                 (setq tab-width 2)
                 (define-key c-mode-map "\M-t" 'ff-find-other-file)
                 ))
		(add-hook 'c++-mode-hook 'irony-mode)
    (add-hook 'c++-mode-hook
              '(lambda()
               ;(c-set-style "stroustrup")
                 (c-set-style "linux")
                 (c-set-offset 'innamespace 0)
                 (c-set-offset 'inline-open 0)
                 (setq c-auto-newline t)
                 (setq c-toggle-hungry-state 1)
                 (setq c-basic-offset 2)
                 (setq indent-tabs-mode nil)
                 (setq tab-width 2)
                 (define-key c++-mode-map "\M-t" 'ff-find-other-file)
                 (define-key c++-mode-map "\C-i" 'indent-region)
                 (add-hook 'before-save-hook 'delete-trailing-whitespace)
                 ))
    (add-hook 'objc-mode-hook
              '(lambda()
                 (c-set-offset 'innamespace 0)
                 (c-set-offset 'inline-open 0)
                 (c-set-offset 'substatement-open 0)
                 (setq c-auto-newline t)
                 (setq c-basic-offset 2)
                 (setq tab-width 2)
                 (define-key objc-mode-map "\M-t" 'ff-find-other-file)
                 ))
    (add-hook 'java-mode-hook
              '(lambda()
                 (setq c-auto-newline t)
                 (setq c-basic-offset 2)
                 ))
    (add-hook 'csharp-mode-hook
              '(lambda()
                 (setq c-auto-newline t)
                 ))
    ))

(use-package company
  :ensure t
  :defer t
  :init (global-company-mode))

(use-package clojure-mode
  :defer t
  :init
  (progn
    (add-hook 'clojure-mode-hook 'cider-mode)
    (add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
    (add-hook 'cider-repl-mode-hook #'company-mode)
    (add-hook 'cider-mode-hook #'company-mode)
    (setq nrepl-hide-special-buffers t)
;    (setq nrepl-buffer-name-show-port t)
    ))

(use-package cmake-ide
  :bind
  (("<f9>" . cmake-ide-compile))
  :config
  (progn
    (setq
     ; rdm & rcコマンドへのパス。コマンドはRTagsのインストール・ディレクトリ下。
     cmake-ide-rdm-executable "/usr/local/bin/rdm"
     cmake-ide-rc-executable  "/usr/local/bin/rc"
     )
    )
  )

(use-package dash-at-point
  :if (eq system-type 'darwin)
  :bind ("C-c d" . dash-at-point))

(use-package direx
  :bind
  ("C-x C-j" . direx:jump-to-directory))

(use-package dmacro
  :bind
  ("C-t" . dmacro-exec)
  :init
  (defconst *dmacro-key* "\C-t" "繰返し指定キー"))

(use-package edit-server
  :if window-system
  :init
  (progn
    (add-hook 'after-init-hook 'server-start t)
    (add-hook 'after-init-hook 'edit-server-start t)))

(use-package exec-path-from-shell
  :init
  (let ((envs '("PATH" "GOPATH")))
    (exec-path-from-shell-copy-envs envs)))

(use-package ess
  :defer t
  :init
  (progn
    (autoload 'R-mode "ess-site"
      "Major mode for editing R source.  See `ess-mode' for more help." t)))

(use-package esup)

(require 'find-file "find-file")
(setq cc-other-file-alist
     (append (list
              '("\\.h\\'" (".c" ".cc" ".C" ".CC" ".cxx" ".cpp" ".m" ".mm"))
              '("\\.m\\'" (".h"))
              '("\\.mm\\'" (".h")))
             cc-other-file-alist))

(use-package flycheck
  :init
  (add-hook 'after-init-hook #'global-flycheck-mode)
  :config
  (progn
    (add-hook 'flycheck-mode-hook #'flycheck-irony-setup)
    (custom-set-variables
     '(flycheck-display-errors-function #'flycheck-pos-tip-error-messages))))

(use-package irony
  :config
  (progn
    ; ironyのビルド&インストール時にCMAKE_INSTALL_PREFIXで指定したディレクトリへのパス。
    ;(setq irony-server-install-prefix "where_to_install_irony")
    ;(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)
    ;(add-hook 'irony-mode-hook 'my-irony-mode-hook)
    ;(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
    ;(add-hook 'irony-mode-hook 'irony-eldoc)
    ;(add-to-list 'company-backends 'company-irony)
    )
  )

(use-package jaspace
  :init
  (progn
    (setq jaspace-alternate-jaspace-string "□")
    (setq jaspace-alternate-eol-string "↓\n")
    (setq jaspace-highlight-tabs t)
    ))

(use-package julia-mode
  :defer t
  :commands julia-mode
  :mode ("\\.jl$" . julia-mode)
  :init
  (progn
    (autoload 'julia-mode "julia-mode" nil t)
    )
  :config
  (progn
    (setq inferior-julia-program-name "/usr/local/bin/julia")
    )
  )

;; Markdown Mode
(use-package markdown-mode
  :mode ("\\.md\\'" . gfm-mode))

;; pallet
(use-package pallet
  :ensure t
  :init
  (progn
    (pallet-mode t)))

(use-package rtags
  :config
  (progn
    (rtags-enable-standard-keybindings c-mode-base-map)
    ; 関数cmake-ide-setupを呼ぶのはrtagsをrequireしてから。
    (cmake-ide-setup)
    )
  )

(use-package smart-mode-line
  :init
  (progn
    (sml/setup)
    (sml/apply-theme 'automatic)
    ))

;; smart-newline
(use-package smart-newline
  :config
  (progn
    (bind-key "C-m" 'smart-newline)))

(use-package smart-tabs-mode
  :init
  (progn
    (setq-default indent-tabs-mode nil)
;    (smart-tabs-insinuate 'c 'c++ 'java 'javascript 'python 'ruby)
    ))

(use-package smartparens
  :ensure t
  :init
  (progn
    (require 'smartparens-config)
    (smartparens-global-mode t)
    (show-smartparens-global-mode t)))

(use-package tabbar
  :ensure t
  :init
  (tabbar-mode t))

;; term+
(use-package term+
  :defer t
  :config
  (progn
    (use-package term+key-intercept)
    (use-package term+mux)
    (require 'xterm-256color)))

(use-package git-gutter
  :ensure t
  :init
  (progn
    (global-git-gutter-mode t)
    (git-gutter:linum-setup)
    (bind-key "C-x C-g" 'git-gutter:toggle)
    (bind-key "C-x v =" 'git-gutter:popup-hunk)
    (bind-key "C-x p"   'git-gutter:previous-hunk)
    (bind-key "C-x n"   'git-gutter:next-hunk)
    (bind-key "C-x v s" 'git-gutter:stage-hunk)
    (bind-key "C-x v r" 'git-gutter:revert-hunk)
   ))


(use-package go-mode
  :ensure t
  :mode "\\.go\\'"
  :commands (go-mode godoc gofmt gofmt-before-save)
  :config
  (progn
    (use-package company-go)
    (add-hook 'before-save-hook 'gofmt-before-save)
    (add-hook 'go-mode-hook 'go-eldoc-setup)
    (add-hook 'go-mode-hook (lambda ()
                              (set (make-local-variable 'company-backends) '(company-go))
                              (company-mode)))
    ))

(setq langtool-language-tool-jar "/usr/local/Cellar/languagetool/2.8/libexec/languagetool-commandline.jar")
(setq langtool-mother-tongue "en")
(use-package langtool
  :ensure t
  :commands langtool-check
  :init
  (progn
    ))


(use-package powerline
  :init
  (progn
    (powerline-default-theme)
    (setq powerline-arrow-shape 'curve)
    (setq powerline-default-separator-dir '(right . left))
    ))

(use-package projectile
  :ensure t
  :diminish projectile-mode
  :config
  (projectile-global-mode t)
  :init
  (progn
    (require 'projectile-speedbar)
    (setq projectile-completion-system 'default)
    (setq projectile-enable-caching t)))

(use-package sr-speedbar
  :bind
  ("H-." . sr-speedbar-toggle)
  :init
  (progn
    (setq speedbar-frame-parameters
          '((minibuffer)
            (width . 30)
            (border-width . 0)
            (menu-bar-lines . 0)
            (tool-bar-lines . 0)
            (unsplittable . t)
            (left-fringe . 0)
            (right-fringe)
            (fringe)))
    (setq speedbar-hide-button-brackets-flag t)
    (setq speedbar-show-unknown-files t)
    (setq speedbar-smart-directory-expand-flag t)
    (setq speedbar-use-images nil)
    (setq sr-speedbar-max-width 30)
    (setq sr-speedbar-right-side nil)
    (setq sr-speedbar-width-console 30)
    (add-hook 'speedbar-mode-hook (lambda ()
                                 (linum-mode -1)
                                 ))
    ))

(when (require 'wakatime-mode nil t)
  (global-wakatime-mode)
  )

(use-package yasnippet
  :diminish yas-minor-mode
  :config
  (yas-reload-all))

(provide 'init)
