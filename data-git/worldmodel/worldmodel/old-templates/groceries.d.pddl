;; (include BUSROUTE)

(define (domain GROCERIES)
 (:requirements :typing)
 (:types object - object)
 (:predicates 	
  (has-groceries ?p - person)
  (has-store ?s - stop)
  )	
 (:functions	

  )	
  (:durative-action BuyGroceries
		    :parameters 
		    (?p - person ?s - stop)
		    :duration
		    (= ?duration 1.0)
		    :condition 
		    (and 	
		     (over all (at ?p ?s))
		     (over all (has-store ?s))
		     )
		    :effect 
		    (and
		     (at end (has-groceries ?p))
		     )
		    )

 )
