(define (problem indigent_logistics_p_1) 

 (:domain indigent_logistics_1)

 (:requirements :strips :equality :typing :conditional-effects :disjunctive-preconditions)

 (:objects
  john - PERSON
  food1 warmMeal1 - OBJECT
  startingLocation foodPantry1 nonexistent soupKitchen1 - LOCATION
  )
 
 (:init
  (and

   (oneof
    (at_ol food1 foodPantry1)
    (at_ol food1 nonexistent)
    )

   (oneof
    (at_ol warmMeal1 soupKitchen1)
    (at_ol warmMeal1 nonexistent)
    )

   (at_pl john startingLocation)
   (= (travelTime startingLocation foodPantry1) 3.0)
   (= (travelTime startingLocation soupKitchen1) 10.0)
   (= (travelTime foodPantry1 soupKitchen1) 13.0)
   )
  )
 (:goal
  (or
   (in_op food1 john)
   (in_op warmMeal1 john)
   )
  )
 )
