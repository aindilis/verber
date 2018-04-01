(in-package :ap)

(define (domain air)
    (:documentation "air parts of transportation domain")
  (:extends transportation)
  (:requirements :durative-actions)
  (:types AirVehicle - Vehicle
	  Helicopter Airplane - AirVehicle
	  Airliner - (and Airplane PassengerVehicle CommonCarrier)
	  Airport - TransitTerminal
	  NonCommericalAirport - Airport
	  CommercialAirport - (and Airport CommercialFacility)
	  InternationalAirport - CommercialAirport)
  (:axiom
   :vars (?a - AirVehicle)
   :implies (and (capacity ?a 4)
		 (fuelCapacity ?a 500)
		 (hasFuel ?a 500)
		 (maxSpeed ?a 500))
   :comment "default values. Will not overwrite those in a situation")
  )

;; convention: ?td for Vehicle, ?start ?dest for locations so duration fcns work

(define (durative-action Fly)
    :parameters (?td - AirVehicle)
    :vars (?start ?dest - Airport)
    :value ?start
    :precondition (and (located ?td ?start)
		       (> (hasFuel ?td) 100)
		       (not (= ?start ?dest)))
    :effect (and (located ?td ?dest)
		 (decrease (hasFuel ?td) 100))
    :duration fly-duration
    :documentation "got there, doesn't mean you can land")

(define (durative-action Hop)
    :parameters (?td - AirVehicle 
		 ?dest - Airport)
    :vars (?start ?waypoint - Airport)
    :value ?waypoint
    :precondition (and (located ?td ?start)
		       (not (= ?waypoint ?dest))
		       (not (= ?waypoint ?start))
		       (< (get-distance ?start ?waypoint)
			  (get-distance ?start ?dest)))
    :expansion (series
		(located ?td ?waypoint)
		(located ?td ?dest))
    :effect (located ?td ?dest)
    :duration fly-duration
    :documentation "stop to refuel when it is too far to fly non-stop")

(define (durative-action "Load AirVehicle")
    :parameters (?cargo - PhysicalEntity
		 ?td - AirVehicle)
    :vars (?start - Airport)
    :value ?start
    :precondition (and (located ?td ?start)
		       (located ?cargo ?start)
		       (>= (capacity ?td)(size ?cargo)))
    :effect (contains ?td ?cargo)
    :duration 2.0)

(define (durative-action "Board AirVehicle")
    :parameters (?p - Person
		 ?td - AirVehicle)
    :vars (?start - (located ?td))
    :value ?start
    :precondition (located ?p ?start)
    :effect (contains ?td ?p)
    :duration 0.5)

(define (durative-action "Unload Aircraft")
    :parameters (?td - AirVehicle
		 ?cargo - PhysicalEntity)
    :vars (?dest - Airport)   
    :value ?dest
    :precondition (and (contains ?td ?cargo)
		       (located ?td ?dest))
    :effect (not (contains ?td ?cargo))
    :duration 1.0)
