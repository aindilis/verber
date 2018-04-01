(in-package :ap)

;; Main difference in PDDL 3.1:  fluents may have object values,
;;  not just numerical values

(define (domain Depot-new)
    (:requirements :typing :equality :fluents)
  (:types place locatable - object
	  depot distributor - place
	  truck hoist surface - locatable
	  pallet crate - surface)
  (:constants no-crate - crate)
  (:predicates
   (clear ?s - surface))

  (:functions				; difference: functions
   (load-limit ?t - truck)		;  may have object values
   (current-load ?t - truck)		; so only assign can be used
   (weight ?c - crate)
   (fuel-cost) - number			; not strictly necessary, default
   (position-of ?l - locatable) - place
   (crate-held ?h - hoist) - crate
   (thing-below ?c - crate) - (either surface truck))

  (:action drive
   :parameters (?t - truck ?p - place)
   :effect (and (assign (position-of ?t) ?p)
		(increase (fuel-cost) 10)))

  (:action lift
   :parameters (?h - hoist ?c - crate)
   :precondition (and (= (position-of ?h) (position-of ?c))
		      (= (crate-held ?h) no-crate)
		      (clear ?c))
   :effect (and (assign (crate-held ?h) ?c)
                (assign (position-of ?c) undefined)
		(assign (thing-below ?c) undefined)
		(clear (thing-below ?c))
		(increase (fuel-cost) 1)))

  (:action drop
   :parameters (?h - hoist ?c - crate ?s - surface)
   :precondition (and (= (position-of ?h) (position-of ?s))
                      (= (crate-held ?h) ?c)
		      (clear ?s))
   :effect (and (assign (crate-held ?h) no-crate)
                (assign (position-of ?c) (position-of ?h))
		(assign (thing-below ?c) ?s)
		(not (clear ?s))))

  (:action load
   :parameters (?h - hoist ?c - crate ?t - truck)
   :precondition (and (= (position-of ?h) (position-of ?t))
		      (= (crate-held ?h) ?c)
		      (<= (+ (current-load ?t) (weight ?c))
			  (load-limit ?t)))
   :effect (and (assign (crate-held ?h) no-crate)
		(assign (thing-below ?c) ?t)
		(increase (current-load ?t) (weight ?c))))

  (:action unload
   :parameters (?h - hoist ?c - crate ?t - truck)
   :precondition (and (= (position-of ?h) (position-of ?t))
		      (= (crate-held ?h) no-crate)
		      (= (thing-below ?c) ?t))
   :effect (and (assign (thing-below ?c) undefined)
		(assign (crate-held ?h) ?c)
		(decrease (current-load ?t) (weight ?c))))
  )

(define (problem depotprob1818)
  (:domain Depot-new)
  (:objects depot0 - depot
	    distributor0 distributor1 - distributor
	    truck0 truck1 - truck
	    pallet0 pallet1 pallet2 - pallet
	    crate0 crate1 - crate
	    hoist0 hoist1 hoist2 - hoist)
  (:init
   (= (position-of pallet0) depot0)
   (clear crate1)
   (= (position-of pallet1) distributor0)
   (clear crate0)
   (= (position-of pallet2) distributor1)
   (clear pallet2)
   (= (position-of truck0) distributor1)
   (= (current-load truck0) 0)
   (= (load-limit truck0) 323)
   (= (position-of truck1) depot0)
   (= (current-load truck1) 0)
   (= (load-limit truck1) 220)
   (= (position-of hoist0) depot0)
   (= (crate-held hoist0) no-crate)
   (= (position-of hoist1) distributor0)
   (= (crate-held hoist1) no-crate)
   (= (position-of hoist2) distributor1)
   (= (crate-held hoist2) no-crate)
   (= (position-of crate0) distributor0)
   (= (thing-below crate0) pallet1)
   (= (weight crate0) 11)
   (= (position-of crate1) depot0)
   (= (thing-below crate1) pallet0)
   (= (weight crate1) 86)
   (= (fuel-cost) 0))

  (:goal (and (= (thing-below crate0) pallet2)
	      (= (thing-below crate1) pallet1)))

  (:metric minimize (fuel-cost))
  )
