(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(custom-enabled-themes (quote (monokai)))
 '(custom-safe-themes
   (quote
    ("b2ecd9aff80c47b3b18cfaa6b8ef8b9f0575168f9ef3ce7be85f63f959138ced" "e52718d4b950106873fed00c469941ad8db20f02392d2c7ac184c6defe37ad2c" "705663330a37fa0a5468a4423529e909005f1fde9042fefb025d507a7715efe0" "d409bcd828a041ca8c28433e26d1f8a8e2f0c29c12c861db239845f715a9ea97" default)))
 '(electric-indent-mode t)
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; activates packages before loading full .emacs file
;;(setq package-enable-at-startup nil)
;;(package-initialize)

;;(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(load-theme 'monokai)
(global-linum-mode t) ;; adds line number
(global-visual-line-mode t) ;; prevents work breaking in line wrap
(setq-default cursor-type 'bar)
(setq column-number-mode t) ;; activates column number

;; smooth scrolling
;;(setq scroll-step 1)
;;(setq scroll-conservatively 1000)
;;(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
;;(setq mouse-wheel-progressive-speed nil)
;;(setq mouse-wheel-follow-mouse t)

;; elpy
(require 'package)
(add-to-list 'package-archives
	                  '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)
(elpy-enable)

;; syntax checking on the fly
;;(global-flycheck-mode)
;;(require 'epa-file)
;;(epa-file-enable)

(defun px-raise-frame-and-give-focus ()
  (when window-system
    (raise-frame)
    (x-focus-frame (selected-frame))
    (set-mouse-pixel-position (selected-frame) 4 4)
    ))
(add-hook 'server-switch-hook 'px-raise-frame-and-give-focus)

;; usa o 'latexmk' para compilar tudo de uma vez:
;; (It will output dvi or pdf depending on the active mode)
(eval-after-load "tex"
  '(progn
     (add-to-list 'TeX-expand-list
                  '("%(LatexmkPDF)"
                    (lambda ()
                      (if
                          (not TeX-PDF-mode)
                          "-pdfdvi"
                        "-pdf"
                        ))))
     (add-to-list 'TeX-command-list
                  '("Latexmk" "latexmk -g %(LatexmkPDF) %t"
                    TeX-run-command nil t) t)
     (add-to-list 'TeX-command-list
                  '("Latexmk-clean" "latexmk -c"
                    TeX-run-command nil t) t)
     )
)

;; fica o latexmk por defeito na variavel TeX-command-default:
(add-hook 'LaTeX-mode-hook
          (lambda ()
            (setq TeX-command-default "Latexmk")))
(add-hook 'latex-mode-hook
          (lambda ()
            (setq TeX-command-default "Latexmk")))
(tool-bar-mode -1) 
;;fontification of citep
(setq font-latex-match-reference-keywords
      '(
	("citeauthor" "[{")
	("Citeauthor" "[{")
	("citep" "[{")))
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)
;;autostart flyspell
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)
;;start multiple cursors and define keybindings
(require 'multiple-cursors)
(global-set-key (kbd "C-c m c") 'mc/edit-lines)
(global-set-key (kbd "C-c m n") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c m p") 'mc/mark-previous-like-this)

;;change backup location
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
;;change M-backspace from backward-kill-word to backward-delete-word
(defun delete-word (arg)
      "Delete characters forward until encountering the end of a word.    
With argument, do this that many times."
      (interactive "p")
      (if (use-region-p)
	  (delete-region (region-beginning) (region-end))
	(delete-region (point) (progn (forward-word arg) (point)))))

(defun backward-delete-word (arg)
      "Delete characters backward until encountering the end of a word.   
With argument, do this that many times."
      (interactive "p")
      (delete-word (- arg)))

(global-set-key (read-kbd-macro "<M-DEL>") 'backward-delete-word)

(setq column-number-mode t) ;; mostra o numero da coluna
 ;;desliga highlight
;;(defun my-emacs-lisp-mode-hook ()
;;  (highlight-indentation))
;;(add-hook 'emacs-lisp-mode-hook 'my-emacs-lisp-mode-hook)

;;para os backups ficarem num diretorio
;;(setq
;;   backup-by-copying t      ; don't clobber symlinks
;;   backup-directory-alist
;;    '(("." . "~/.saves/"))    ; don't litter my fs tree
;;   delete-old-versions t
;;   kept-new-versions 6
;;   kept-old-versions 2
;;   version-control t)       ; use versioned backups
;;(setq backup-by-copying t   ; don't clobber symlinks
;;      version-control t     ; use versioned backups
;;      delete-old-versions t
;;      kept-new-versions 6
;;      kept-old-versions 2)
;;
