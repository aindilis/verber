;;; verb-mode.el --- A Planning and Domain Definition Language editing mode    -*-coding: iso-8859-1;-*-

;; Copyright (C) 2005 Surendra K Singhi

;; Authors: 2005      Surendra K Singhi <surendra@asu.edu>
;; Keywords: Verb Planning files 
;; Version: 0.100
;; URL: http://www.public.asu.edu/~sksinghi/Verb-mode.htm

;;; This file is not part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; Purpose:
;;
;; To provide a pleasant mode to browse and edit Verb files.
;;It provides syntax highlighting with automatic indentation,
;;templates, auto-completion, and a Declaration imenu which
;;list all the actions and the problems in the current file.
;;
;;
;; This mode supports full Verb 2.2 
;;
;; Installation:
;; 
;; Put in your ~/.emacs:
;;      (add-to-list 'load-path "/lib/emacs/Verb-mode")
;;      (require 'Verb-mode)
;;
;; Version 0.100: Verb-mode released
;; History:
;;
;; This mode was written by Surendra Singhi in February 2005.
;; Special thanks also goes to Stefan Monnier <monnier@iro.umontreal.ca> for
;; helping me with various parts of the code
;; If you have any problems or suggestions or patches specific to the mode
;;please contact the author via email.  
;;
;;

;;; Code:

(require 'easymenu)
(require 'font-lock)
(require 'regexp-opt)
(require 'custom)
(require 'lisp-mode)
;; (require 'pcomplete)
(require 'imenu)

(defvar Verb-mode-hook nil)

(defvar Verb-mode-map
  (let ((Verb-mode-map (make-sparse-keymap)))
    (define-key Verb-mode-map [return] 'newline-and-indent)
   ;; (define-key Verb-mode-map [tab] 'pcomplete)
    (define-key Verb-mode-map '[(control t) (a)] 'Verb-mode-tempate-insert-action)
    (define-key Verb-mode-map '[(control t) (p)] 'Verb-mode-tempate-insert-problem)
    (define-key Verb-mode-map '[(control t) (d)] 'Verb-mode-tempate-insert-domain)
    (define-key Verb-mode-map '[(control t) (e)] 'Verb-mode-temp)
    Verb-mode-map)
  "Keymap for Verb major mode")

(add-to-list 'auto-mode-alist '("\\.verb\\'" . Verb-mode))
(add-to-list 'auto-mode-alist '("\\.Verb\\'" . Verb-mode))

(defvar Verb-font-lock-keywords-1
  (list (cons "\\(\\(^\\|[^\\\\\n]\\)\\(\\\\\\\\\\)*\\);+.*$"
	      'font-lock-comment-face)
	(cons "\\(\\W\\|^\\)\\?\\w*" 'font-lock-variable-name-face)
	(cons (regexp-opt '(":requirements" ":types" ":constants" ":predicates"
			    ":action" ":domain" ":parameters" ":effect"
			    ":precondition" ":objects" ":init" ":goal"
			    ":functions" ":duration" ":condition" ":derived"
			    ":metric" ":extends") t)
	      'font-lock-builtin-face))
  "Minimal highlighting expressions for Verb mode")

(defconst Verb-font-lock-keywords-2
  (append Verb-font-lock-keywords-1
	  (list (cons (regexp-opt '("define" "and" "or" "not" "problem"
				    "domain" "either" "exists" "forall"
				    "when" "assign" "scale-up" "scale-down"
				    "increase" "decrease" "start" "end" "all"
				    "at" "over" "minimize" "maximize"
				    "total-time") 'words)
		      'font-lock-keyword-face)))
  "Additional Keywords to highlight in Verb mode")

(defconst Verb-font-lock-keywords-3
  (append Verb-font-lock-keywords-2
	  (list (cons (regexp-opt '(":strips" ":typing" ":equality" ":adl"
				    ":negative-preconditions" ":durative-actions"
				    ":disjunctive-preconditiorns" ":fluents"
				    ":existential-preconditions"
				    ":derived-predicates"
				    ":universal-preconditions"
				    ":timed-initial-literals" ":constraints" ":preferences") t)
		      'font-lock-constant-face)))
    "Additional Keywords to highlight in Verb mode")
		       
(defvar Verb-font-lock-keywords Verb-font-lock-keywords-3
  "Default highlighting expressions for Verb mode is maximum.")

(defconst Verb-mode-syntax-table
   (copy-syntax-table lisp-mode-syntax-table)
  "Syntax table for Verb mode is same as lisp mode syntax table.")

(define-skeleton Verb-mode-tempate-insert-action
  "Inserts the template for an action definition."
  nil
  > "(:action " (skeleton-read "action name?") \n
  > ":parameters("_")" \n > ":precondition()" \n > ":effect())")

(define-skeleton Verb-mode-tempate-insert-domain
  "Inserts the template for a domain definition."
  nil
  > "(define (domain " (skeleton-read "domain name?") ")"\n
  > "(:requirements :strips " _ ")" \n > "(:predicates )" \n > ")")

(define-skeleton Verb-mode-tempate-insert-problem
  "Inserts the template for a problem definition."
  nil
  >"(define (problem " (skeleton-read "problem name?") ")"\n
  > "(:domain " (skeleton-read "domain name?") ")" \n
  > "(:init " _ ")" \n > "(:goal ))" \n)


(easy-menu-define Verb-mode-menu Verb-mode-map
     "Menu for Verb mode."
     '("Verb"
       ("Templates" ["Insert domain" Verb-mode-tempate-insert-domain :active t :keys "C-t d"]
	["Insert problem" Verb-mode-tempate-insert-problem :active t :keys "C-t p" ]
	["Insert action" Verb-mode-tempate-insert-action :active t :keys "C-t a"])))

(defvar Verb-mode-imenu-generic-expression
  '(("Actions" "(\\s-*\\:action\\s-*\\(\\s\w+\\)" 1)
    ("Problems" "(\\s-*problem\\s-*\\(\\s\w+\\)" 1)))

(defvar Verb-mode-imenu-syntax-alist '(("_-" . "w")))

(defvar Verb-mode-all-completions 
  '(":strips" ":typing" ":equality" ":adl" ":negative-preconditions" ":durative-actions"
   ":disjunctive-preconditiorns" ":fluents" ":existential-preconditions" ":derived-predicates"
   ":universal-preconditions" ":timed-initial-literals" "define" "and" "or" "not" "problem"
   "domain" "either" "exists" "forall" "when" "assign" "scale-up" "scale-down" "increase"
   "decrease" "start" "end" "all" "at" "over" "minimize" "maximize" "total-time")
  "The list of possible completions.")


;; (defun pcomplete-Verb-mode-setup ()
;;   "Function to setup the pcomplete variables."
;;  (interactive)
;;   (set (make-local-variable 'pcomplete-parse-arguments-function)
;;        'pcomplete-parse-Verb-mode-arguments)
;;   (set (make-local-variable 'pcomplete-default-completion-function)
;;        'pcomplete-Verb-mode-default-completion))

;; (defun pcomplete-Verb-mode-default-completion()
;;   (pcomplete-here Verb-mode-all-completions))

;; (defun pcomplete-parse-Verb-mode-arguments ()
;;   (save-excursion
;;     (let* ((thispt (point))
;; 	   (pt (search-backward-regexp "[ \t\n]" nil t))
;; 	   (ptt (if pt (+ pt 1) thispt)))
;;       (list
;;        (list "dummy" (buffer-substring-no-properties ptt thispt))
;;        (point-min) ptt))))

(define-derived-mode Verb-mode emacs-lisp-mode "Verb";  ;lisp-mode "Verb"   ;
  "Major mode for editing Verb files"
  (set (make-local-variable 'comment-start) ";;")
  ;everything that begins with ';' is comment and remember \; is not a comment but \\; is
  (set (make-local-variable 'comment-start-skip) "\\(\\(^\\|[^\\\\\n]\\)\\(\\\\\\\\\\)*\\);+ *")
  (set (make-local-variable 'font-lock-defaults) '(Verb-font-lock-keywords nil t))
  (set-syntax-table Verb-mode-syntax-table)
  (set (make-local-variable 'indent-line-function) 'lisp-indent-line)
  (easy-menu-add Verb-mode-menu Verb-mode-map)
  ;; (pcomplete-Verb-mode-setup)
  (setq imenu-generic-expression Verb-mode-imenu-generic-expression
	imenu-case-fold-search nil
	imenu-syntax-alist Verb-mode-imenu-syntax-alist)
  (imenu-add-to-menubar "Declarations"))

(provide 'Verb-mode)

;;; verb-mode.el ends here
