;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;; (setq doom-font (font-spec :family "Source Code Pro" :size 14 :weight 'bold)
(setq doom-font (font-spec :family "Operator Mono SSm Lig" :size 15 :weight 'book)
      ;; doom-variable-pitch-font (font-spec :family "Cascadia Code") ; inherits `doom-font''s :size
      ;; doom-big-font (font-spec :family "Cascadia Code" :size 19)
      )

(after! dirvi
  (dirvish-override-dired-mode)
  )
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!



;; ui
(add-hook 'window-setup-hook 'toggle-frame-maximized)


;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-tomorrow-day)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; The setting of auto completion.
(setq company-idle-delay 0.1)
(setq company-tooltip-idle-delay 0.1)
(setq completion-ignore-case t)
(setq which-key-idle-delay 0.5)
(setq tool-bar-mode -1)


(after! lsp-ui
  (setq lsp-ui-doc-max-height 20))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; (after! org
;;   (global-org-modern-mode))

(after! org
  ;; 关闭TODO的时候带着时间戳
  (setq org-log-done-with-time t)
  (setq org-log-done t)

  ;; 开启org-super-agent
  (setq org-super-agenda-mode t)
  (let ((org-super-agenda-groups
         '(;; Each group has an implicit boolean OR operator between its selectors.
           (:name "Today"  ; Optionally specify section name
            :time-grid t  ; Items that appear on the time grid
            :todo "TODAY")  ; Items that have this TODO keyword
           (:name "Important"
            ;; Single arguments given alone
            :tag "bills"
            :priority "A")
           ;; Set order of multiple groups at once
           (:order-multi (2 (:name "Shopping in town"
                             ;; Boolean AND group matches items that match all subgroups
                             :and (:tag "shopping" :tag "@town"))
                            (:name "Food-related"
                             ;; Multiple args given in list with implicit OR
                             :tag ("food" "dinner"))
                            (:name "Personal"
                             :habit t
                             :tag "personal")
                            (:name "Space-related (non-moon-or-planet-related)"
                             ;; Regexps match case-insensitively on the entire entry
                             :and (:regexp ("space" "NASA")
                                   ;; Boolean NOT also has implicit OR between selectors
                                   :not (:regexp "moon" :tag "planet")))))
           ;; Groups supply their own section names when none are given
           (:todo "WAITING" :order 8)  ; Set order of this section
           (:todo ("SOMEDAY" "TO-READ" "CHECK" "TO-WATCH" "WATCHING")
            ;; Show this group at the end of the agenda (since it has the
            ;; highest number). If you specified this group last, items
            ;; with these todo keywords that e.g. have priority A would be
            ;; displayed in that group instead, because items are grouped
            ;; out in the order the groups are listed.
            :order 9)
           (:priority<= "B"
            ;; Show this section after "Today" and "Important", because
            ;; their order is unspecified, defaulting to 0. Sections
            ;; are displayed lowest-number-first.
            :order 1)
           ;; After the last group, the agenda will display items that didn't
           ;; match any of these groups, with the default order position of 99
           )))
    (org-agenda nil "a"))

  )

(add-hook 'org-mode-hook #'valign-mode)


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;

;; remove all keybindings from insert-state keymap,it is VERY VERY important
(setcdr evil-insert-state-map nil)
;;;把emacs模式下的按键绑定到Insert模式下
(define-key evil-insert-state-map
            (read-kbd-macro evil-toggle-key) 'evil-emacs-state)
;; but [escape] should switch back to normal state
(define-key evil-insert-state-map [escape] 'evil-normal-state)
;;
;;
(after! dap-mode
  (require 'dap-codelldb)
  ;; (require 'dap-cpptools)
  (setq dap-auto-configure-features '(sessions locals controls tooltip))

  (dap-register-debug-template
   "LLDB::Run Rust"
   (list :type "lldb"
         :request "launch"
         :name "LLDB::Run"
         :miDebuggerPath "~/.cargo/bin/rust-lldb"
         :target nil
         :cwd "${workspaceFolder}"
         :program "${workspaceFolder}/target/debug/"
         :dap-compilation "cargo build"
         :dap-compilation-dir "${workspaceFolder}"
         ))
  )

;; Java Configuration
(after! lsp-java
  (setq lombok-library-path (concat doom-data-dir "lombok.jar"))
  (unless (file-exists-p lombok-library-path)
    (url-copy-file "https://projectlombok.org/downloads/lombok.jar" lombok-library-path))
  (setq lsp-java-vmargs '("-XX:+UseParallelGC" "-XX:GCTimeRatio=4" "-XX:AdaptiveSizePolicyWeight=90" "-Dsun.zip.disableMemoryMapping=true" "-Xmx2G" "-Xms100m"))
  (push (concat "-javaagent:" (expand-file-name lombok-library-path)) lsp-java-vmargs))

;; (after! rustic
;;   (setq rustic-lsp-client 'eglot))

(add-hook 'vue-mode-hook #'lsp!)


(after! ellama
  (setopt ellama-keymap-prefix "C-c e")
  ;; (setopt ellama-language "Chinese")
  (require 'llm-ollama)
  (setopt ellama-provider
          (make-llm-ollama
           ;; this model should be pulled to use it
           ;; value should be the same as you print in terminal during pull
           :chat-model "gpt-4-turbo-preview"
           :embedding-model "gpt-4-turbo-preview"))
  )




;; (map! :leader
;;       (:prefix g))

;; we recommend using use-package to organize your init.el
;; (use-package company
;;   :defer 0.1
;;   :config
;;   (global-company-mode t)
;;   (setq-default
;;    company-idle-delay 0.05
;;    company-require-match nil
;;    company-minimum-prefix-length 0

;;    ;; get only preview
;;    company-frontends '(company-preview-frontend)
;;    ;; also get a drop down
;;    ;; company-frontends '(company-pseudo-tooltip-frontend company-preview-frontend)
;;    ))

