(in-package :ap)

(define (domain water)
  (:extends transportation)
  (:requirements :durative-actions)
  (:types Waterway - (and Path WaterArea)
	  Harbor PortFacility - (and TransitTerminal WaterArea)
	  ArtificialHarbor - Harbor
	  AmphibiousVehicle WaterVehicle - Vehicle
	  PassengerShip - (and WaterVehicle PassengerVehicle)
	  TankerShip - (and CargoVehicle WaterVehicle))
  (:predicates
   (hasPort - fact ?loc - GeographicRegion ?p - PortFacility))
  (:axiom				; no context so will be applied to initial-situation
   :vars (?v - WaterVehicle)
   :implies (and (capacity ?v 50)
		 (fuelCapacity ?v 100)
		 (hasFuel ?v 100)
		 (maxSpeed ?v 18)))	; large ship, mi/hr
  (:axiom
   :vars (?gr1 ?gr2 - GeographicRegion
	       ?p - PortFacility)
   :context (and (hasPort ?gr1 ?p)
		 (geographicSubregionOf ?gr1 ?gr2))
   :implies (hasPort ?gr2 ?p))
  (:axiom
   :vars (?gp - GeopoliticalArea
	  ?p - PortFacility)
   :context (hasPort ?gp ?p)
   :implies (hasTransitTerminal ?gp ?p)
   :comment "hasPort subPropertyOf hasTransitTerminal")
  )

;; convention: ?td for Vehicle, ?start ?dest for locations so duration fcns work

(define (durative-action "Load Ship")
    :parameters (?cargo - PhysicalEntity
		 ?td - WaterVehicle)
    :vars (?td-loc - (located ?cargo)
		   ;;?capacity - (fuelCapacity ?td)
		   )
    :condition (and (at start (instance ?td-loc PortFacility))
		    (at start (located ?td ?td-loc))
		    ;;(appropriate-conveyance-p ?td ?cargo)
		    )
    :effect (and (at end (contains ?td ?cargo))
		 ;;(at end (hasFuel ?td ?capacity))
		 )			; fill 'er up
    :probability 0.99
    :duration 6.0)

(define (action SailCargoToPort)
    :parameters (?td - WaterVehicle
		 ?dest - Country)
    :vars (?p - PortFacility
	   ?c - (contains ?td))
    :precondition (and (contains ?td ?c)
		       (hasPort ?dest ?p)
		       (not (located ?td ?dest))
		       (not (= ?c nothing)))
    :expansion (series
		(located ?td ?p)
		(not (contains ?td ?c)))
    :effect (located ?td ?dest))

;; took out (located ?td ?start) preconditions to prevent
;; actions being selected as counterplans in nuclear_weapon.pddl

(define (durative-action Sail)
    :parameters (?td - WaterVehicle
		 ?dest - WaterArea)
    :vars (?start - (located ?td))
    :precondition (and ;;(located ?td ?start)
		       (connected ?start ?dest))
    :effect (located ?td ?dest)
    :probability 0.99
    :duration 2.0)

(define (action Multi_leg_sail)
    parameters (?td - WaterVehicle
		 ?dest - WaterArea)
    :vars (?start - (located ?td)
	   ?ww - WaterArea)
    :precondition (and ;;(located ?td ?start)
		       (not (connected ?start ?dest))
		       (not (= ?start ?dest)))
    :expansion (series
		(forall (?mid - (water-route ?start ?dest))
			(located ?td ?mid)))
    :effect (located ?td ?dest))

(define (durative-action "Unload At Port")
    :parameters (?td - WaterVehicle
		 ?cargo - PhysicalEntity)
    :vars (?dest - (located ?td))
    :condition (and (at start (contains ?td ?cargo))
		    (over all (located ?td ?dest))
		    (instance ?dest PortFacility))
    :effect (at end (not (contains ?td ?cargo)))
    :probability 0.9
    :duration 3.0)
