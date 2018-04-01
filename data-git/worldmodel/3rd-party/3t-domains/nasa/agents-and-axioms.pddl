;; -*- Mode: LISP; Syntax: ANSI-COMMON-LISP; Package: AP -*- 
(in-package :ap)
(define (domain nasa-domain)
  (:requirements :multi-agent :durative-actions)
  (:extends nasa2i)
  (:types body-size - abstract-entity
	  )
  (:predicates 
   ;;(ingressed ?c - crew ?o - (or spdm_arm crew_&_equipment_translation_aid_[ceta] articulating-portable-foot-restraint))
   (intermediate-loc-for  ?l1 ?l2 ?l3 - location)
   (retrieve-and-stow ?ev - crew ?item - station-object)
   (inserted-item ?ev - crew ?ddcu - dc-to-dc-converter-unit)
   (crew-moved-to ?l - location)
   ;;(Delay-action_a ?c - crew)
   ;;(Delay10_a ?t - state)
   (crew-and-tools ?l - location)
   (all-jobs ?s - state) ;; used with make-top-action
   )
  (:init 
   (intermediate-loc-for airlock P3B20F01NP P1B10F01MM)
   (intermediate-loc-for P3B20F01NP airlock P1B10F01MM))
  #|(:axiom
   :vars (?a - Agent
	     ?h - (or spdm_arm crew_&_equipment_translation_aid_[ceta])
	     ?l - iss-location)
   :context (and (ingressed ?a ?h)
		 (has-iss-location ?h ?l))
   :implies (has-iss-location ?a ?l)
   :documentation "you are located wherever the thing you're ingressed to is located.")|#
(:axiom
 :vars (?o1 - container
	    ?o2 - physical-entity)
   :context (not (contains ?o1 ?o2))
   :implies (not (contained_by ?o2 ?o1))
   :documentation "when one is negated, the other must be as well")
(:axiom
   :vars (?a - agent
          ?e - entity)
   :context (not (possesses ?a ?e))
   :implies (not (possessed_by ?e ?a))
   :documentation "when one is negated, the other must be as well")
)


#|(defun ap-tell (actions &optional show-sit-props)
  (loop for act in (if (not (listp actions)) (list actions) actions)
      do
	(with-slots (name purpose bindings direct-effects input-situation output-situation) act
    (format t "~%Name: ~a." name)
    (format t "~%Purpose: ~a." purpose)
    (format t "~%Input sit: ~a, Output sit: ~a" (name input-situation)(name output-situation))
    (format t "~%Bindings: ~{~%   ~a ~}" bindings)
    (format t "~%Effects: ~{~%   ~a ~}~%" direct-effects)
    (when show-sit-props
      (format t "~%In sit props: ~{~%   ~a ~}" (situation-propositions input-situation))
      (format t "~%Out sit props: ~{~%   ~a ~}~%" (situation-propositions output-situation))
      ))))|#

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