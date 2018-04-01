(define (problem indigent_logistics_p_1) 

 (:domain indigent_logistics_1)

 ;; (:requirements :strips :equality :typing :conditional-effects :disjunctive-preconditions)			

 (:objects
  john - PERSON
  warmMeal1 - OBJECT
  foodPantry1 nonexistent startingLocation - LOCATION
  )
 
 (:init
  (and

   (oneof
    (at_ol warmMeal1 foodPantry1)
    (at_ol warmMeal1 nonexistent)
    )

   (at_pl john startingLocation)

   )
  )
 (:goal
  (in_op warmMeal1 john)
  )
 )
