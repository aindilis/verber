(in-package :ap)

;; Logistics domain, PDDL 3.1 version.
;;  :object-fluents are :functions that allow
;;  non-numerical assignments

(define (domain logistics-new)
    (:requirements :typing :equality :object-fluents)
  (:types package place city - object
	  vehicle location - place
	  airport - location
	  truck airplane - vehicle)
  ;; Essentially no difference except syntax for :functions
  ;;  used in place of :predicates
  (:functions (city-of ?l - location) - city ; in-city
	      (vehicle-location ?v - vehicle) - location ;at, restricted to vehicle
	      (package-location ?p - package) - place)

  (:action drive
	   :parameters    (?t - truck ?l - location)
	   :precondition  (= (city-of (vehicle-location ?t)) 
			     (city-of ?l))
	   :effect        (assign (vehicle-location ?t) ?l))

  (:action fly
	   :parameters    (?a - airplane ?l - airport)
	   :effect        (assign (vehicle-location ?a) ?l))

  (:action load
	   :parameters    (?p - package ?v - vehicle)
	   :precondition  (= (package-location ?p) (vehicle-location ?v))
	   :effect        (assign (package-location ?p) ?v))

  (:action unload
	   :parameters    (?p - package ?v - vehicle)
	   :precondition  (= (package-location ?p) ?v)
	   :effect        (assign (package-location ?p) (vehicle-location ?v)))
  )

(define (problem logistics-4-0)
    (:domain logistics-new)
  (:objects  apn1 - airplane
	     tru1 tru2 - truck
	     obj11 obj12 obj13 obj21 obj22 obj23 - package
	     apt1 apt2 - airport
	     pos1 pos2 - location
	     cit1 cit2 - city)

  (:init  (= (vehicle-location apn1) apt2)
	  (= (vehicle-location tru1) pos1)
	  (= (vehicle-location tru2) pos2)
	  (= (package-location obj11) pos1)
	  (= (package-location obj12) pos1)
	  (= (package-location obj13) pos1)
	  (= (package-location obj21) pos2)
	  (= (package-location obj22) pos2)
	  (= (package-location obj23) pos2)
	  (= (city-of apt1) cit1)
	  (= (city-of apt2) cit2)
	  (= (city-of pos1) cit1)
	  (= (city-of pos2) cit2))

  (:goal  (and (= (package-location obj11) apt1)
	       (= (package-location obj13) apt1)
	       (= (package-location obj21) pos1)
	       (= (package-location obj23) pos1)))
  )
