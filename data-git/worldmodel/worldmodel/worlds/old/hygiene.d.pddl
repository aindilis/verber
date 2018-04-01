
(define (domain hygiene)

 (:requirements :negative-preconditions :conditional-effects
  :equality :typing :fluents :durative-actions
  :derived-predicates)

 (:types 
  object location outlet stuff tool
  person - object
  battery-powered-device - object
  electric-razor - battery-powered-device
  collection - object
  meals - collection
  office - location
  building - location
  store - building
  headset - object
  container - object
  lockable-container - container
  locker - lockable-container
  bag - container
  tool - object
  hygiene-tool - tool
  laptop - battery-powered-device
  )

 (:predicates
  (socially-acceptable ?p - person)
  (isolated ?l - location)
  (inaccessible ?l - location)
  (at ?ob - object ?l - location)
  (autonomous ?ob - object)
  (mobile ?ob - object)
  (holding ?ob0 ?ob1 - object)
  (is-contained-by ?ob1 - object ?c - container)
  (plugged-in ?l - laptop)
  (all-pending-work-accomplished ?p - person)
  (shaved ?p - person)
  (showered ?p - person)
  (clean ?la - laundry)
  (wet ?la - laundry)
  (tired ?p - person)
  (hungry ?p - person)
  (locked ?lo - lockable-container)
  (use-is-required ?t - tool)
  (ship-shape)
  )

 (:functions
  (actions)
  (quantity ?c - collection)
  (hourly-wage-net ?p - person)
  (total-walking-distance)
  (charge-rate ?r - battery-powered-device)
  (charge-level ?r - battery-powered-device)
  (speed ?ob - object)
  (cash ?p - person)
  )

 ;; see ~/myfrdcsa/codebases/verber/domain-library/DOMAINS/PROMELA/OPTICAL_TELEGRAPH_DERIVEDPREDIC/ADL_DERIVEDPREDICATES/

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
    (at ?la ?l)
    (at ?r ?l)
    (at ?t ?l))))

 (:durative-action pick-up
  :parameters (?ob0 - object ?ob1 - object ?l - location)
  :duration (= ?duration 0.1)
  :condition (and
	      (over all (autonomous ?ob0))
	      (over all (mobile ?ob1))
	      (over all (at ?ob0 ?l))
	      (at start (at ?ob1 ?l))
	      )
  :effect (and
	   (at end (holding ?ob0 ?ob1))
	   (at end (not (at ?ob1 ?l)))
	   (at end (assign (actions) (+ (actions) 1)))
	   )
  )

 (:durative-action set-down
  :parameters (?ob0 - object ?ob1 - object ?l - location)
  :duration (= ?duration 0.1)
  :condition (and 
	      (over all (autonomous ?ob0))
	      (at start (holding ?ob0 ?ob1))
	      (over all (at ?ob0 ?l))
	      )
  :effect (and
	   (at end (not (holding ?ob0 ?ob1)))
	   (at end (at ?ob1 ?l))
	   (at end (assign (actions) (+ (actions) 1)))
	   )
  )

 (:durative-action lock
  :parameters (?p - person ?lo - lockable-container ?l - location)
  :duration (= ?duration 0.1)
  :condition (and
	      (at start (not (locked ?lo)))
	      (at start (at ?p ?l))
	      (at start (at ?lo ?l))
	      )
  :effect (and
	   (at end (locked ?lo))
	   (at end (assign (actions) (+ (actions) 1)))
	   )
  )

 (:durative-action unlock
  :parameters (?p - person ?lo - lockable-container ?l - location)
  :duration (= ?duration 0.1)
  :condition (and
	      (at start (locked ?lo))
	      (at start (at ?p ?l))
	      (at start (at ?lo ?l))
	      )
  :effect (and
	   (at end (not (locked ?lo)))
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
		  (locked ?lc)
		  ))))
	      (at start (at ?p ?l))
	      (at start (at ?ob ?l))
	      (at start (at ?lo ?l))
	      )
  :effect (and
	   (at end (is-contained-by ?ob ?lo))
	   (at end (not (at ?ob ?l)))
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
		  (locked ?lc)
		  ))))
	      (at start (is-contained-by ?ob ?lo))
	      (at start (at ?lo ?l))
	      (at start (at ?p ?l))
	      )
  :effect (and
	   (at end (not (is-contained-by ?ob ?lo)))
	   (at end (at ?ob ?l))
	   (at end (assign (actions) (+ (actions) 1)))
	   )
  )

 (:durative-action move
  :parameters (?ob0 - object ?l0 ?l1 - location)
  :duration (= ?duration 0.15)
  :condition (and
	      (over all (autonomous ?ob0))
	      (at start (at ?ob0 ?l0))
	      (at start (not (inaccessible ?l0)))
	      (at end (not (inaccessible ?l1)))
	      (at end (not (exists (?lo - lockable-container)
			    (not (locked ?lo)))))
	      )
  :effect (and
	   (at end (not (at ?ob0 ?l0)))
	   (at end (at ?ob0 ?l1))
	   (at end (assign (actions) (+ (actions) 1)))
	   (at end (assign (total-walking-distance)
		    (+ (total-walking-distance) 1)))
	   )
  )

 (:durative-action plug-in
  :parameters (?p - person ?la - laptop ?o - outlet ?l - location)
  :duration (= ?duration 0.1)
  :condition (and
	      (over all (at ?p ?l))
	      (over all (at ?o ?l))
	      (over all (at ?la ?l))
	      )
  :effect (and
	   (at end (plugged-in ?la))
	   )
  )

 (:durative-action shave
  :parameters (?r - electric-razor ?p - person ?l - location)
  :duration (= ?duration 0.25)
  :condition (and 
	      (over all (holding ?p ?r))
	      (over all (isolated ?l))
	      (at start (>= (charge-level ?r) 0.5))
	      (over all (at ?p ?l))
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
	      (at start (at ?p ?l))
	      (over all (at ?o ?l))
	      (over all (at ?b ?l))
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
	      (at start (at ?p ?l))
	      (at start (at ?t ?l))
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
	      (at start (at ?p ?l))
	      (over all (at ?s ?l))
	      (at start (use-is-required ?t))
	      )
  :effect (and 
	   (at end (showered ?p))
	   (at end (assign (actions) (+ (actions) 1)))
	   (at end (not (use-is-required ?t)))
	   )
  )

 (:durative-action wash-laundry
  :parameters (?p - person ?la - laundry ?lm - laundromat ?l - location)
  :duration (= ?duration 0.75)
  :condition (and
	      (at start (at ?p ?l))
	      (at start (at ?la ?l))
	      (at start (at ?lm ?l))
					; (at start (>= (cash ?p) 1.35))
	      )
  :effect (and 
					; (at end (assign (cash ?p) (- (cash ?p) 1.35)))
	   (at end (wet ?la))
	   (at end (assign (actions) (+ (actions) 1)))
	   )
  )

 (:durative-action dry-laundry
  :parameters (?p - person ?la - laundry ?lm - laundromat ?l - location)
  :duration (= ?duration 0.75)
  :condition (and
	      (at start (at ?p ?l))
	      (at start (at ?la ?l))
	      (at start (at ?lm ?l))
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
  :duration (= ?duration 3)
  :condition (and
	      (over all (ship-shape))
	      (over all (not (use-is-required finger-clippers)))
	      (over all (socially-acceptable ?p))
	      (over all (at ?p ?o))
	      (over all (at ?la ?o))
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
	      (over all (at ?p ?l))
	      (over all (at ?b ?l))
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
	      (at start (at ?p ?l))
	      (at start (at ?m ?l))
	      )
  :effect (and 
	   (at end (not (hungry andy)))
	   (at end (assign (quantity ?m) (- (quantity ?m) 1)))
	   (at end (assign (actions) (+ (actions) 1)))
	   )
  )

 (:durative-action use-tool
  :parameters (?p - person ?t - tool ?l - location)
  :duration (= ?duration 1)
  :condition (and
	      (over all (at ?p ?l))
	      (over all (at ?t ?l))
	      )
  :effect (and 
	   (at end 
	    (not (use-is-required ?t)))
	   (at end (assign (actions) (+ (actions) 1)))
	   )
  )
 )
