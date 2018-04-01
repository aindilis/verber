;; -*- Mode: LISP; Syntax: ANSI-COMMON-LISP; Package: AP -*- 
(in-package :ap)
(define (domain spacecraft-domain)
  (:requirements :multi-agent :durative-actions)
  (:extends spacecrafti)
  (:predicates 
   (state-of-components ?sc - space-craft ?s - state)
   (state-of-sensors ?sc - space-craft ?s - state)
   ;;(Delay10_a ?o - agent ?s - state)
   (tasks-done1 ?lcs - agent)(tasks-done2 ?lcs - agent)(tasks-done3 ?lcs - agent)
   (all-jobs ?s - state) ;; used with make-top-action
   )
  (:functions (Delay10_a ?o - agent) - state)
(:axiom
 :vars (?o1 - container
	    ?o2 - physical-entity)
   :context (not (contains ?o1 ?o2))
   :implies (not (contained_by ?o2 ?o1))
   :documentation "when one is negated, the other must be as well")
)
;;;(owl:Restriction 'Delay10_a 'owl:cardinality 1)

(defun time-for-delay (action)
  (print (list "at delay " (name (template action))))
  (cond ((samep (name (template action)) 'delay10)
	 10.0)
	((samep (name (template action)) 'delay24hrs)
	 1440.0)
	((samep (name (template action)) 'delay1hr)
	 60.0)
	(t 15.0)))

(define (durative-action Delay10)
    :parameters (?sc - space-craft
		     ?state - state)
    :duration time-for-delay
    :effect (at end (Delay10_a ?sc ?state)))

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