(define

 (domain NEW)
 
 (:requirements :constraints :fluents :typing :preferences :durative-actions)

 (:types
  person goal - object
  )
 
 (:predicates
  (done ?g - goal)
  )

 (:functions
  (savings ?p - person)
  )

 (:durative-action Do
  :parameters (?g - goal ?p - person)
  :duration (= ?duration 1)
  :condition (and (at start (not (done ?g))))
  :effect (and (at end (done ?g))
	   (at end (decrease (savings ?p) 10))
	   )
  )
)