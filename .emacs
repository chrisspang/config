(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(blink-cursor-mode nil)
 '(coffee-tab-width 2)
 '(column-number-mode t)
 '(cperl-close-paren-offset -4)
 '(cperl-continued-statement-offset 4)
 '(cperl-fontify-m-as-s t)
 '(cperl-here-face (quote font-lock-preprocessor-face))
 '(cperl-indent-level 4)
 '(cperl-indent-parens-as-block t)
 '(cperl-pod-here-fontify t)
 '(cperl-pod-here-scan t)
 '(cperl-tab-always-indent t)
 '(develock-max-column-plist (quote (emacs-lisp-mode 79 lisp-interaction-mode w change-log-mode t texinfo-mode t c-mode 79 c++-mode 79 java-mode 79 caml-mode 79 tuareg-mode 79 coq-mode 79 latex-mode 79 jde-mode 79 html-mode 79 html-helper-mode 79 cperl-mode 89 perl-mode 79 mail-mode t message-mode t cmail-mail-mode t tcl-mode 79 ruby-mode 79)))
 '(display-time-mode t)
 '(fringe-mode (quote (1 . 1)) nil (fringe))
 '(global-undo-tree-mode t)
 '(scroll-bar-mode (quote right))
 '(size-indication-mode t)
 '(text-mode-hook (quote (turn-on-auto-fill text-mode-hook-identify)))
 '(tool-bar-mode nil)
 '(tooltip-mode nil)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify))
 '(whitespace-style (quote (lines-tail)) t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cperl-hash-face ((t (:foreground "Red"))))
 '(develock-whitespace-1 ((t (:background "Grey"))))
 '(develock-whitespace-2 ((t (:background "#115577"))))
 '(develock-whitespace-3 ((t (:background "#aa6600"))))
 '(font-lock-negation-char-face ((t (:foreground "deep pink"))))
 '(font-lock-preprocessor-face ((t (:inherit font-lock-builtin-face :foreground "blue violet"))))
 '(font-lock-variable-name-face ((t (:foreground "cyan3"))))
 '(mode-line ((t (:background "dim gray" :foreground "black" :box (:line-width -1 :style released-button) :height 0.9 :width normal :family "dejavu sans"))))
 '(whitespace-line ((t (:background "red")))))

(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(setq-default c-basic-offset 4)

(set-face-font 'default "7x14")

;;(setq visible-bell 1)
(setq visible-bell 'top-bottom)

(require 'font-lock)

(display-time) 

;; turn autoindenting on
(global-set-key "\r" 'newline-and-indent)

;; Insert spaces instead of tabs
(setq-default indent-tabs-mode nil)

;; Set line width to 78 columns...
(setq fill-column 78)
(setq auto-fill-mode t)

;; Force use of cperl and not perl-mode
(defalias 'perl-mode 'cperl-mode)
;; Hook .t files to CPerl
(add-to-list 'auto-mode-alist '("\\.t\\'" . cperl-mode))
(setq cperl-invalid-face nil)

(defun intelligent-close ()
  "quit a frame the same way no matter what kind of frame you are on.

This method, when bound to C-x C-c, allows you to close an emacs frame the
same way, whether it's the sole window you have open, or whether it's
a \"child\" frame of a \"parent\" frame.  If you're like me, and use emacs in
a windowing environment, you probably have lots of frames open at any given
time.  Well, it's a pain to remember to do Ctrl-x 5 0 to dispose of a child
frame, and to remember to do C-x C-x to close the main frame (and if you're
not careful, doing so will take all the child frames away with it).  This
is my solution to that: an intelligent close-frame operation that works in
all cases (even in an emacs -nw session).

Stolen from http://www.dotemacs.de/dotfiles/BenjaminRutt.emacs.html."
  (interactive)
  (if (eq (car (visible-frame-list)) (selected-frame))
      ;;for parent/master frame...
      (if (> (length (visible-frame-list)) 1)
          ;;close a parent with children present
          (delete-frame (selected-frame))
        ;;close a parent with no children present
        (save-buffers-kill-emacs))
    ;;close a child frame
    (delete-frame (selected-frame))))

(global-set-key "\C-x\C-c" 'intelligent-close) ;forward reference

(global-set-key "\C-cg" 'goto-line)

(global-set-key "\C-xc" 'recompile)

(prefer-coding-system 'utf-8)
(put 'upcase-region 'disabled nil)

(defun make-backup-file-name (file)
  (concat "~/.emacs-backups/" (file-name-nondirectory file) "~"))

(setq inhibit-splash-screen t)

(setq gnuserv-frame (lambda (f) (eq f (quote x))))

(defadvice server-find-file (before server-find-file-in-one-frame activate)
  "Make sure that the selected frame is stored in `gnuserv-frame', and raised."
  (setq gnuserv-frame (selected-frame))
  (raise-frame))

(defadvice server-edit (before server-edit-in-one-frame activate)
  "Make sure that the selected frame is stored in `gnuserv-frame', and lowered."
  (setq gnuserv-frame (selected-frame))
  (lower-frame))

(add-to-list 'load-path "~/.emacs.d/lisp/")

(defvar *perl-libraries* '() "Cache of all known perl libraries on the system")

(require 'perl-find-library)

(global-set-key "\C-xf" 'perl-find-library)

;; Move between split buffers with Shift-<arrow keys>
;; (windmove-default-keybindings)

(global-set-key "\C-xp" 'other-frame)

(defmacro require-maybe (feature &optional file)
  "*Try to require FEATURE, but don't signal an error if `require' fails."
  `(require ,feature ,file 'noerror)) 

(defmacro when-available (func foo)
  "*Do something if FUNCTION is available."
  `(when (fboundp ,func) ,foo))


(when (require-maybe 'git)
    (require 'git-blame))

;; (require 'git)
;; (require 'git-blame)


;;
;; coffee-script mode (coffee-mode)
;;
;; automatically clean up bad whitespace
(setq whitespace-action '(auto-cleanup))
;; only show bad whitespace
(setq whitespace-style '(trailing space-before-tab indentation empty space-after-tab))

;; This gives you a tab of 2 spaces


;; http://web-mode.org/
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
;; Plain HTML
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[s]css?\\'" . web-mode))

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
)
(add-hook 'web-mode-hook  'my-web-mode-hook)

;; (setq-default frame-title-format "%b (%f)")
;; (setq-default frame-title-format "%f")

(setq frame-title-format
  '(:eval
    (if buffer-file-name
        (replace-regexp-in-string
         "\\\\" "/"
         (replace-regexp-in-string
          (regexp-quote (getenv "HOME")) "~"
          (convert-standard-filename buffer-file-name)))
      (buffer-name))))

(add-to-list 'auto-mode-alist
             '("\\.\\(?:gemspec\\|irbrc\\|gemrc\\|rake\\|rb\\|ru\\|thor\\)\\'" . ruby-mode))
(add-to-list 'auto-mode-alist
             '("\\(Capfile\\|Gemfile\\(?:\\.[a-zA-Z0-9._-]+\\)?\\|[rR]akefile\\)\\'" . ruby-mode))

(defun prelude-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

(global-set-key [remap move-beginning-of-line]
                'prelude-move-beginning-of-line)

(require 'undo-tree)
(global-undo-tree-mode t)

;; Automatically reload log files into buffer
(add-to-list 'auto-mode-alist '("\\.log\\'" . auto-revert-mode))

(setq scroll-margin 5
      scroll-preserve-screen-position 1)

(scroll-bar-mode 0) ;; Disables the scroll bar
;; (fset 'yes-or-no-p ‘y-or-n-p) ;; Answer with y and n instead of yes and no
;; (setq confirm-kill-emacs ‘yes-or-no-p) ;; Ask for confirmation before closing emacs
(show-paren-mode 1) ;; Highlight matching parens
;;(setq mac-command-modifier ‘meta) ;; Treat the CMD key like meta on OSX

;;(global-anzu-mode +1)
(global-anzu-mode)
(global-set-key (kbd "M-%") 'anzu-query-replace)
(global-set-key (kbd "C-M-%") 'anzu-query-replace-regexp)

(require 'goto-chg)

(require 'fullframe)
(fullframe magit-status magit-mode-quit-window nil)

;; M-n M-p
(global-smartscan-mode 1)

(load-theme 'solarized-dark t)

(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))

;; Projectile mode
(require 'projectile)
(projectile-global-mode)
(setq projectile-completion-system 'grizzl)

;; projectile-rails
(add-hook 'projectile-mode-hook 'projectile-rails-on)

;; Auto insert of 'end'
(require 'ruby-end)
;; Auto interpolation #{}
(require 'ruby-interpolation)
;; Ruby tools ...
(require 'ruby-tools)

(eval-after-load "ruby-mode"
  '(add-hook 'ruby-mode-hook 'ruby-electric-mode))

(require 'ido)
(ido-mode 1)

;; Display results vertically
(require 'ido-vertical-mode)
(ido-vertical-mode)

(setq ido-enable-prefix nil
      ido-enable-flex-matching t
      ido-case-fold t ;; ignore case
      ido-auto-merge-work-directories-length -1 ;; disable auto-merge (it's confusing)
      ido-create-new-buffer 'always ;; create new files easily
      ido-use-filename-at-point nil ;; don't try to be smart about what I want
      )

;; I like visual matching (colors)
(setq ido-use-faces t)

;; Ido buffer intuitive navigation
(add-hook 'ido-setup-hook '(lambda ()
                             (define-key ido-completion-map "\C-h" 'ido-delete-backward-updir)
                             (define-key ido-completion-map "\C-n" 'ido-next-match)
                             (define-key ido-completion-map "\C-f" 'ido-next-match)
                             (define-key ido-completion-map "\C-p" 'ido-prev-match)
                             (define-key ido-completion-map "\C-b" 'ido-prev-match)
                             (define-key ido-completion-map " " 'ido-exit-minibuffer)
                             ))


;; Ignore .DS_Store files with ido mode
(add-to-list 'ido-ignore-files "\\.DS_Store")

(require 'magit)
