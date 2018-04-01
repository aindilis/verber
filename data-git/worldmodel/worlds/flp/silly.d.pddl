(define (domain silly)

 (:requirements :typing :fluents :negative-preconditions)

 (:types product person - object)

 (:predicates
  (own ?pe - person ?pr - product)
  (notown ?pe - person ?pr - product)
  )

 (:functions
  (total-actions)
  )

 (:action buy
  :parameters (?pe - person ?pr - product)
  :precondition (and
		 (not (own ?pe ?pr))
		 )
  :effect (and
	   (own ?pe ?pr)
	   (increase (total-actions) 1)
	   )
  )
 )