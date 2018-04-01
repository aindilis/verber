;; Planning out for todays tasks, so that I can figure out what I need
;; to do and when, given the constraints

(define (domain CLASSES)
  (:requirements :typing)
  (:types person class - object
	  classroom - location)
  (:predicates 	
   (at ?o - object ?s - location)
   (held-in ?c - class ?r - classroom)
   (attended ?p - person ?c - class)
   (beginning-of ?c - class)
   )	

  (:functions	
   (class-length ?c - class)
   )	

  (:durative-action move
		    :parameters (?ob0 - object ?l0 ?l1 - location)
		    :duration (= ?duration 0.15)
		    :condition (and
				(at start (at ?ob0 ?l0))
				)
		    :effect (and
			     (at end (not (at ?ob0 ?l0)))
			     (at end (at ?ob0 ?l1))
			     )
		    )

  (:durative-action AttendClass
		    :parameters 
		    (?p - person ?c - class ?r - classroom)
		    :duration
		    (= ?duration (class-length ?c))
		    :condition 
		    (and 	
		     (at start (beginning-of ?c))
		     (at start (held-in ?c ?r))
		     (over all (at ?p ?r))
		     )
		    :effect 
		    (and
		     (at end (attended ?p ?c))
		     )
		    )

  ) ;; end define domain


