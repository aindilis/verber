;; -*- Mode: LISP; Syntax: ANSI-COMMON-LISP; Package: AP -*- 
(in-package :ap)
(define (domain nas-domain)
  (:requirements :multi-agent :durative-actions)
  (:extends dodi)
  (:predicates 
   (Delay10_a ?o - agent ?s - state)
   (tasks-done1 ?lcs - agent)(tasks-done2 ?lcs - agent)(tasks-done3 ?lcs - agent)
   (all-jobs ?s - state) ;; used with make-top-action
   )
(:axiom
 :vars (?o1 - container
	    ?o2 - physical-entity)
   :context (not (contains ?o1 ?o2))
   :implies (not (contained_by ?o2 ?o1))
   :documentation "when one is negated, the other must be as well")
)

(defun ap-tell (actions &optional show-is?)
  (loop for act in (if (not (listp actions)) (list actions) actions)
      do
	(with-slots (name purpose bindings direct-effects input-situation output-situation) act
    (format t "~%Name: ~a." name)
    (format t "~%Purpose: ~a." purpose)
    (format t "~%Input sit: ~a, Output sit: ~a" (name input-situation)(name output-situation))
    (if (or (not (typep input-situation 'initial-situation))
	    (and (typep input-situation 'initial-situation)
	     show-is?))
	(format t "~%In sit props: ~{~%   ~a ~}" (situation-propositions input-situation)))
    (format t "~%Out sit props: ~{~%   ~a ~}~%" (situation-propositions output-situation))
    (format t "~%Bindings: ~{~%   ~a ~}" bindings)
    (format t "~%Effects: ~{~%   ~a ~}~%" direct-effects))))