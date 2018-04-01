;; <domain-file>

(define (domain flptest)

 (:requirements :negative-preconditions :conditional-effects :equality
  :typing :fluents :durative-actions :derived-predicates
  :disjunctive-preconditions :timed-initial-literals )

 (:types task - object)
 
 (:predicates
  (completed ?t - task)
  )

 (:functions)

 ;; DERIVED
 ;; (:derived (location-is-clean ?location - location)
 ;;  (forall (?o - object) 
 ;;   (imply
 ;;    (at-location ?o ?location)
 ;;     (not (dirty ?o)))))

 ;; DURATIVE ACTIONS
 (:durative-action complete
  :parameters (?t - task)
  :duration (= ?duration 0.1)
  :condition (and
 	      (at start (not (completed ?t))
 	      )
  :effect (and 
 	   (at end (completed ?t))
 	   )
  )

 )

;; </domain-file>
