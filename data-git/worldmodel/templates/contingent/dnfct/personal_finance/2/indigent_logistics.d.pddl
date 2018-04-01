(define (domain indigent_logistics)
 (:types PERSON OBJECT LOCATION)
 (:predicates
  (at_pl ?person - PERSON  ?location - LOCATION)
  (at_ol ?object - OBJECT ?location - LOCATION)
  (in_ol ?object - OBJECT ?location - LOCATION)
  (in_op ?object - OBJECT ?person - PERSON)
  (true)
  )
 
 (:functions
  (travelTime ?location1 ?location2 - LOCATION)
  )

 (:action sense_object_t
  :parameters (?object - OBJECT ?location - LOCATION ?person - PERSON)
  :precondition (at_pl ?person ?location)
  :effect (and (at_ol ?object ?location) (true)))

 (:action EAT
  :parameters
  (?person - PERSON
   ?object - OBJECT
   ?location - LOCATION
   )
  :precondition
  (and 
   (at_pl ?person ?location)
   (at_ol ?object ?location) 
   )
  :effect
  (and
   (not (at_ol ?object ?location)) 
   (in_op ?object ?person)
   )
  )

 (:action MOVE
  :parameters
  (?person - PERSON
   ?loc1 ?loc2 - LOCATION
   )
  :precondition
  (and
   (at_pl ?person ?loc1)
   )
  :effect
  (and
   (not (at_pl ?person ?loc1)) 
   (at_pl ?person ?loc2)
   )
  )
 )
