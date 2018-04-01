(define

 (domain TIMED-INITIAL-LITERALS)

 (:requirements :typing :adl :durative-actions :fluents :timed-initial-literals)  

 (:predicates
  (present-and-future)
  (done)
  )

 (:durative-action Finish
  :parameters (?e1 - unilang-entry ?p - person)
  :duration (= ?duration 1.0)
  :condition (and
	      (over all (present-and-future))
	      )
  :effect (and
	   (at end (done))
	   )
  )
 )