;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Basic UI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; User Interface
(setq inhibit-startup-message t)

(scroll-bar-mode -1) ; Disable visible scrollbar
(tool-bar-mode -1)   ; Disable the toolbar
;; (tooltip-mode -1)    ; Disable tooltips
(set-fringe-mode 10) ; Give some breathing room
(menu-bar-mode -1)   ; Disable the menubar

(set-face-attribute 'default nil :font "Fira Code")
(set-face-attribute 'default nil :height 120)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Behavior
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Store custom-file separately, don't freak out when it's not found
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs.d/autosaves/" t)

;; Backup behavior
;; Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs.d/.
(custom-set-variables
 '(auto-save-file-name-transforms '((".*" "~/.emacs.d/autosaves/\\1" t)))
 '(backup-directory-alist '((".*" . "~/.emacs.d/backups/"))))

;; start week from Monday
(setq calendar-week-start-day 1)

;; set timestamps to English
(setq system-time-locale "C")

;; Map Cmd to be Meta
(setq mac-command-modifier 'meta)

(setq-default word-wrap t) ; Enable word wrap

(defun linum () (display-line-numbers-mode 1))
(add-hook 'prog-mode-hook 'linum)

;;(column-number-mode)
(delete-selection-mode 1)
(global-superword-mode 1)

;; Always wrap lines
(global-visual-line-mode 1)

;; Highlight the current line
(global-hl-line-mode 1)

;; auto revert
(global-auto-revert-mode 1)

;; Never use tabs, use spaces instead.
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq tab-width 4)

;; Delete trailing spaces and add new line in the end of a file on save.
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq require-final-newline t)

;; C-x, C-c, C-v for cut, copy, paste
(cua-mode t)

(setq apropos-sort-by-scores t) ; Sort apropos results by relevancy

(fset 'yes-or-no-p 'y-or-n-p)      ; y and n instead of yes and no everywhere else

;; Comment line or region.
(global-set-key (kbd "C-/") 'comment-line)

(global-set-key (kbd "C-x C-h") 'previous-buffer)
(global-set-key (kbd "C-x C-l") 'next-buffer)

(global-set-key (kbd "C-{") 'shrink-window-horizontally)
(global-set-key (kbd "C-}") 'enlarge-window-horizontally)

(global-unset-key (kbd "C-<down-mouse-1>"))
(global-unset-key (kbd "<down-mouse-8>"))
(global-unset-key (kbd "<down-mouse-9>"))

(global-unset-key (kbd "M-<down-mouse-1>"))

(defun display-ansi-colors ()
  (interactive)
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region (point-min) (point-max))))

(global-set-key (kbd "C-x 2") (lambda ()
                                (interactive)
                                (split-window-below)
                                (other-window 1)))

(global-set-key (kbd "C-x 3") (lambda ()
                                (interactive)
                                (split-window-right)
                                (other-window 1)))

(global-set-key (kbd "<f2>") 'window-configuration-to-register)
(global-set-key (kbd "M-<f2>") 'jump-to-register)

(global-set-key
 (kbd "M-\\")
 (lambda () (interactive) (find-file "~/.emacs.d/init.el")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

;;(unless package-archive-contents
;;(package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Try package without installation
(use-package try)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General purpose packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Emacs bindings with the russian keyboard
(use-package reverse-im
  :config
  (reverse-im-activate "russian-computer"))

;; enable Mac OS X path
(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

;; We need Emacs kill ring and system clipboard to be independent. Simpleclip is the solution to that.
;; (use-package simpleclip
;;   :config
;;   (simpleclip-mode 1))

;; Linear undo and redo.
(use-package undo-fu
  :bind
  (("C-z" . undo-fu-only-undo)
   ("C-S-z" . undo-fu-only-redo)))

(use-package smex)  ;; show recent commands when invoking Alt-x (or Cmd+Shift+p)

;; Multiple cursors. Similar to Sublime or VS Code.
(use-package multiple-cursors
  :bind
  (("M-3" . mc/mark-next-like-this)
   ("M-4" . mc/edit-beginnings-of-lines))
  :config
  (setq mc/always-run-for-all 1)
  (define-key mc/keymap (kbd "<return>") nil))

(use-package move-text
  :config
  (move-text-default-bindings))

;; Upcase and lowercase word or region, if selected.
;; To capitalize or un-capitalize word use Alt+c and Alt+l
(global-set-key (kbd "M-u") 'upcase-dwim)   ;; Alt+u upcase
(global-set-key (kbd "M-l") 'downcase-dwim) ;; Alt-l lowercase

(use-package hydra)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Help
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Interactive help with key bindings
(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.5))

;; Better help
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UI packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; UI theme
(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;; (load-theme 'doom-outrun-electric t)
  (load-theme 'doom-nord t)
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;; NOTE: The first time you load your configuration on a new machine, you'll
;; need to run the following command interactively so that mode line icons
;; display correctly:
;;
;; M-x all-the-icons-install-fonts

(use-package all-the-icons)

;; Beautiful bottom line
(use-package doom-modeline
  :init (doom-modeline-mode 1))

;; Colorful brackets
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; replace switch-window mechanism
(use-package ace-window
  :bind
  (("C-x O" . other-frame)
   ([remap other-window] . 'ace-window))
  :init
  (progn
    (setq aw-scope 'global) ;; was frame
    (custom-set-faces
     '(aw-leading-char-face
       ((t (:inherit ace-jump-face-foreground :height 3.0)))))
    ))

;; File tree
(use-package neotree
  :config
  (setq neo-window-width 32
        neo-create-file-auto-open t
        neo-banner-message nil
        neo-show-updir-line t
        neo-window-fixed-size nil
        neo-vc-integration nil
        neo-mode-line-type 'neotree
        neo-smart-open t
        neo-show-hidden-files t
        neo-mode-line-type 'none
        neo-auto-indent-point t)
  (setq neo-theme (if (display-graphic-p) 'nerd 'arrow))
  (setq neo-hidden-regexp-list '("venv" "\\.pyc$" "~$" "\\.git" "__pycache__" ".DS_Store"))
  (global-set-key (kbd "s-B") 'neotree-toggle))           ;; Cmd+Shift+b toggle tree

(winner-mode 1) ;; Window configurations

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Completion and search
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Completion mechanism
(use-package ivy
  :diminish ivy-mode
  :bind (("C-s" . swiper)
         ("C-x b" . ivy-switch-buffer))
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-display-style 'fancy)
  (setq ivy-magic-slash-non-match-action nil))

;; Additional help
(use-package ivy-rich
  :after ivy
  :config
  (ivy-rich-mode 1)
  (setq ivy-rich-path-style 'abbrev))

;; (use-package ivy-posframe
;;   :ensure t
;;   :delight
;;   :custom
;;   (ivy-posframe-parameters
;;    '((left-fringe . 2)
;;      (right-fringe . 2)
;;      (internal-border-width . 2)))
;;   (ivy-posframe-height-alist
;;    '((swiper . 15)
;;      (swiper-isearch . 15)
;;      (t . 10)))
;;   (ivy-posframe-display-functions-alist
;;    '((complete-symbol . ivy-posframe-display-at-point)
;;      (swiper . nil)
;;      (swiper-isearch . nil)
;;      (t . ivy-posframe-display-at-frame-center)))
;;   :config
;;   (ivy-posframe-mode 1))

;; Part of ivy?
(use-package counsel
  :bind (("M-x" . counsel-M-x))
  :config
  (counsel-mode 1))

(use-package flx)   ;; enable fuzzy matching

;; enable avy for quick navigation
(use-package avy
  :bind (("C-o" . avy-goto-char)))

;; better grep
(use-package ripgrep)

(use-package fzf
  :bind
  ;; Don't forget to set keybinds!
  :config
  (setq
   fzf/args "-x --color bw --print-query --margin=1,0 --no-hscroll"
   fzf/executable "fzf"
   fzf/git-grep-args "-i --line-number %s"
   ;; command used for `fzf-grep-*` functions
   ;; example usage for ripgrep:
   ;; fzf/grep-command "rg --no-heading -nH"
   fzf/grep-command "grep -nrH"
   ;; If nil, the fzf buffer will appear at the top of the window
   fzf/position-bottom t
   fzf/window-height 15))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Project management
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun mart/rg-project (pattern args)
  (interactive "sPattern: \nsArguments: ")
  (ripgrep-regexp pattern (projectile-project-root) (list args)))

(defun mart/rg-only-sources (pattern)
  (interactive "sPattern: ")
  (mart/rg-project pattern  "-th -tc -tcpp"))

(defun mart/rg-no-test-and-mock (pattern)
  (interactive "sPattern: ")
  (mart/rg-project pattern "-th -tc -tcpp -g '!*test*' -g '!*mock*'"))

(defun mart/projectile-compile-and-scroll (arg)
  (interactive "P")
  (projectile-compile-project arg)
  (switch-to-buffer "*compilation*")
  (end-of-buffer))

(defun mart/projectile-install-and-scroll (arg)
  (interactive "P")
  (projectile-install-project arg)
  (switch-to-buffer "*compilation*")
  (end-of-buffer))

;; Project management
(use-package projectile
  :diminish projectile-mode
  :config
  (add-to-list 'projectile-project-root-files "Project.meta")
  :custom
    ((projectile-completion-system 'ivy)
     (projectile-globally-ignored-directories ".cache"))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :bind
  (("C-S-f" . mart/rg-no-test-and-mock)
   :map projectile-command-map
   ("c" . mart/projectile-compile-and-scroll)
   ("L" . mart/projectile-install-and-scroll))
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  ;; (when (file-directory-p "~/Projects")
  ;; (setq projectile-project-search-path '("~/Projects")))
  (setq projectile-switch-project-action 'projectile-dired))

(use-package counsel-projectile
  :bind
  (("M-o" . counsel-projectile-find-file))
  :config (counsel-projectile-mode))

(use-package dashboard
  :config
  (setq dashboard-items '((projects . 5)
                          (recents  . 5)))
  (dashboard-setup-startup-hook))

(use-package tramp
  :custom
  ;; (tramp-auto-save-directory "~/.emacs.d/tramp-autosave")
  (tramp-use-scp-direct-remote-copying t)
  (tramp-histfile-override t)           ; sets both HISTFILESIZE
                                        ; and HISTSIZE to 0
  (tramp-verbose 1)                     ; errors only (no warnings)
  (remote-file-name-inhibit-locks t)    ; different emacs sessions are not
                                        ; modifying the same remote file
  (remote-file-name-inhibit-cache nil)  ; remote files are not modified
                                        ; outside of emacs
)

;; Speed up TRAMP
(setq projectile-mode-line "Projectile")
(setq vc-ignore-dir-regexp
      (format "%s\\|%s"
                    vc-ignore-dir-regexp
                    tramp-file-name-regexp))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Git
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package transient)

(transient-define-suffix magit-push-to-gerrit ()
  "Push to Gerrit"
  :description "to gerrit"
  (interactive)
  (magit-push-refspecs "origin" (format "HEAD:refs/for/%s" (magit-main-branch)) nil))

(transient-define-suffix magit-pull-from-main ()
  "Pull from master"
  :description "main"
  (interactive)
  (magit-pull-branch (format "origin/%s" (magit-main-branch)) (magit-pull-arguments)))

(use-package magit
  :config
  (transient-append-suffix 'magit-push "t"
    '("g" magit-push-to-gerrit))
  (transient-append-suffix 'magit-pull "e"
    '("M" magit-pull-from-main)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Development
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'major-mode-remap-alist
             '(python-mode . python-ts-mode))

(use-package lsp-mode
  :hook
  (c++-mode . lsp-deferred)
  (c-mode . lsp-deferred)
  (python-ts-mode . lsp-deferred)
  (rust-ts-mode . lsp-deferred)
  :config
  (add-to-list 'lsp-language-id-configuration '(rust-ts-mode . "rust"))
  (lsp-register-client (make-lsp-client
                        :new-connection (lsp-stdio-connection "rust-analyzer")
                        :activation-fn (lsp-activate-on "rust")
                        :server-id 'rust-analyzer))
  (setq lsp-disabled-clients '(ruff))
  )

(use-package company
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1)
  (global-company-mode t))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package yasnippet
  :config
  (yas-global-mode 1)
  (add-to-list 'company-backends 'company-yasnippet))

(use-package yasnippet-snippets)

(use-package bazel)

(use-package rustic)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Python
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; requires python packages python-lsp-server and debugpy

;; (use-package python-mode
;;   :hook
;;   (python-mode . lsp-deferred)
;;   :custom
;;   ((python-shell-interpreter "python3")
;;   (lsp-pylsp-plugins-pydocstyle-enabled nil)
;;   (dap-python-executable "python3")
;;   (dap-python-debugger 'debugpy))
;;   :config
;;   (require 'dap-python))

(use-package auto-virtualenv
  :init
  (use-package pyvenv
    :config
    (setenv "WORKON_HOME" "/home/vlad/Documents/Dev/Languages/Python")
    (setq pyvenv-mode-line-indicator '(pyvenv-virtual-env-name ("[venv:" pyvenv-virtual-env-name "] "))))
  :config
  (add-hook 'python-mode-hook 'auto-virtualenv-set-virtualenv)
  (add-hook 'projectile-after-switch-project-hook 'auto-virtualenv-set-virtualenv)  ;; If using projectile
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C++
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; formatting
(use-package clang-format+
  :bind (("M-n" . clang-format-region)))

;; for pure C projects remove in .dir_locals
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(c-set-offset 'innamespace '0)
(c-set-offset 'substatement-open '0)
;; (electric-pair-mode)

(load-file "~/.emacs.d/esr.el")

(defun mart/c++-mode-hook ()
  "Custom key bindings for C++ mode."
  (define-key c++-mode-map (kbd "<f5>") 'bake-gdb-current-tests)
  (define-key c++-mode-map (kbd "C-<f5>") 'bake-run-current-tests)
  )

(add-hook 'c++-mode-hook 'mart/c++-mode-hook)

;; (define-key c-mode-map (kbd "<f5>") 'bake-gdb-current-tests)

;; (define-key c-mode-map (kbd "C-<f5>") 'bake-run-current-tests)

;; (define-key c-mode-map (kbd "M-]") 'bake-mock-current)
;; (define-key c++-mode-map (kbd "M-]") 'bake-mock-current)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ruby
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; requires gem install solargraph
(add-hook 'ruby-mode-hook 'lsp-deferred)

(setenv "GEM_HOME" (format "%s/.local/gem" (getenv "HOME")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Debugging
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(make-variable-buffer-local
 (defvar mart-dbg-mode nil
   "Toggle mart-dbg-mode."))

(defvar mart-dbg-mode-map (make-sparse-keymap)
  "The keymap for mart-dbg-mode")

;; Define a key in the keymap
(define-key mart-dbg-mode-map (kbd "<f5>") 'gud-cont)
(define-key mart-dbg-mode-map (kbd "S-<f5>") 'stop-debugging)
(define-key mart-dbg-mode-map (kbd "M-<f5>") 'gdb-pause)
(define-key mart-dbg-mode-map (kbd "<f6>") 'gud-next)
(define-key mart-dbg-mode-map (kbd "S-<f6>") 'gud-until)
(define-key mart-dbg-mode-map (kbd "<f7>") 'gud-step)
(define-key mart-dbg-mode-map (kbd "<f8>") 'gud-break)


(add-to-list 'minor-mode-alist '(mart-dbg-mode " mart"))
(add-to-list 'minor-mode-map-alist (cons 'mart-dbg-mode mart-dbg-mode-map))

(defun mart-dbg-mode (&optional ARG)
  (interactive (list 'toggle))
  (setq mart-dbg-mode
        (if (eq ARG 'toggle)
            (not mart-dbg-mode)
          (> ARG 0)))

  (if mart-dbg-mode
      (message "mart-dbg-mode activated!")
    (message "mart-dbg-mode deactivated!")))

;; Uncomment when mode enabling works fine
;; (add-hook 'gud-mode-hook 'mart-dbg-mode)

(defvar openocd-process nil
  "OpenOCD process identificator")

(defun openocd-start (config)
  "Start OpenOCD with a CONFIG"
  (interactive)
  (setq openocd-process (start-process "OpenOCD" "*openocd*" "openocd" "-f" (format "%s.cfg" config))))

(defun openocd-kill ()
  (interactive)
  (when openocd-process
    (kill-process openocd-process)
    (kill-buffer "*openocd*")
    (setq openocd-process nil)))

(defun gdb-pause ()
  "Pause the current execution"
  (interactive)
  (let ((proc (get-buffer-process gud-comint-buffer)))
    (when (process-live-p proc)
      (interrupt-process proc)
      (message "The execution has been interrupted"))))

(defun gdb-kill ()
  "Kill the GDB process."
  (interactive)
  (let ((proc (get-buffer-process gud-comint-buffer))
        (kill-buffer-query-functions nil))
    (when (process-live-p proc)
      (kill-process proc)
      (message "GDB process killed.")
      (kill-buffer gud-comint-buffer))))

(defun arm-gdb (executable)
  (interactive "sExecutable: ")
  (openocd-start "board/stm32f3discovery")
  (gdb (format "arm-none-eabi-gdb -i=mi -ex \"target remote :3333\" -ex \"monitor reset halt\" %s" executable)))

(defun stop-debugging ()
  (interactive)
  (gdb-kill)
  (openocd-kill)
  (message "Stopped debugging"))

(defun bazel-debug-at-point ()
  "Run the test case at point."
  (interactive)
  (let* ((source-file (or buffer-file-name
                          (user-error "Buffer doesn’t visit a file")))
         (root (or (bazel--workspace-root source-file)
                   (user-error "File is not in a Bazel workspace")))
         (directory (or (bazel--package-directory source-file root)
                        (user-error "File is not in a Bazel package")))
         (package (or (bazel--package-name directory root)
                      (user-error "File is not in a Bazel package")))
         (build-file (or (bazel--locate-build-file directory)
                         (user-error "No BUILD file found")))
         (relative-file (file-relative-name source-file directory))
         (case-fold-file (file-name-case-insensitive-p source-file))
         (rule (or (bazel--consuming-rule build-file relative-file
                                          case-fold-file :only-tests)
                   (user-error "No rule for file %s found" relative-file)))
         (test-executable (file-name-concat root "bazel-bin" package rule))
         (name
          (or (run-hook-with-args-until-success 'bazel-test-at-point-functions)
              (user-error "Point is not on a test case"))))
    (gdb (format "gdb -i=mi --cd=%s %s" root test-executable))))
;;  nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'org-habit)

;; Some basic Org defaults

(add-to-list 'org-modules 'org-habit t)
(setq org-habit-show-all-today t
      org-startup-indented t         ;; Visually indent sections. This looks better for smaller files.
      org-src-tab-acts-natively t    ;; Tab in source blocks should act like in major mode
      org-src-preserve-indentation t
      org-log-into-drawer t          ;; State changes for todos and also notes should go into a Logbook drawer
      org-src-fontify-natively t     ;; Code highlighting in code blocks
      org-support-shift-select t     ;; Allow shift selection with arrows
      org-startup-folded t           ;; Collapse all headlines
      org-directory "~/Documents/Notes"
      org-agenda-files '("~/Documents/Notes") ;; And all of those files should be in included agenda.
      org-todo-keywords '((sequence "TODO(1)" "IN-PROGRESS(2)" "WAITING(4)" "SOMEDAY(5)" "|" "DONE(3)" "CANCELED(6)"))
      )

(defun open-note (exact-file)
  (find-file (file-name-concat org-directory exact-file)))

(global-set-key
 (kbd "C-`")
 (defhydra notes-launcher (:color blue)
   "Open notes"
   ("d" (open-note "Diary.org") "Diary")
   ("в" (open-note "Diary.org") "Diary") ;; cyrillic
   ("n" (open-note "Notes.org") "Notes")
   ("т" (open-note "Notes.org") "Notes") ;; cyrillic
   ("c" (open-note "Tech.org") "Tech")
   ("с" (open-note "Tech.org") "Tech") ;; cyrillic
   ("t" (open-note "Todo.org") "Todo")
   ("е" (open-note "Todo.org") "Todo") ;; cyrillic
   ("s" (open-note "Stats.org") "Stats")
   ("ы" (open-note "Stats.org") "Stats") ;; cyrillic
   ("a" (org-agenda-list) "Agenda")
   ("ф" (org-agenda-list) "Agenda") ;; cyrillic
))

;; requires pandoc
(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "pandoc"))

(use-package yaml-mode)

(use-package plantuml-mode
  :config
  (setq plantuml-jar-path "/home/vlad/.local/bin/plantuml-1.2023.5.jar")
  (setq plantuml-default-exec-mode 'jar))
