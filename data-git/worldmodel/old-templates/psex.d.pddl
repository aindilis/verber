(define

 (domain PSEX)

 (:requirements :timed-initial-literals :negative-preconditions
  :equality :typing :fluents :durative-actions
  :derived-predicates)

 (:types
  unilang-entry person - object
  )

 (:predicates
  (completed ?e - unilang-entry)
  (depends ?e1 ?e2 - unilang-entry)
  (provides ?e1 ?e2 - unilang-entry)
  (eases ?e1 ?e2 - unilang-entry)
  (present-and-future)
  )

 (:functions
  (costs ?e - unilang-entry)
  (earns ?e - unilang-entry)
  (budget ?p - person)
  )

 (:durative-action Complete
  :parameters (?e1 - unilang-entry ?p - person)
  :duration (= ?duration 1)
  :condition (and
	      ;; ensure that we have made it to the future of now
	      (over all (present-and-future))
	      ;; ensure we have enough money
	      (at start 
	       (>= (budget ?p) (costs ?e1))
	       )
	      ;; make sure there are no unsatisfied preconditions
	      (at start
	       (not 
		(exists (?e2 - unilang-entry)
		 (and
		  (depends ?e1 ?e2)
		  (not (completed ?e2))
		  ))))
	      ;; make sure if a provides exists one is used
	      (at start
	       (or
		(not
		 (exists (?e3 - unilang-entry) 
		  (provides ?e3 ?e1)))
		(exists (?e4 - unilang-entry)
		 (and
		  (provides ?e4 ?e1)
		  (completed ?e4)))))
	      (at start (not (completed ?e1)))
	      )
  :effect (and
	   (at end (completed ?e1))
	   (at start (decrease (budget ?p) (costs ?e1)))
	   (at end (increase (budget ?p) (earns ?e1)))
	   )
  )
 )