;; Exercise

;; requirements:

(define (domain exercise)

  (:requirements :negative-preconditions :conditional-effects
		 :equality :typing :fluents :durative-actions
		 :derived-predicates)

  (:types 

   )

  (:predicates

   )

  (:functions

   )

  (:durative-action exercise
		    :parameters (?ob0 - object ?ob1 - object ?l - location)
		    :duration (= ?duration 0.1)
		    :condition (and
				(over all (autonomous ?ob0))
				(over all (mobile ?ob1))
				(over all (at ?ob0 ?l))
				(at start (at ?ob1 ?l))
				)
		    :effect (and
			     (at end (holding ?ob0 ?ob1))
			     (at end (not (at ?ob1 ?l)))
			     (at end (assign (actions) (+ (actions) 1)))
			     )
		    )

  )
