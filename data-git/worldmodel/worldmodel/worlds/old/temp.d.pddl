
(define (domain date-20120729)

 (:requirements :negative-preconditions :conditional-effects
  :equality :typing :fluents :durative-actions
  :derived-predicates)

 (:types 
  space - location
  room - space
  officeroom - room
  door - object
  entry-way - space
  stairwell - space
  closet - space
  perimeter-door - door
  bathroom - room
  landing - space
  laundry-machine - object
  
  object location outlet stuff tool
  person - object
  battery-powered-device - object
  electric-razor - battery-powered-device
  collection - object
  meals - collection
  office - location
  building - location
  store - building
  container - object
  lockable-container - container
  locker - lockable-container
  bag - container
  tool - object
  hygiene-tool - tool
  laptop - battery-powered-device
  )

 (:predicates
  (has-door ?d - door ?l1 - location ?l2 - location)
  (socially-acceptable ?p - person)
  (isolated ?l - location)
  (inaccessible ?l - location)
  (at-location ?ob - object ?l - location)
  (autonomous ?ob - object)
  (mobile ?ob - object)
  (holding ?ob0 ?ob1 - object)
  (is-contained-by ?ob1 - object ?c - container)
  (plugged-in ?b - battery-powered-device)
  (all-pending-work-accomplished ?p - person)
  (shaved ?p - person)
  (showered ?p - person)
  (clean ?la - laundry)
  (wet ?la - laundry)
  (tired ?p - person)
  (hungry ?p - person)
  (locked-door ?d - door)
  (locked-container ?lo - lockable-container)
  (use-is-required ?t - tool)
  (ship-shape)
  (closed ?d - door)
  (connected-to ?s1 - space ?s2 - space)
  )

 (:functions
  (actions)
  (quantity ?c - collection)
  (hourly-wage-net ?p - person)
  (total-walking-distance)
  (discharge-rate ?r - battery-powered-device)
  (charge-rate ?r - battery-powered-device)
  (charge-level ?r - battery-powered-device)
  (speed ?ob - object)
  (cash ?p - person)
  )

 ;; see ~/myfrdcsa/codebases/verber/domain-library/DOMAINS/PROMELA/OPTICAL_TELEGRAPH_DERIVEDPREDIC/ADL_DERIVEDPREDICATES/

 (:derived (connected-to ?space1 - space ?space2 - space)
  (connected-to ?space2 ?space1))

 (:derived (has-door ?door - door ?space1 - space ?space2 - space)
  (has-door ?door ?space2 ?space1))

 (:derived (mobile ?ob - object)
  (autonomous ?ob))
		      
 (:derived (socially-acceptable ?p - person)
  (and
   (shaved ?p)
   (showered ?p)
   (exists (?la - laundry)
    (clean ?la))))

 (:derived (ship-shape)
  (exists (?p - person ?la - laundry ?r - electric-razor ?t - towel ?l - location)
   (and
    (socially-acceptable ?p)
    (at-location ?la ?l)
    (at-location ?r ?l)
    (at-location ?t ?l))))

 (:durative-action pick-up
  :parameters (?ob0 - object ?ob1 - object ?l - location)
  :duration (= ?duration 0.1)
  :condition (and
	      (over all (autonomous ?ob0))
	      (over all (mobile ?ob1))
	      (over all (at-location ?ob0 ?l))
	      (at start (at-location ?ob1 ?l))
	      )
  :effect (and
	   (at end (holding ?ob0 ?ob1))
	   (at end (not (at-location ?ob1 ?l)))
	   (at end (assign (actions) (+ (actions) 1)))
	   )
  )

 (:durative-action set-down
  :parameters (?ob0 - object ?ob1 - object ?l - location)
  :duration (= ?duration 0.1)
  :condition (and 
	      (over all (autonomous ?ob0))
	      (at start (holding ?ob0 ?ob1))
	      (over all (at-location ?ob0 ?l))
	      )
  :effect (and
	   (at end (not (holding ?ob0 ?ob1)))
	   (at end (at-location ?ob1 ?l))
	   (at end (assign (actions) (+ (actions) 1)))
	   )
  )

 (:durative-action lock-container
  :parameters (?p - person ?lo - lockable-container ?l - location)
  :duration (= ?duration 0.1)
  :condition (and
	      (at start (not (locked-container ?lo)))
	      (at start (at-location ?p ?l))
	      (at start (at-location ?lo ?l))
	      )
  :effect (and
	   (at end (locked-container ?lo))
	   (at end (assign (actions) (+ (actions) 1)))
	   )
  )

 (:durative-action lock-door
  :parameters (?p - person ?d - door ?l1 - location ?l2 - location)
  :duration (= ?duration 0.1)
  :condition (and
	      (at start (not (locked-door ?d)))
	      (at start (closed ?d))
	      (at start (at-location ?p ?l1))
	      (at start (has-door ?d ?l1 ?l2))
	      )
  :effect (and
	   (at end (locked-door ?d))
	   (at end (assign (actions) (+ (actions) 1)))
	   )
  )

 (:durative-action unlock-container
  :parameters (?p - person ?lo - lockable-container ?l - location)
  :duration (= ?duration 0.1)
  :condition (and
	      (at start (locked-container ?lo))
	      (at start (at-location ?p ?l))
	      (at start (at-location ?lo ?l))
	      )
  :effect (and
	   (at end (not (locked-container ?lo)))
	   (at end (assign (actions) (+ (actions) 1)))
	   )
  )

 (:durative-action unlock-door
  :parameters (?p - person ?d - door ?l1 - location ?l2 - location)
  :duration (= ?duration 0.1)
  :condition (and
	      (at start (locked-door ?d))
	      (at start (at-location ?p ?l1))
	      (at start (has-door ?d ?l1 ?l2))
	      )
  :effect (and
	   (at end (not (locked-door ?d)))
	   (at end (assign (actions) (+ (actions) 1)))
	   )
  )


 (:durative-action load
  :parameters (?p - person ?ob - object ?lo - container ?l - location)
  :duration (= ?duration 0.1)
  :condition (and
	      (over all (mobile ?ob))
	      (over all 
	       (forall (?lc - lockable-container)
		(not 
		 (and
		  (= ?lc ?lo)
		  (locked-container ?lc)
		  ))))
	      (at start (at-location ?p ?l))
	      (at start (at-location ?ob ?l))
	      (at start (at-location ?lo ?l))
	      )
  :effect (and
	   (at end (is-contained-by ?ob ?lo))
	   (at end (not (at-location ?ob ?l)))
	   (at end (assign (actions) (+ (actions) 1)))
	   )
  )

 (:durative-action unload
  :parameters (?p - person ?ob - object ?lo - lockable-container ?l - location)
  :duration (= ?duration 0.1)
  :condition (and
	      (over all (mobile ?ob))
	      (over all 
	       (forall (?lc - lockable-container)
		(not 
		 (and
		  (= ?lc ?lo)
		  (locked-container ?lc)
		  ))))
	      (at start (is-contained-by ?ob ?lo))
	      (at start (at-location ?lo ?l))
	      (at start (at-location ?p ?l))
	      )
  :effect (and
	   (at end (not (is-contained-by ?ob ?lo)))
	   (at end (at-location ?ob ?l))
	   (at end (assign (actions) (+ (actions) 1)))
	   )
  )

 (:durative-action move
  :parameters (?ob0 - object ?l0 ?l1 - location)
  :duration (= ?duration 0.15)
  :condition (and
	      (over all (autonomous ?ob0))
	      (at start (at-location ?ob0 ?l0))
	      (at start (not (inaccessible ?l0)))
	      (at end (not (inaccessible ?l1)))
	      (at end (not (exists (?lo - lockable-container)
			    (not (locked-container ?lo)))))
	      )
  :effect (and
	   (at end (not (at-location ?ob0 ?l0)))
	   (at end (at-location ?ob0 ?l1))
	   (at end (assign (actions) (+ (actions) 1)))
	   (at end (assign (total-walking-distance)
		    (+ (total-walking-distance) 1)))
	   )
  )

 (:durative-action plug-in
  :parameters (?p - person ?b - battery-powered-device ?o - outlet ?l - location)
  :duration (= ?duration 0.1)
  :condition (and
	      (over all (at-location ?p ?l))
	      (over all (at-location ?o ?l))
	      (over all (at-location ?b ?l))
	      (over all (not (exists (?co - lockable-container)
			      (is-contained-by ?b ?co))))
	      ;; (over all (not (mobile ?b)))
	      )
  :effect (and
	   (at end (plugged-in ?b))
	   )
  )

 (:durative-action unplug
  :parameters (?p - person ?b - battery-powered-device ?o - outlet ?l - location)
  :duration (= ?duration 0.1)
  :condition (and
	      (at start (plugged-in ?b))
	      )
  :effect (and
	   (at end (not (plugged-in ?b)))
	   ;; (at end (mobile ?b))
	   )
  )

 (:durative-action shave
  :parameters (?r - electric-razor ?p - person ?l - location)
  :duration (= ?duration 0.25)
  :condition (and 
	      (over all (holding ?p ?r))
	      (over all (isolated ?l))
	      (at start (>= (charge-level ?r) 0.5))
	      (over all (at-location ?p ?l))
	      )
  :effect (and 
	   (at end (shaved ?p))
	   (at end (assign (actions) (+ (actions) 1)))
	   )
  )

 (:durative-action charge
  :parameters (?b - battery-powered-device ?o - outlet ?p - person ?l - location)
  :duration (= ?duration (/ 1 (charge-rate ?b)))
  :condition (and
	      (at start (at-location ?p ?l))
	      (over all (at-location ?o ?l))
	      (over all (at-location ?b ?l))
	      )
  :effect (and 
	   (at end (assign (charge-level ?b) 1))
	   (at end (assign (actions) (+ (actions) 1)))
	   )
  )

 (:durative-action arm
  :parameters (?p - person ?t - tool ?l - location)
  :duration (= ?duration 0)
  :condition (and
	      (at start (at-location ?p ?l))
	      (at start (at-location ?t ?l))
	      (at start (mobile ?t))
	      )
  :effect (and 
	   (at end (use-is-required ?t))
	   )
  )

 (:durative-action shower
  :parameters (?p - person ?t - towel ?s - shower ?l - location)
  :duration (= ?duration 1)
  :condition (and
	      (at start (at-location ?p ?l))
	      (over all (at-location ?s ?l))
	      (at start (use-is-required ?t))
	      )
  :effect (and 
	   (at end (showered ?p))
	   (at end (assign (actions) (+ (actions) 1)))
	   (at end (not (use-is-required ?t)))
	   )
  )

 (:durative-action wash-laundry
  :parameters (?p - person ?la - laundry ?lm - laundry-machine ?l - location)
  :duration (= ?duration 0.75)
  :condition (and
	      (at start (at-location ?p ?l))
	      (at start (at-location ?la ?l))
	      (at start (at-location ?lm ?l))
					; (at start (>= (cash ?p) 1.35))
	      )
  :effect (and 
					; (at end (assign (cash ?p) (- (cash ?p) 1.35)))
	   (at end (wet ?la))
	   (at end (assign (actions) (+ (actions) 1)))
	   )
  )

 (:durative-action dry-laundry
  :parameters (?p - person ?la - laundry ?lm - laundry-machine ?l - location)
  :duration (= ?duration 1.25)
  :condition (and
	      (at start (at-location ?p ?l))
	      (at start (at-location ?la ?l))
	      (at start (at-location ?lm ?l))
	      (at start (wet ?la))
					; (at start (>= (cash ?p) 1.35))
	      )
  :effect (and 
					; (at end (assign (cash ?p) (- (cash ?p) 1.35)))
	   (at end (clean ?la))
	   (at end (assign (actions) (+ (actions) 1)))
	   )
  )

 (:durative-action work 
  :parameters (?p - person ?la - laptop ?o - office)
  :duration (= ?duration 0.25)
  :condition (and
	      (over all (ship-shape))
	      (over all (not (use-is-required finger-clippers)))
	      (over all (socially-acceptable ?p))
	      (over all (at-location ?p ?o))
	      (over all (at-location ?la ?o))
	      (over all (or (plugged-in ?la)
			 (>= (charge-level ?la) 0.5)))
	      (over all (not (tired ?p)))
	      (over all (not (hungry ?p)))
	      )
  :effect (and 
	   (at end (tired ?p))
	   (at end (all-pending-work-accomplished ?p))
	   (at end 
	    (assign (cash ?p)
	     (+ 
	      (cash ?p)
	      (* 
	       3
	       (hourly-wage-net ?p)))))
	   (at end (assign (actions) (+ (actions) 1)))
	   )
  )

 (:durative-action sleep
  :parameters (?p - person ?b - bed ?l - location)
  :duration (= ?duration 3)
  :condition (and
	      (over all (at-location ?p ?l))
	      (over all (at-location ?b ?l))
	      (at start (isolated ?l))
	      )
  :effect (and 
	   (at end 
	    (not (tired ?p))
	    )
	   (at end (assign (actions) (+ (actions) 1)))
	   )
  )

 (:durative-action eat
  :parameters (?p - person ?m - meals ?l - location)
  :duration (= ?duration 0.5)
  :condition (and
	      (at start (>= (quantity ?m) 1))
	      (at start (at-location ?p ?l))
	      (at start (at-location ?m ?l))
	      )
  :effect (and 
	   (at end (not (hungry ?p)))
	   (at end (assign (quantity ?m) (- (quantity ?m) 1)))
	   (at end (assign (actions) (+ (actions) 1)))
	   )
  )

 (:durative-action use-tool
  :parameters (?p - person ?t - tool ?l - location)
  :duration (= ?duration 1)
  :condition (and
	      (over all (at-location ?p ?l))
	      (over all (at-location ?t ?l))
	      )
  :effect (and 
	   (at end 
	    (not (use-is-required ?t)))
	   (at end (assign (actions) (+ (actions) 1)))
	   )
  )

 (:durative-action wait
  :parameters (?p - person ?l - location)
  :duration (= ?duration 0.25)
  :condition (and
	      (over all (at-location ?p ?l))
	      )
  :effect (and 
	   (at end (at-location ?p ?l))
	   )
  )
 )
