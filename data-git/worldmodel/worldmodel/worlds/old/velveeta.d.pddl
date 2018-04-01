(define

 (domain VELVEETA)

 (:requirements :negative-preconditions :conditional-effects
  :equality :typing :fluents :durative-actions
  :derived-predicates)

 (:types
  food - object
  container - object)

 (:predicates
  (cooked ?f - food)
  (uncooked ?f - food)
  (heated ?f - food)
  (unheated ?f - food)
  (empty ?c - container)
  )

 (:functions
  (cooking-time ?f - food)
  (heating-time ?f - food)
  (capacity ?c - container)
  )

 (:durative-action Cook
  :parameters (?f - food)
  :duration (= ?duration (cooking-time ?f))
  :condition (and
	      (at start
	       (and
		(heated ?f)
		(uncooked ?f)
		(not (cooked ?f)))))
  :effect (and
	   (at end
	    (and
	     (cooked ?f)
	     (not (uncooked ?f))
	     )
	    )
	   )
  )

 (:durative-action Heat
  :parameters (?f - food)
  :duration (= ?duration (heating-time ?f))
  :condition (and
	      (at start
	       (not
		(heated ?f)
		)
	       )
	      (at start
	       (unheated ?f)
	       )
	      )
  :effect (and
	   (at end
	    (heated ?f))
	   (at end
	    (not (unheated ?f))))
  )

)