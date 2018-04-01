
(define (domain date-20120902)

 (:requirements :negative-preconditions :conditional-effects
  :equality :typing :fluents :durative-actions :derived-predicates)

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
  shower laundry - object
  landing - space
  laundry-washing-machine - container
  laundry-dryer-machine - container
  desk - furniture
  furniture - object
  day - text-string
  date - text-string
  text-string - informational-object
  informational-object - object
  article-of-clothing - laundry
  shirt - article-of-clothing
  pants - article-of-clothing
  towel - laundry
  set - informational-object
  laundry-load - container
  bed - object
  bedding - laundry
  object location outlet stuff tool person - object
  collection - object
  mealtype - collection
  office - location
  building - location
  store - building
  container - object
  lockable-container - container
  locker - lockable-container
  bag - container
  tool - object
  hygiene-tool - tool
  electric-device - object
  battery-powered-device - electric-device
  electric-razor laptop - battery-powered-device
  computer - electric-device
  )

 (:predicates
  (has-door ?d - door ?l1 - location ?l2 - location)
  (presentable ?p - person)
  (isolated ?l - location)
  (inaccessible ?l - location)
  (at-location ?ob - object ?l - location)
  (autonomous ?ob - object)
  (mobile ?ob - object)
  (holding ?ob0 ?ob1 - object)
  (is-contained-by ?ob1 - object ?c - container)
  (plugged-in ?b - electric-device)
  (all-pending-work-accomplished ?p - person ?d - date)
  (shaved ?p - person)
  (showered ?p - person)
  (location-is-clean ?o - location)
  (wet ?la - laundry)
  (tired ?p - person)
  (exhausted ?p - person)
  (locked-door ?d - door)
  (locked-container ?lo - lockable-container)
  (use-is-required ?o - object)
  (ship-shape)
  (closed ?d - door)
  (connected-to ?s1 - space ?s2 - space)
  (acceptable-to-perform-hygiene-actions ?p - person ?l - location)
  (has-permission-to-use ?p - person ?o - object)
  (dirty ?o - object)
  (workday ?d - date)
  (weekday ?d - date)
  (holiday ?d - date)
  (today ?d - date)
  (ready-for-work ?p - person)
  (day-of-week ?date - date ?day - day)
  (wearing ?person - person ?aoc - article-of-clothing)
  (has-fee-for-use ?o - object)
  )

 (:functions
  (actions)
  (quantity ?c - collection ?l - location)
  (total-walking-distance)
  (discharge-rate ?r - battery-powered-device)
  (charge-rate ?r - battery-powered-device)
  (charge-level ?r - battery-powered-device)
  (speed ?ob - object)
  (cash ?p - person)
  (fee-for-use ?o - object)
  (hours-worked-on-date ?p - person ?d - date)
  (how-filling ?m - mealtype ?p - person)
  (rate-of-eating ?p - person)
  (food-ingested ?p - person)
  (hunger-level ?p - person)
  )

 ;; see ~/myfrdcsa/codebases/verber/domain-library/DOMAINS/PROMELA/OPTICAL_TELEGRAPH_DERIVEDPREDIC/ADL_DERIVEDPREDICATES/

  (:derived (location-is-clean ?location - location)
   (forall (?o - object) 
    (imply
     (at-location ?o ?location)
     (not (dirty ?o)))))

  (:derived (connected-to ?space1 - space ?space2 - space)
   (connected-to ?space2 ?space1))

  (:derived (has-door ?door - door ?space1 - space ?space2 - space)
   (has-door ?door ?space2 ?space1))

  (:derived (mobile ?ob - object)
   (autonomous ?ob))
 
  (:derived (presentable ?p - person)
   (and
    (shaved ?p)
    (showered ?p)
    ;; (exists (?s - shirt)
    ;;  (and
    ;;   (not (dirty ?s))
    ;;   (wearing ?p ?s)
    ;;   (not (wet ?s))
    ;;   ))
    ;; (exists (?pa - pants)
    ;;  (and
    ;;   (not (dirty ?pa))
    ;;   (wearing ?p ?pa)
    ;;   (not (wet ?pa))
    ;;   ))
    ))

  (:derived (ready-for-work ?p - person)
   (and
    (presentable ?p)
    ;; add more conditions here
    ))

  (:derived (ship-shape)
   (exists (?p - person ?la - laundry ?r - electric-razor ?t - towel ?l - location)
    (and
     (presentable ?p)
     (at-location ?la ?l)
     (at-location ?r ?l)
     (at-location ?t ?l))))

  (:derived (acceptable-to-perform-hygiene-actions ?p - person ?br - bathroom)
 	(has-permission-to-use ?p ?br))

  (:derived (workday ?d - date)
   (and
    (weekday ?d)
    (not (holiday ?d))))

  ;; (:derived (at-location ?object - object ?location2 - location)
  ;;  (exists (?location1 - location)
  ;;   (and 
  ;;    (at-location ?object ?location1)
  ;;    (at-location ?location1 ?location2))))

 ;;  (:derived (all-pending-work-accomplished ?p - person ?d - date)
 ;;   (>= (hours-worked-on-date ?p ?d) 8))

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
 	      (over all (acceptable-to-perform-hygiene-actions ?p ?l))
 	      (at start (>= (charge-level ?r) 0.25))
 	      (over all (at-location ?p ?l))
 	      )
  :effect (and 
 	   (at end (shaved ?p))
 	   (at end (assign (charge-level ?r) (- (charge-level ?r) 0.25)))
 	   (at end (assign (actions) (+ (actions) 1)))
 	   )
  )

 (:durative-action charge-fully
  :parameters (?b - battery-powered-device ?o - outlet ?p - person ?l - location)
  :duration (= ?duration (/ (- 1 (charge-level ?b)) (charge-rate ?b)))
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
 	      (over all (not (exists (?o - object) (holding ?p ?o))))
 	      )
  :effect (and 
 	   (at end (showered ?p))
 	   (at end (assign (actions) (+ (actions) 1)))
 	   (at end (not (use-is-required ?t)))
 	   )
  )

  (:durative-action work-fifteen-minutes
  :parameters (?p - person ?c - computer ?o - office ?d - date)
  :duration (= ?duration 0.25)
  :condition (and
 	      (over all (ready-for-work ?p))
 	      (over all (not (use-is-required finger-clippers)))
 	      (over all (at-location ?p ?o))
 	      (over all (at-location ?c ?o))
 	      ;; (over all (or (plugged-in ?c)
 	      ;; (>= (charge-level ?c) 0.5)))
 	      (over all (not (exhausted ?p)))
 	      (over all (workday ?d))
 	      (over all (today ?d))
 	      (over all (<= (hours-worked-on-date ?p ?d) 10))
 	      (over all (<= (food-ingested Andrew-Dougherty) 0))
	      ;; (over all (<= (hunger-level ?p) 0.25))
 	      )

  :effect (and 
 	   (at end (assign (hours-worked-on-date ?p ?d) (+ (hours-worked-on-date ?p ?d) 0.25)))
 	   (at end (assign (actions) (+ (actions) 1)))
 	   )
  )

 (:durative-action sleep
  :parameters (?p - person ?b - bed ?l - location)
  :duration (= ?duration 3)
  :condition (and
 	      (over all (at-location ?p ?l))
 	      (over all (at-location ?b ?l))
 	      (over all (not (exists (?o - object) (holding ?p ?o))))
 	      (at start (isolated ?l))
 	      )
  :effect (and 
 	   (at end (not (exhausted ?p)))
 	   (at end (not (tired ?p)))
 	   (at end (assign (actions) (+ (actions) 1)))
 	   )
  )

 (:durative-action eat
  :parameters (?p - person ?m - mealtype ?l - location)
  :duration (= ?duration (/ (how-filling ?m ?p) (rate-of-eating ?p)))
  :condition (and
 	      (at start (>= (quantity ?m ?l) 1))
 	      (at start (at-location ?p ?l))
 	      ;; (at start (prepared ?m))
 	      )
  :effect (and 
 	   (at end (assign (hunger-level ?p) (- (hunger-level ?p) (how-filling ?m ?p))))
 	   (at end (assign (food-ingested ?p) (+ (food-ingested ?p) (how-filling ?m ?p))))
 	   (at end (assign (quantity ?m ?l) (- (quantity ?m ?l) 1)))
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

 (:durative-action wash-laundry-load
  :parameters (?p - person ?w - laundry-washing-machine ?l - location ?ll - laundry-load ?la1 ?la2 ?la3 - laundry)
  :duration (= ?duration 0.75)
  :condition (and
 	      (at start (at-location ?p ?l))
 	      (at start (at-location ?ll ?l))
 	      (at start (at-location ?w ?l))
	      (over all (is-contained-by ?la1 ?ll))
	      (over all (is-contained-by ?la2 ?ll))
	      (over all (is-contained-by ?la3 ?ll))
	      (at start (dirty ?la1))
	      (at start (dirty ?la2))
	      (at start (dirty ?la3))
 	      (at start (>= (cash ?p) (fee-for-use ?w)))
 	      (over all (is-contained-by ?ll ?w))
 	      )
  :effect (and 
 	   (at end (and
		    (not (dirty ?la1))
		    (not (dirty ?la2))
		    (not (dirty ?la3))
		    (wet ?la1)
		    (wet ?la2)
		    (wet ?la3)
		    ))
 	   (at end (decrease (cash ?p) (fee-for-use ?w)))
 	   (at end (assign (actions) (+ (actions) 1)))
 	   )
  )

(:durative-action dry-laundry-load
  :parameters (?p - person ?d - laundry-dryer-machine ?l - location ?ll - laundry-load ?la1 ?la2 ?la3 - laundry)
  :duration (= ?duration 0.75)
  :condition (and
 	      (at start (at-location ?p ?l))
 	      (at start (at-location ?ll ?l))
 	      (at start (at-location ?d ?l))
	      (over all (is-contained-by ?la1 ?ll))
	      (over all (is-contained-by ?la2 ?ll))
	      (over all (is-contained-by ?la3 ?ll))
	      (at start (wet ?la1))
	      (at start (wet ?la2))
	      (at start (wet ?la3))
 	      (at start (>= (cash ?p) (fee-for-use ?d)))
 	      (over all (is-contained-by ?ll ?d))
 	      )
  :effect (and 
 	   (at end (and
		    (not (wet ?la1))
		    (not (wet ?la2))
		    (not (wet ?la3))
		    ))
 	   (at end (decrease (cash ?p) (fee-for-use ?d)))
 	   (at end (assign (actions) (+ (actions) 1)))
 	   )
  )

 (:durative-action clean-location
  :parameters (?p - person ?l - location)
  :duration (= ?duration 0.25)
  :condition (and
 	      (over all (at-location ?p ?l))
 	      )
  :effect (and 
 	   (at end (not (dirty ?l)))
 	   )
  )

 (:durative-action use-the-restroom
  :parameters (?p - person ?br - bathroom)
  :duration (= ?duration 0.25)
  :condition (and
 	      (over all (acceptable-to-perform-hygiene-actions ?p ?br))
 	      (over all (at-location ?p ?br))
	      (at start (autonomous ?p))
 	      )
  :effect (and 
	   (at end (not (autonomous ?p)))
 	   )
  )

 ;; (:durative-action take-out-the-trash
 ;;  :parameters (?p - person ?date - date)
 ;;  :duration (= ?duration 0.25)
 ;;  :condition (and
 ;; 	      (over all (today ?date))
 ;; 	      (over all (day-of-week ?date Saturday))
 ;; 	      )
 ;;  :effect (and 
 ;; 	   )
 ;;  )

 )

 ;; (:durative-action wash-laundry-load
 ;;  :parameters (?p - person ?ll - laundry-load ?w - laundry-washing-machine ?l - location)
 ;;  :duration (= ?duration 0.75)
 ;;  :condition (and
 ;; 	      (at start (at-location ?p ?l))
 ;; 	      (at start (at-location ?ll ?l))
 ;; 	      (at start (at-location ?w ?l))
 ;; 	      (at start (forall (?la - laundry)
 ;; 			 (imply
 ;; 			  (is-contained-by ?la ?ll)
 ;; 			  (dirty ?la))))
 ;; 	      (at start (imply (has-fee-for-use ?w) (>= (cash ?p) (fee-for-use ?w))))
 ;; 	      (over all (is-contained-by ?ll ?w))
 ;; 	      )
 ;;  :effect (and 
 ;; 	   ;; (at end (forall (?la - laundry) 
 ;; 	   ;; 	    (when (and (is-contained-by ?la ?ll))
 ;; 	   ;; 	     (and (wet ?la)))))
 ;; 	   ;; (at end (when (and (has-fee-for-use ?w))
 ;; 	   ;; 	    (and (decrease (cash ?p) (fee-for-use ?w)))))
 ;; 	   (at end (assign (actions) (+ (actions) 1)))
 ;; 	   )
 ;;  )

 ;; (:durative-action dry-laundry-load
 ;;  :parameters (?p - person ?ll - laundry-load ?d - laundry-dryer-machine ?l - location)
 ;;  :duration (= ?duration 1.25)
 ;;  :condition (and
 ;; 	      (at start (at-location ?p ?l))
 ;; 	      (at start (at-location ?ll ?l))
 ;; 	      (at start (at-location ?d ?l))
 ;; 	      (at start (forall (?la - laundry)
 ;; 			 (imply
 ;; 			  (is-contained-by ?la ?ll)
 ;; 			  (wet ?la))))
 ;; 	      (at start (imply (has-fee-for-use ?d) (>= (cash ?p) (fee-for-use ?d))))
 ;; 	      (over all (is-contained-by ?ll ?d))
 ;; 	      )
 ;;  :effect (and 
 ;; 	   ;; (at end (forall (?la - laundry) 
 ;; 	   ;; 	    (when (is-contained-by ?la ?ll)
 ;; 	   ;; 	     (not (dirty ?la)))))
 ;; 	   ;; (at end (when (has-fee-for-use ?d)
 ;; 	   ;; 	    (decrease (cash ?p) (fee-for-use ?d))))
 ;; 	   (at end (assign (actions) (+ (actions) 1)))
 ;; 	   )
 ;;  )

;; (total-time)