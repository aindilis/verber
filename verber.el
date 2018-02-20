;;; verber.el --- Edit the current domain and problem

;; Copyright (C) 2004  Free Software Foundation, Inc.

;; Author: Debian User <adougher9@yahoo.com>
;; Keywords: convenience, processes

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;;

;;; Code:

(global-set-key "\C-c\C-k\C-vve" 'verber-iem2)

(global-set-key "\C-crvg" 'verber-get-CWW-template)
(global-set-key "\C-crvct" 'verber-get-CWW-template)
(global-set-key "\C-crvcw" 'verber-get-CWW-world)

(global-set-key "\C-crvw" 'verber-load-world)
(global-set-key "\C-crvW" 'verber-open-world-dir)
(global-set-key "\C-crvt" 'verber-load-template)
(global-set-key "\C-crvT" 'verber-open-template-dir)

;; (global-set-key "\C-crvt" 'verber-load-world-and-template)

(global-set-key "\C-crvr" 'verber-run-verber)
(global-set-key "\C-crvk" 'verber-run-verber-skip-templates-skip-federated)
(global-set-key "\C-crvx" 'verber-select-planner)
(global-set-key "\C-crvX" 'verber-load-psex)
(global-set-key "\C-crvv" 'verber-visualize)
(global-set-key "\C-crvm" 'verber-iem2)
(global-set-key "\C-crvl" 'verber-lookup-source)
(global-set-key "\C-crev" 'verber-edit-main-scheduling-file)
(global-set-key "\C-crod" 'verber-jump-to-template-directory)

(global-set-key "\C-crvs" 'verber-search-templates-and-worlds)
(global-set-key "\C-crvy" 'verber-inspect-syntax-error)

(global-set-key "\C-crvit" 'verber-insert-existing-template-domain-and-problem-into-new-domain-and-problem)
(global-set-key "\C-crviw" 'verber-insert-existing-world-domain-and-problem-into-new-domain-and-problem)
(global-set-key "\C-crvI" 'verber-insert-templates-into-new-domain-and-problem)

(global-set-key "\C-crvd" 'verber-open-generated-domain)
(global-set-key "\C-crvp" 'verber-open-generated-problem)
;; (global-set-key "\C-crvP" 'verber-load-template)

(defvar verber-planner "LPG")
;; (setq verber-planner "OPTIC_CLP")

(defvar verber-homedir (concat frdcsa-internal-codebases "/verber"))
(defvar verber-world-dir "data/worldmodel/worlds")
(defvar verber-template-dir "data/worldmodel/templates")
(defvar verber-CWW "date-20120908")

(load (concat verber-homedir "/pddl-mode.el"))
(load (concat verber-homedir "/frdcsa/emacs/verb.el"))

;; (defun verber-load-psex ()
;;  ""
;;  (interactive)
;;  (verber-get-CWW "psex")
;;  (verber-load-windows verber-template-dir "verb"))

(defun verber-load-world (&optional cww)
 ""
 (interactive)
 (verber-get-CWW-world cww)
 (verber-load-windows verber-world-dir "pddl"))

(defun verber-open-world-dir (&optional cww)
 ""
 (interactive)
 (ffap (frdcsa-el-concat-dir (list verber-homedir verber-world-dir))))

(defun verber-load-template (&optional cww)
 ""
 (interactive)
 (verber-get-CWW-template cww)
 (verber-load-windows verber-template-dir "verb"))

(defun verber-open-template-dir (&optional cww)
 ""
 (interactive)
 (ffap (frdcsa-el-concat-dir (list verber-homedir verber-template-dir))))

;; (defun verber-load-world-and-template (&optional cww auto-approve)
;;  ""
;;  (interactive)
;;  (verber-get-CWW cww)
;;  (verber-load-both-template-and-world-windows auto-approve))

(defun verber-load-windows (dir type)
 ""
 (interactive)
 (delete-other-windows)
 (split-window-vertically)
 (split-window-horizontally)
;;  (if (file-exists-p (concat verber-homedir "/" dir "/" verber-CWW ".d." type))
  (ffap (concat verber-homedir "/" dir "/" verber-CWW ".d." type))
;;  (ffap (concat verber-homedir "/" dir "/" verber-CWW ".d." "pddl")))
 (other-window 1)
;;  (if (file-exists-p (concat verber-homedir "/" dir "/" verber-CWW ".p." type))
  (ffap (concat verber-homedir "/" dir "/" verber-CWW ".p." type))
;;  (ffap (concat verber-homedir "/" dir "/" verber-CWW ".p." "pddl")))
 (other-window 1)
 (shell)
 (end-of-buffer)
 (insert (concat "cd " verber-homedir))
 (comint-send-input)
 (split-window-horizontally)
 (other-window 1)
 ;; (ffap (concat verber-homedir "/" verber-world-dir "/todo"))
 ;; (ffap (concat verber-homedir "/Verber/Federated/PSEx.pm"))
 ;; (ffap (concat verber-homedir "/Verber/Util/Graph.pm"))
 (ffap (concat verber-homedir "/Verber/Federated/PSEx3.pm"))
 (other-window -1)
 (kmax-window-configuration-to-register-checking ?A t))

(defun verber-load-both-template-and-world-windows (&optional auto-approve)
 ""
 (interactive)
 (kmax-window-configuration-to-register-checking ?A auto-approve)
 (delete-other-windows)
 (split-window-vertically)
 (split-window-horizontally)
 (ffap (concat verber-homedir "/" verber-template-dir "/" verber-CWW ".d." "verb"))
 (other-window 1)
 (ffap (concat verber-homedir "/" verber-template-dir "/" verber-CWW ".p." "verb"))
 (other-window 1)
 (split-window-horizontally)
 (ffap (concat verber-homedir "/" verber-world-dir "/" verber-CWW ".d." "pddl"))
 (other-window 1)
 (ffap (concat verber-homedir "/" verber-world-dir "/" verber-CWW ".p." "pddl"))
 (other-window 1)
 (kmax-window-configuration-to-register-checking ?B auto-approve))

(defun verber-load-windows-2 (dir)
 ""
 (interactive)
 (kmax-window-configuration-to-register-checking ?A)
 (delete-other-windows)
 (split-window-vertically)
 (split-window-horizontally)
 (ffap (concat verber-homedir "/" dir "/" verber-CWW ".d.pddl"))
 (other-window 1)
 (ffap (concat verber-homedir "/" dir "/" verber-CWW ".p.pddl"))
 (other-window 1)

 ;; switch to buffer "verber-shell"
 (let* ((buffer (get-buffer-create "verber-shell")))
  (if (not (comint-check-proc buffer))
   (shell buffer))
  (switch-to-buffer buffer))
 (see "hi")
 
 (end-of-buffer)
 (insert (concat "cd " verber-homedir))
 (comint-send-input)
 (split-window-horizontally)
 (other-window 1)

 (let* ((buffer (get-buffer-create "iem-shell")))
  (if (not (comint-check-proc buffer))
   (shell buffer))
  (switch-to-buffer buffer))
 (end-of-buffer)
 (comint-interrupt-subjob)
 (insert "cd /var/lib/myfrdcsa/codebases/minor/interactive-execution-monitor && ./iem2")
 (comint-send-input)

 (other-window -1)
 (kmax-window-configuration-to-register-checking ?B))

(defun verber-close-windows ()
 ""
 (interactive))

(defun verber-create-world ()
 "")

(defun verber-run-verber ()
 ""
 (interactive)
 (verber-load-windows verber-template-dir "verb")
 (end-of-buffer)
 (insert (concat "./verber -p " verber-planner " -w " verber-CWW))
 (comint-send-input))

;; (defun verber-run-val ()
;;  ""
;;  (interactive)
;;  (verber-load-windows verber-template-dir "verb")
;;  (end-of-buffer)
;;  (insert (concat "./verber -p " verber-planner " -w " verber-CWW))
;;  (comint-send-input))

(defun verber-run-verber-skip-templates-skip-federated ()
 ""
 (interactive)
 (verber-load-windows verber-world-dir "pddl")
 (end-of-buffer)
 (insert (concat "./verber --skip-templates --skip-federated -p " verber-planner " -w " verber-CWW))
 (comint-send-input))

(defun verber-visualize ()
 ""
 (interactive)
 (verber-load-windows verber-template-dir)
 (end-of-buffer)
 (insert (concat "./verber -p " verber-planner " -w " verber-CWW " --no-plan --vw"))
 (comint-send-input))

(defun verber-iem2 ()
 ""
 (interactive)
 ;; (setq verber-CWW "hac")
 (verber-load-windows-2 verber-world-dir)
 (end-of-buffer)
 (insert (concat "./verber -p " verber-planner " -w " verber-CWW " -u --iem 2"))
 (comint-send-input))



(defun verber-get-CWW-template (&optional entity)
 ""
 (interactive)
 (verber-get-CWW 'template entity))

(defun verber-get-CWW-world (&optional entity)
 ""
 (interactive)
 (verber-get-CWW 'world entity))

(defun verber-get-CWW (type &optional entity)
 ""
 (interactive)
 (let* ((lists
	 (list
	  (concat verber-homedir "/" (if (equal type 'template)
				      verber-template-dir
				      verber-world-dir))))
	(name-dir
	 (apply 'append
	  (mapcar
	   (lambda (dir)
	    (mapcar (lambda (name)
		     (string-match (concat dir "/\\(.*?\\)\\.d\\." (if (equal type 'template) "verb" "pddl") "$") name)
		     (list (match-string 1 name) dir))
	     (kmax-grep-list-regexp (f-entries dir nil t) (concat "d." (if (equal type 'template) "verb" "pddl") "$"))))
	   lists)))
	(tmp
	 (or entity
	  (completing-read "Entity: " name-dir)))
	(verber-CWW
	 (setq verber-CWW tmp)))
  verber-CWW))

;; (defun verber-get-CWW-orig (&optional entity)
;;  ""
;;  (interactive)
;;  (let* ((lists
;; 	 (list
;; 	  (concat verber-homedir "/" verber-world-dir)))
;; 	(name-dir
;; 	 (apply 'append
;; 	  (mapcar
;; 	   (lambda (dir)
;; 	    (mapcar (lambda (name)
;; 		     (string-match "\\(.*?\\)\\.d\\.pddl" name)
;; 		     (list (match-string 1 name) dir))
;; 	     (directory-files dir nil "d.pddl")))
;; 	   lists)))
;; 	(tmp
;; 	 (or entity
;; 	  (completing-read "Entity: " name-dir)))
;; 	(verber-CWW
;; 	 (setq verber-CWW tmp)))
;;   verber-CWW))

(defun verber-edit-main-scheduling-file ()
 "Jump to the latest version of the log file"
 (interactive)
 (ffap "/var/lib/myfrdcsa/codebases/internal/verber/data/worldmodel/templates/cycle/todo.p.verb"))

(defun verber-jump-to-template-directory ()
 "Jump to the latest version of the log file"
 (interactive)
 (dired "/var/lib/myfrdcsa/codebases/internal/verber/data/worldmodel/templates/"))

(defun verber-lookup-source (&optional arg)
 "Given a module name, return the file that contains it."
 (interactive "P")
 (let*
  ((string (substring-no-properties (thing-at-point 'filename)))
   (root
    (progn
     (while
      (string-match "_" string)
      (setq string (replace-match "/" nil t string)))
     (string-match "\\([A-Za-z0-9_\/]+\\)" string)
     (match-string 0 string))))
  (verber-load-world-and-template (downcase root) (non-nil arg))
  ;; (verber-load-both-template-and-world-windows (downcase root))
  ))

(defun verber-search-templates-and-worlds (&optional search-arg)
 ""
 (interactive)
 (let ((search (or search-arg (read-from-minibuffer "Search?: "))))
  (kmax-search-files
   search
   (kmax-grep-list-regexp
    (append
     (kmax-find-name-dired (frdcsa-el-concat-dir (list verber-homedir verber-template-dir)) "\.(verb|pddl)$")
     (kmax-find-name-dired (frdcsa-el-concat-dir (list verber-homedir verber-world-dir)) "\.(verb|pddl)$"))
    "[^~]$")   
   "*Verber Templates and Worlds Search*")))

(defun verber-inspect-syntax-error ()
 (interactive)
 (let* ((regex "^\\(.+?\\).\\([dp]\\).pddl: syntax error in line \\([0-9]+\\), \\(.+?\\):"))
  (if (re-search-backward regex)
   (let* ((line (kmax-get-line)))
    (string-match regex line)
    (let* ((cww (match-string 1 line))
	   (domain-or-problem (match-string 2 line))
	   (line-number (match-string 3 line))
	   (error-message (match-string 4 line)))
     ;; (see (list cww domain-or-problem line-number error-message))
     (ffap (frdcsa-el-concat-dir (list verber-homedir verber-world-dir (concat cww "." domain-or-problem ".pddl"))))
     (goto-line (string-to-int line-number)))))))

(defun verber-insert-templates-into-new-domain-and-problem ()
 ""
 (interactive)
 (insert (kmax-file-contents "/var/lib/myfrdcsa/codebases/internal/verber/data/worldmodel/templates/template.d.verb"))
 (other-window 1)
 (insert (kmax-file-contents "/var/lib/myfrdcsa/codebases/internal/verber/data/worldmodel/templates/template.p.verb"))
 (other-window 3))

(defun verber-insert-existing-template-domain-and-problem-into-new-domain-and-problem ()
 ""
 (interactive)
 (let ((template (verber-get-CWW-template)))
  (insert (kmax-file-contents (concat "/var/lib/myfrdcsa/codebases/internal/verber/data/worldmodel/templates/" template ".d.verb")))
  (other-window 1)
  (insert (kmax-file-contents (concat "/var/lib/myfrdcsa/codebases/internal/verber/data/worldmodel/templates/" template ".p.verb")))
  (other-window 3)))

(defun verber-insert-existing-world-domain-and-problem-into-new-domain-and-problem ()
 ""
 (interactive)
 (let ((world (verber-get-CWW-world)))
  (insert (kmax-file-contents (concat "/var/lib/myfrdcsa/codebases/internal/verber/data/worldmodel/worlds/" world ".d.pddl")))
  (other-window 1)
  (insert (kmax-file-contents (concat "/var/lib/myfrdcsa/codebases/internal/verber/data/worldmodel/worlds/" world ".p.pddl")))
  (other-window 3)))

(defun verber-open-generated-domain ()
 ""
 (interactive)
 (verber-open-generated-file "d"))

(defun verber-open-generated-problem ()
 ""
 (interactive)
 (verber-open-generated-file "p"))

(defun verber-open-generated-file (type)
 ""
 (interactive)
 (end-of-buffer)
 (re-search-backward (concat "^Writing \\(.+." type ".pddl\\)"))
 (forward-word)
 (forward-char)
 (kmax-ffap))

(defun verber-select-planner ()
 ""
 (interactive)
 (setq verber-planner
  (org-frdcsa-manager-dialog--choose
   (list "HSPS" "LPG" "Metric_FF" "MIPS_XXL" "OPTIC_CLP" "CLG"))))

(require 'f nil t)
(provide 'verber)
;;; verber.el ends here
