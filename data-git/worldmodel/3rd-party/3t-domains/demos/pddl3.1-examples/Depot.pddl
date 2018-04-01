(in-package :ap)

;; Versions of PDDL prior to 3.1 do not allow functions
;;  to have object values, only numbers.
;; In OWL they would be DatatypeProperty

(define (domain Depot)
    (:requirements :typing :fluents)
  (:types place locatable - object
	  depot distributor - place
	  truck hoist surface - locatable
	  pallet crate - surface)
  (:predicates (at ?x - locatable ?y - place) 
	       (on ?x - crate ?y - surface)
	       (in ?x - crate ?y - truck)
	       (lifting ?x - hoist ?y - crate)
	       (available ?x - hoist)
	       (clear ?x - surface)
	       )
  (:functions				; note: all assumed to have range Number
   (load_limit ?t - truck) 
   (current_load ?t - truck) 
   (weight ?c - crate)
   (fuel-cost)			       
   )
	
  (:action Drive
	   :parameters (?x - truck ?y - place ?z - place) 
	   :precondition (and (at ?x ?y))
	   :effect (and (not (at ?x ?y)) 
			(at ?x ?z)
			(increase (fuel-cost) 10)))

  (:action Lift
	   :parameters (?x - hoist ?y - crate ?z - surface ?p - place)
	   :precondition (and (at ?x ?p) 
			      (available ?x) 
			      (at ?y ?p) 
			      (on ?y ?z) 
			      (clear ?y))
	   :effect (and (not (at ?y ?p)) 
			(lifting ?x ?y) 
			(not (clear ?y)) 
			(not (available ?x)) 
			(clear ?z) 
			(not (on ?y ?z)) 
			(increase (fuel-cost) 1)))

  (:action Drop 
	   :parameters (?x - hoist ?y - crate ?z - surface ?p - place)
	   :precondition (and (at ?x ?p) 
			      (at ?z ?p) 
			      (clear ?z) 
			      (lifting ?x ?y))
	   :effect (and (available ?x) 
			(not (lifting ?x ?y)) 
			(at ?y ?p) 
			(not (clear ?z)) 
			(clear ?y)
			(on ?y ?z)))

  (:action Load
	   :parameters (?x - hoist ?y - crate ?z - truck ?p - place)
	   :precondition (and (at ?x ?p) 
			      (at ?z ?p) 
			      (lifting ?x ?y)
			      (<= (+ (current_load ?z) (weight ?y)) 
				  (load_limit ?z)))
	   :effect (and (not (lifting ?x ?y))
			(in ?y ?z) 
			(available ?x)
			(increase (current_load ?z) (weight ?y))))

  (:action Unload 
	   :parameters (?x - hoist ?y - crate ?z - truck ?p - place)
	   :precondition (and (at ?x ?p) 
			      (at ?z ?p) 
			      (available ?x) 
			      (in ?y ?z))
	   :effect (and (not (in ?y ?z)) 
			(not (available ?x)) 
			(lifting ?x ?y)
			(decrease (current_load ?z) (weight ?y))))
  )

(define (problem depotprob1818) 
    (:domain Depot)
  (:objects
   depot0 - depot
   distributor0 distributor1 - distributor
   truck0 truck1 - truck
   pallet0 pallet1 pallet2 - pallet
   crate0 crate1 - crate
   hoist0 hoist1 hoist2 - hoist)
  (:init
   (at pallet0 depot0)
   (clear crate1)
   (at pallet1 distributor0)
   (clear crate0)
   (at pallet2 distributor1)
   (clear pallet2)
   (at truck0 distributor1)
   (= (current_load truck0) 0)
   (= (load_limit truck0) 323)
   (at truck1 depot0)
   (= (current_load truck1) 0)
   (= (load_limit truck1) 220)
   (at hoist0 depot0)
   (available hoist0)
   (at hoist1 distributor0)
   (available hoist1)
   (at hoist2 distributor1)
   (available hoist2)
   (at crate0 distributor0)
   (on crate0 pallet1)
   (= (weight crate0) 11)
   (at crate1 depot0)
   (on crate1 pallet0)
   (= (weight crate1) 86)
   (= (fuel-cost) 0)
   )
  (:goal (and
	  (on crate0 pallet2)
	  (on crate1 pallet1)))
  (:metric minimize (fuel-cost)))
