(add-to-list 'auto-mode-alist '("\\.verb\\'" . verb-mode))
(add-to-list 'auto-mode-alist '("\\.pddl\\'" . verb-mode))
(add-to-list 'auto-mode-alist '("\\.PDDL\\'" . verb-mode))

(define-derived-mode verb-mode
 PDDL-mode "Verb"
 "Major mode for interacting with .verb files.
\\{verb-mode-map}"
 (setq case-fold-search nil)
 (define-key verb-mode-map (kbd "TAB") 'cmh-complete-or-tab)
 (define-key verb-mode-map [C-tab] 'cmh-complete-or-tab)
 (define-key verb-mode-map "\C-tg" 'verber-get-CWW)
 (define-key verb-mode-map "\C-tw" 'verber-load-world)
 (define-key verb-mode-map "\C-tt" 'verber-load-template)
 ;;(define-key verb-mode-map "\C-tt" 'verber-load-world-and-template)
 (define-key verb-mode-map "\C-tr" 'verber-run-verber)
 (define-key verb-mode-map "\C-tp" 'verber-load-psex)
 (define-key verb-mode-map "\C-tv" 'verber-visualize)
 (define-key verb-mode-map "\C-ti" 'verber-iem2)
 (define-key verb-mode-map "\C-tv" 'verber-edit-main-scheduling-file)
 )

(setq PDDL-font-lock-keywords
 (list
  (cons (regexp-opt '(
		      ":adl"
		      ":conditional-effects"
		      ":constraints"
		      ":derived-predicates"
		      ":disjunctive-preconditions"
		      ":durative-actions"
		      ":equality"
		      ":existential-preconditions"
		      ":fluents"
		      ":negative-preconditions"
		      ":preferences"
		      ":strips"
		      ":timed-initial-literals"
		      ":typing"
		      ":universal-preconditions"


		      ;; additions for our verb format
		      ":nested-terms"
		      ) t)
   'font-lock-constant-face)
  (cons (regexp-opt '(
		      "all"
		      "and"
		      "assign"
		      "at"
		      "decrease"
		      "define"
		      "domain"
		      ":domain"
		      "either"
		      "end"
		      "exists"
		      "forall"
		      "increase"
		      "maximize"
		      "minimize"
		      "not"
		      "or"
		      "over"
		      "problem"
		      "scale-down"
		      "scale-up"
		      "start"
		      "total-time"
		      "when"
		      ) 'words)
   'font-lock-keyword-face)
  (cons "\\(\\(^\\|[^\\\\\n]\\)\\(\\\\\\\\\\)*\\);+.*$"
   'font-lock-comment-face)
  (cons "\\(\\W\\|^\\)\\?\\w*" 'font-lock-variable-name-face)
  (cons (regexp-opt '(
		      ":action"
		      ":condition"
		      ":constants"
		      ":derived"
		      ":duration"
		      ":durative-action"
		      ":effect"
		      ":functions"
		      ":goal"
		      ":includes"
		      ":init"
		      ":metric"
		      ":objects"
		      ":parameters"
		      ":precondition"
		      ":predicates"
		      ":requirements"
		      ":timing"
		      ":types"
		      ) t)
   'font-lock-builtin-face)))

(defun regexp-opt (strings &optional paren)
  "Return a regexp to match a string in the list STRINGS.
Each string should be unique in STRINGS and should not contain any regexps,
quoted or not.  If optional PAREN is non-nil, ensure that the returned regexp
is enclosed by at least one regexp grouping construct.
The returned regexp is typically more efficient than the equivalent regexp:

 (let ((open (if PAREN \"\\\\(\" \"\")) (close (if PAREN \"\\\\)\" \"\")))
   (concat open (mapconcat 'regexp-quote STRINGS \"\\\\|\") close))

If PAREN is `words', then the resulting regexp is additionally surrounded
by \\=\\< and \\>.
If PAREN is `symbols', then the resulting regexp is additionally surrounded
by \\=\\_< and \\_>."
  (save-match-data
    ;; Recurse on the sorted list.
    (let* ((max-lisp-eval-depth 10000)
	   (max-specpdl-size 10000)
	   (completion-ignore-case nil)
	   (completion-regexp-list nil)
	   (open (cond ((stringp paren) paren) (paren "\\(")))
	   (sorted-strings (delete-dups
			    (sort (copy-sequence strings) 'string-lessp)))
	   (re (regexp-opt-group sorted-strings (or open t) (not open))))
      (cond ((eq paren 'words)
	     (concat "\\<" re "\\>"))
	    ((eq paren 'symbols)
	     (concat "\\_<" re "\\_>"))
	    (t re)))))
