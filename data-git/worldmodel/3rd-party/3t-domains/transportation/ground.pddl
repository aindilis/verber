(in-package :ap)

(define (domain ground)
  (:extends transportation)
  (:requirements :durative-actions)
  (:types GasStation - (and TransportationFacility CommercialFacility Point)
	  Garage BusStop MetroStation TrainStation - (and TransitTerminal Point)
	  Bridge - LandTransitWay
	  PavedRoad UnpavedRoad - Road
	  DividedHighway - PavedRoad
	  ;; vehicles
	  LandVehicle - TransportationDevice
	  WheeledVehicle TrackedVehicle Train -  LandVehicle
	  Bicycle Bus Motorcycle Automobile - WheeledVehicle
	  Truck - (and WheeledVehicle CargoVehicle)
	  TankerTruck - Truck
	  )
  (:predicates 
   (onRoad - fact ?loc - Location ?r - Road)
   (occupied ?p - Point)	; multi-value because more than one can be occupied
   ;; goal for variation on get-directions, traverse-path
   (approach ?td - TransportationDevice ?destination - Location ?heading - Direction))
  (:functions
   (speedLimit - fact ?r - Road)
   (roadLength - fact ?r - Road))   
;   (:defaults
;     (speedLimit DividedHighway 100)	; km/h
;     (speedLimit UnpavedRoad 20)
;     (speedLimit Road 50)
;     (maxSpeed LandVehicle 100)
;     (maxSpeed TrackedVehicle 40)	; km/h
;     (capacity Automobile 500)		; kilos
;     (capacity Truck 1000)
;     (capacity Motorcycle 100)
;     (fuelCapacity Automobile 15)	; gallons
;     (fuelCapacity Truck 30)
;     (fuelCapacity Motorcycle 2)
;     (hasFuel Automobile 15)		; full tank
;     (hasFuel Truck 30)
;     (hasFuel Motorcycle 2)
;     )
  (:axiom
   :vars (?start ?end - Location
	  ?road - Road
	  ?length - (roadLength ?road))
   :context (and (connects ?road ?start ?end)
		 (roadLength ?road ?length)
		 (not (= ?start ?end)))
   :implies (distance ?start ?end ?length))
  (:axiom 
   :vars (?road - Road
	  ?loc - Location)
   :context (connects ?road ?loc :ignore)
   :implies (onRoad ?loc ?road)
   :comment "see function connecting-road")
  )


(compile-file "ap:domains;transportation;ground-funs.lisp" :if-newer t)
(load "ap:domains;transportation;ground-funs.fasl")

;; convention: ?td for Vehicle, ?start ?dest for locations so duration fcns work

(define (durative-action Drive)
    :parameters (?td - LandVehicle
		 ?dest - Location)
    :vars (?start - (located ?td)
	   ?heading - (get-direction ?start ?dest) ; only if same road
	   )	 
    :condition (and (at start (located ?td ?start))
                    (at start (heading ?td ?heading))
		    (over all (> (hasFuel ?td) 5)))
    :effect (and (over all (heading ?td ?heading))
		 (at end (not (located ?td ?start)))
		 (at end (located ?td ?dest))
		 (at end (decrease (hasFuel ?td) 5)))
    :duration (drive-time ?start ?dest)
    :execute (exec-sim-command *current-action*)) ;robot can't execute

;;;--- moving from route to route --

(define (durative-action approach-heading)
    :subClassOf Drive
    :parameters (?td - LandVehicle
		 ?destination - Location
		 ?heading - Direction)
    :vars (?start - (located ?td)
	   ?route - (google-routes ?start ?destination ?heading))
    :expansion (series 
		(forall (?intersection - ?route)
			(located ?td ?intersection)))
    :effect (approach ?td ?destination ?heading)
    :duration (route-time ?start ?route)
    :comment "arrivve at ?destination going in given ?heading")

(define (durative-action drive-heading)
    :subClassOf Drive
    :parameters (?td - LandVehicle
		     ?destination - Location
		     ?heading - Direction)
    :vars (?start - (located ?td)
	   ?direction - (get-direction ?start ?destination))
    :precondition (= ?heading ?direction)
    :expansion (located ?td ?destination)
    :effect (approach ?td ?destination ?heading)
    :duration (drive-time ?start ?destination)
    :comment "straight shot in correct heading to an intersection")

(define (durative-action "Drive Route")
    :subClassOf Drive
    :parameters (?td - LandVehicle
		 ?destination - Location)
    :vars (?start - (located ?td)
	   ?route - (google-routes ?start ?destination))
    :precondition (not (connected ?start ?destination))
    :expansion (series 
		(forall (?intersection - ?route)
			(located ?td ?intersection)))
    :effect (located ?td ?destination)
    :duration (route-time ?start ?route)
    :comment "Like Google Maps")

;; leaf-level movement 

(define (durative-action Turn)
    :subClassOf Drive
    :parameters (?td - LandVehicle
		 ?new - Direction)
    :vars (?current - (heading ?td))
    :condition (and (at start (heading ?td ?current))
		    (not (= ?new ?current)))
    :effect (at end (heading ?td ?new))
    :execute (exec-sim-command *current-action*))


(define (durative-action "Round Bend")
    :subClassOf Turn
    :parameters (?td - LandVehicle
		 ?dest - Location)
    :vars (?start - (located ?td)
	   ?direction - (get-direction ?start ?dest))
    :precondition (not (heading ?td ?direction))
    :expansion (series
		(heading ?td ?direction)
		(located ?td ?dest))
    :effect (located ?td ?dest)
    :duration (drive-time ?start ?dest)
    )
