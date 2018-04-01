;; Planning out for todays tasks, so that I can figure out what I need
;; to do and when, given the constraints

(define (domain LAUNDRY)
  (:requirements :typing)
  (:types object - object)
  (:predicates 	
   (dirty ?o - object)
   (washed ?o - object)
   (cleaned ?o - object)
   )	

  (:functions	
   )	

  (:durative-action Wash
		    :parameters 
		    (?o - object)
		    :duration
		    (= ?duration 1)
		    :condition 
		    (and 	
		     (at start (not (cleaned ?o)))
		     )
		    :effect 
		    (and
		     (at end (washed ?o))
		     )
		    )

  (:durative-action Dry
		    :parameters 
		    (?o - object)
		    :duration
		    (= ?duration 1)
		    :condition 
		    (and 	
		     (at start (washed ?o))
		     )
		    :effect 
		    (and
		     (at end (cleaned ?o))
		     )
		    )

  ) ;; end define domain
