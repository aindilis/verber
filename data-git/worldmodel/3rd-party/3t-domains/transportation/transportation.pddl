(in-package :AP)

;;; time in hours, distance in KM

(define (domain transportation)
  (:extends event physob Geography)
  (:requirements :durative-actions)
  (:types TransportationFacility - (and Facility Location)
	  TransitTerminal - TransportationFacility
	  TransitWay - Path
	  LandTransitWay - TransitWay
	  Road - LandTransitWay
	  ;;--things that are transported
	  Cargo - Resource
	  Passengers - (and ArbitraryGroupOfPeople Resource)
	  ;;--things that transport
	  Vehicle - (and MobileArtifact TransportationDevice NonConsumableResource)
	  CargoVehicle PassengerVehicle CommercialVehicle EmergencyVehicle 
	  MilitaryVehicle AutonomousVehicle - Vehicle
	  ArmoredVehicle - MilitaryVehicle
	  ContractCarrier CommonCarrier - CommercialVehicle)
  (:predicates
   (transport ?t - Thing ?from ?to - SpatialThing)
   (hasTransitTerminal ?c - GeopoliticalArea ?tt - TransitTerminal))
  (:functions
   (maxSpeed - fact ?td - TransportationDevice)
   (capacity - fact ?td - TransportationDevice)
   (fuelCapacity - fact ?td - TransportationDevice)
   (hasFuel ?td - TransportationDevice)
   (heading ?td - TransportationDevice) - Direction)
  (:axiom
   :vars (?td - TransportationDevice)
   :implies (contains ?td nothing))
  (:axiom
   :vars (?td - TransportationDevice
	  ?object - PhysicalEntity
 	  ?dest - Location)
    :context (and (located ?td ?dest)
		  (contains ?td ?object)
		  (not (= ?object nothing)))
    :implies (located ?object ?dest)
    :comment "if you move a container, you move whatever is in it")
  (:axiom
   :vars (?l1 ?l2 ?l3 - GeographicArea)
   :context (and (distance ?l1 ?l2)
		 (geographicSubregionOf ?l3 ?l2))
   :implies (distance ?l1 ?l3))
  )

(compile-file "ap:domains;transportation;relation-funs.lisp" :if-newer t :verbose nil)
(load "ap:domains;transportation;relation-funs.fasl" :verbose nil :print nil)

;;;===== things other than, or more general than LandVehicles ========

;; convention: ?td for Vehicle, ?start ?dest for locations so duration fcns work

(define (durative-action Transport)
    :parameters (?cargo - PhysicalEntity
		 ?dest - Location)
    :vars (?start - (located ?cargo)
		  ?td - TransportationDevice
		  ?tt - (hasTransitTerminal ?start))
    :condition (not (instance ?cargo TransportationDevice))
    :expansion (series
		(located ?td ?tt)
		(contains ?td ?cargo)
		(located ?td ?dest))	; axiom will move ?cargo
    :effect (transport ?cargo ?start ?dest) 
    :duration transport-duration	; function call
    :comment "?td has to be big enough to pick up ?cargo")

;;;-- contains: putting things in TransportationDevices ---

(define (durative-action Load)
    :parameters (?cargo - Cargo
		 ?td - TransportationDevice)
    :vars (?cargo-loc - (located ?cargo))
    :condition (and (over all (located ?td ?cargo-loc))
		    (>= (capacity ?td)(size ?cargo))
		    (not (= ?cargo ?td)))
    :effect (at end (contains ?td ?cargo))
    :duration 1.0)

(define (durative-action Move)
    :parameters (?td - TransportationDevice
		 ?dest - Location)
    :vars (?start - (located ?td))
    :condition (and (at start (located ?td ?start))
                    (at start (connected ?start ?dest))
		    (at start (> (hasFuel ?td) 0)))
    :effect (and (at end (not (located ?td ?start)))
		 (at end (located ?td ?dest))
		 (at end (decrease (hasFuel ?td) 5)))
    :duration (move-duration ?td ?start ?dest))

(define (durative-action Unload)
    :parameters (?td - TransportationDevice
		 ?cargo - Cargo)
    :vars (?loc - (located ?td))
    :condition (and (instance ?loc TransitTerminal)
		    (at start (contains ?td ?cargo)))
    :effect (at end (not (contains ?td ?cargo)))
    :duration 0.5)

;;;-- other leaf-level actions -

(define (durative-action Refuel)
    :parameters (?td - TransportationDevice)
    :vars (?max - (fuelCapacity ?td))
    :condition (< (hasFuel ?td) ?max)
    :effect (at end (assign (hasFuel ?td) ?max))
    :duration refuel-duration)		; function call


