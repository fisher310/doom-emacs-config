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
(setq doom-font (font-spec :family "CodeNewRoman Nerd Font Mono" :size 16 :weight 'Regular)
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
;; (setq doom-theme 'doom-tomorrow-day)
(setq doom-theme 'leuven)

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

(after! org
  ;; 关闭TODO的时候带着时间戳
  (setq org-log-done-with-time t)
  (setq org-log-done t)
  (add-hook 'org-mode-hook #'valign-mode)
  (global-org-modern-mode))



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
  (setq dap-auto-configure-mode t)

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

(map! :map dap-mode-map
      :leader
      :prefix ("d" . "dap")
      ;; basics
      :desc "dap next"          "n" #'dap-next
      :desc "dap step in"       "i" #'dap-step-in
      :desc "dap step out"      "o" #'dap-step-out
      :desc "dap continue"      "c" #'dap-continue
      :desc "dap hydra"         "h" #'dap-hydra
      :desc "dap debug restart" "r" #'dap-debug-restart
      :desc "dap debug"         "s" #'dap-debug

      ;; debug
      :prefix ("dd" . "Debug")
      :desc "dap debug recent"  "r" #'dap-debug-recent
      :desc "dap debug last"    "l" #'dap-debug-last

      ;; eval
      :prefix ("de" . "Eval")
      :desc "eval"                "e" #'dap-eval
      :desc "eval region"         "r" #'dap-eval-region
      :desc "eval thing at point" "s" #'dap-eval-thing-at-point
      :desc "add expression"      "a" #'dap-ui-expressions-add
      :desc "remove expression"   "d" #'dap-ui-expressions-remove

      :prefix ("db" . "Breakpoint")
      :desc "dap breakpoint toggle"      "b" #'dap-breakpoint-toggle
      :desc "dap breakpoint condition"   "c" #'dap-breakpoint-condition
      :desc "dap breakpoint hit count"   "h" #'dap-breakpoint-hit-condition
      :desc "dap breakpoint log message" "l" #'dap-breakpoint-log-message)


;; Java Configuration
(after! lsp-java
  (require 'lsp-java-boot)
  (add-hook 'lsp-mode-hook #'lsp-lens-mode)
  (add-hook 'java-mode-hook #'lsp-java-boot-lens-mode)

  (setq lombok-library-path (concat doom-data-dir "lombok.jar"))
  (unless (file-exists-p lombok-library-path)
    (url-copy-file "https://projectlombok.org/downloads/lombok.jar" lombok-library-path))
  (setq lsp-java-vmargs '("-XX:+UseG1GC" "-XX:MaxGCPauseMillis=50" "-Xmx1G" "-Xms100m"))
  (push (concat "-javaagent:" (expand-file-name lombok-library-path)) lsp-java-vmargs))


;; (add-hook 'lsp-mode-hook #'lsp-lens-mode)
;; (add-hook 'java-mode-hook #'lsp-java-boot-lens-mode)
;; (add-hook! 'java-mode-hook 'eglot-java-mode)
;; (after! java-mode
;;   (setq lombok-library-path (concat doom-data-dir "lombok.jar"))
;;   (unless (file-exists-p lombok-library-path)
;;     (url-copy-file "https://projectlombok.org/downloads/lombok.jar" lombok-library-path))
;;   (setq eglot-java-eclipse-jdt-args '("-XX:+UseParallelGC" "-XX:GCTimeRatio=4" "-XX:AdaptiveSizePolicyWeight=90" "-Dsun.zip.disableMemoryMapping=true" "-Xmx2G" "-Xms100m"))
;;   (push (concat "-javaagent:" (expand-file-name lombok-library-path)) eglot-java-eclipse-jdt-args))

;; (use-package! lsp-bridge
;;   :config
;;   (setq lombok-library-path (concat doom-data-dir "lombok.jar"))
;;   (unless (file-exists-p lombok-library-path)
;;     (url-copy-file "https://projectlombok.org/downloads/lombok.jar" lombok-library-path))
;;   (setq lsp-bridge-jdtls-jvm-args '("-XX:+UseG1GC" "-XX:MaxGCPauseMillis=50" "-Dsun.zip.disableMemoryMapping=true" "-Xmx1G" "-Xms100M"))
;;   (push (concat "-javaagent:" (expand-file-name lombok-library-path)) lsp-bridge-jdtls-jvm-args)

;;   ;; (setq lsp-bridge-jdtls-jvm-args '("-javaagent:/Users/lihailong/softs/java/lombok.jar"))
;;   (setq lsp-bridge-enable-log nil)
;;   (global-lsp-bridge-mode))

;; (after! lsp-bridge
;;   (map! :leader
;;         :desc "lsp-bridge-find-def" "cd" #'lsp-bridge-find-def
;;         :desc "lsp-bridge-find-reference" "cD" #'lsp-bridge-find-references
;;         :desc "lsp-bridge-find-implement" "ci" #'lsp-bridge-find-impl
;;         :desc "lsp-bridge-find-type-def" "ct" #'lsp-bridge-find-type-def
;;         :desc "lsp-bridge-code-format" "cf" #'lsp-bridge-code-action
;;         :desc "lsp-bridge-code-action" "ca" #'lsp-bridge-code-action
;;         :desc "lsp-bridge-rename" "ca" #'lsp-bridge-rename
;;         :desc "lsp-bridge-list-symbols" "cs" #'lsp-bridge-workspace-list-symbols
;;         :desc "lsp-bridge-show-document" "ck" #'lsp-bridge-show-documentation
;;         ))
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
;;    company-minimum-prefix-length 1

;;    ;; get only preview
;;    company-frontends '(company-preview-frontend)
;;    ;; also get a drop down
;;    ;; company-frontends '(company-pseudo-tooltip-frontend company-preview-frontend)
;;    ))
(use-package! sis
  :init
  ;; `C-s/r' 默认优先使用英文 必须在 sis-global-respect-mode 前配置
  (setq sis-respect-go-english-triggers
        (list 'isearch-forward 'isearch-backward) ; isearch-forward 命令时默认进入en
        sis-respect-restore-triggers
        (list 'isearch-exit 'isearch-abort)) ; isearch-forward 恢复, isearch-exit `<Enter>', isearch-abor `C-g'
  (setq sis-prefix-override-keys '("C-c" "C-x" "C-h" "M-SPC"))

  :config
  (setq sis-english-source "com.apple.keylayout.ABC")
  (sis-ism-lazyman-config
   "com.apple.keylayout.ABC"
   "com.apple.inputmethod.SCIM.ITABC") ; 输入码 1033/英文，2052/中文小狼毫
  ;; enable the /cursor color/ mode 中英文光标颜色模式
  (sis-global-cursor-color-mode t)
  ;; enable the /respect/ mode buffer 输入法状态记忆模式
  (sis-global-respect-mode t)
  ;; enable the /follow context/ mode for all buffers
  ;; (sis-global-context-mode t)
  ;; enable the /inline english/ mode for all buffers,
  ;; (sis-global-inline-mode nil)
  ;; (global-set-key (kbd "<f9>") 'sis-log-mode) ; 开启日
  ;; 特殊定制合理咯
  (setq sis-default-cursor-color "green"
        sis-other-cursor-color "#FF2121")
  ;; (setq sis-default-cursor-color "green yellow" ; 英文光标色
  ;;  	sis-other-cursor-color "#FF2121" ; 中文光标色
  ;; 	;; sis-inline-tighten-head-rule 'all ; 删除头部空格，默认1，删除一个空格，1/0/'all
  ;;       sis-inline-tighten-tail-rule 'all ; 删除尾部空格，默认1，删除一个空格，1/0/'all
  ;;       sis-inline-with-english t ; 默认是t, 中文context下输入<spc>进入内联英文
  ;;       sis-inline-with-other nil) ; 默认是nil，而且prog-mode不建议开启, 英文context下输入<spc><spc>进行内联中文
  ;; 特殊buffer禁用sis前缀,使用Emacs原生快捷键  setqsis-prefix-override-buffer-disable-predicates
  ;; (setq sis-prefix-override-buffer-disable-predicates
  ;;       (list 'minibufferp
  ;;             (lambda (buffer) ; magit revision magit的keymap是基于text property的，优先级比sis更高。进入 magit 后，disable sis的映射
  ;;       	(sis--string-match-p "^magit-revision:" (buffer-name buffer)))
  ;;             (lambda (buffer) ; special buffer，所有*打头的buffer，但是不包括*Scratch* *New, *About GNU等buffer
  ;;       	(and (sis--string-match-p "^\*" (buffer-name buffer))
  ;;       	     (not (sis--string-match-p "^\*About GNU Emacs" (buffer-name buffer))) ; *About GNU Emacs" 仍可使用 C-h/C-x/C-c 前缀
  ;;       	     (not (sis--string-match-p "^\*New" (buffer-name buffer)))
  ;;       	     (not (sis--string-match-p "^\*Scratch" (buffer-name buffer))))))) ; *Scratch*  仍可使用 C-h/C-x/C-c 前缀
  )




(define-key evil-normal-state-map (kbd "<SPC>=f") 'lsp-format-buffer)



;; (add-load-path! "/Users/lihailong/.config/doom/emacs-application-framework")

;; (require 'eaf)
;; (require 'eaf-browser)
;; (require 'eaf-pdf-viewer)

