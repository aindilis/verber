(in-package :AP)

;(compile-file "ap:domains;terrorism;relation-funs" :load-after-compile t)

;;; DANGER!
;;;  - attend to the difference between "location" for stationary things like
;;;    buildings and ports of entry and "located" for movable things like
;;;    people and transportation devices.
;;;  - besure to use :value consistently for all actions that have 
;;;    similar :effect propostion relations.

(define (domain terrorist)
    (:extends organizations commerce transportation weapon)
  (:prefix "event")
  (:requirements :durative-actions)
  (:types ;;Visa - Document
	  ;; orgainization
	  TerroristGroup - Organization
	  ForeignTerroristOrganization
	  DomesticTerroristOrganization - TerroristGroup
	  ;;-terrorist domain specifics
#|	  Target - location
	  IconicTarget SoftTarget hardTarget - Target
	  ExplosiveMaterial - Substance
	  ImprovisedExplosive ManufacturedExplosive - ExplosiveMaterial
	  DispersalDevice - Tangible
	  Bomb "Biological Weapon" - Weapon
	  IED - Bomb
	  VBIED - (and IED TransportationDevice) |#
	  )
  (:predicates 
   ;;(observe ?p - resource ?t - Target)
   ;;(gainAccess ?e - resource ?ga - GeopoliticalArea)
   (agentOperatesInArea ?veo - TerroristGroup ?ga - GeographicArea)
   ;;(createWeapon ?veo - TerroristGroup ?t - Target)
   ;;--attack
   ;;(destroy ?e - resource ?t - Target)
   ;;(deportedFrom ?p - Person ?n - Nation)
   )
#|  (:defaults
      (size Weapon 1)
      (size ExplosiveMaterial 1))|#
  (:constants    ;; these should be in the appropriate situation
   Pakistan Afganistan Somolia Lebanon Syria Israel Iraq Yeman India USA - Nation
   Lashkar-e-Taiba al-Qaeda Hezbolla AQAP AQI
   Tehrik-i-Taliban - ForeignTerroristOrganization)
  (:init
   (agentOperatesInArea Lashkar-e-Taiba Pakistan)
   (agentOperatesInArea Lashkar-e-Taiba India)
   (agentOperatesInArea al-Qaeda Pakistan)
   (agentOperatesInArea al-Qaeda Afganistan)
   (agentOperatesInArea al-Qaeda Somolia)
   (agentOperatesInArea AQI Iraq)
   (agentOperatesInArea Hezbolla Iraq)
   (agentOperatesInArea Hezbolla Syria)
   (agentOperatesInArea Tehrik-i-Taliban Afganistan)
   (agentOperatesInArea Tehrik-i-Taliban Pakistan))
  (:comment "based on Terrorists.kif from Teknowledge."))

(owl:Restriction 'agentOperatesInArea 'owl:cardinality :multi-value)

#|
;;;=== IED ====

(define (durative-action VBIED)
    :parameters (?veo - TerroristGroup
		 ?target - Target)
    :vars (?Weapon - TransportationDevice)
    :expansion (series
		(parallel
		 (link (createWeapon ?veo ?target) :output ?Weapon)
		 (observe ?veo ?target))
		(located ?Weapon ?target))
    :effect (destroy ?veo ?target))

;;;--- createWeapon, value = Weapon --------

(define (durative-action "Create Land VBIED")
    :parameters (?veo - TerroristGroup
		 ?target -  StationaryArtifact)
    :vars (?proximity - (get-value located ?target)
	   ?explosive - ExplosiveMaterial
	   ?p - Person)
    :value (?lv - LandVehicle)
    :expansion (series
		(link (agentOperatesInArea ?veo ?proximity) :output ?p)
		(parallel
		 (link (possesses ?veo ?lv) :input ?p)
		 (possesses ?veo ?explosive))
		(contains ?lv ?explosive))
    :effect (createWeapon ?veo ?target))

(define (durative-action create_backpack_Bomb)
    :parameters (?veo - Organization
		 ?target - TransitTerminal)
    :value (?explosive - ExplosiveMaterial)
    :precondition (and (size ?explosive 1)
		       (possesses ?veo ?explosive))
    :effect (createWeapon ?veo ?target))

;;;--- agentOperatesInArea, value = Person ---

(define (durative-action "Legitimate Travel")
    :parameters (?org - Organization
		 ?dest - City)
    :vars (?n_dest - Nation		
		   ?poe - PortOfEntry)
    :value (?p - ForeignNational)
    :precondition (and (occupiesPosition ?p Member ?org)
		       (geographicSubregion ?dest ?n_dest)
		       (located ?poe ?dest))
    :expansion (series
		(located ?p ?poe)
		(link (gainAccess ?p ?n_dest) :input ?poe))
    :effect (agentOperatesInArea ?org ?dest)
    :duration 8.0
    :probability 0.9
    :comment "deplaining detectable")

(define (durative-action Infiltrate)
    :parameters (?org - TerroristGroup
		 ?dest - City)
    :vars (?n_start ?n_dest - Nation
		    ?poe - BorderCrossing)
    :value (?p - ForeignNational)
    :precondition (and (occupiesPosition ?p Member ?org)
		       (geographicSubregion ?dest ?n_dest)
		       (meetsSpatially ?n_start ?n_dest)
		      ; (geographicSubregion (located ?poe) ?n_dest)
		       ;(geographicSubregion ?poe_loc ?n_dest)
		       ;(geographicSubregion ?start ?n_start)
		       (geographicSubregion (located ?p) ?n_start))
    :expansion (series 
		(located ?p ?poe)
		(link (gainAccess ?p ?n_dest) :input ?poe)
		(located ?p ?dest))
    :effect (agentOperatesInArea ?org ?dest)
    :probability 0.7
    :duration 8.0)

;;;--- gainAccess, value = port_of_entry ---

(define (durative-action "pass Customs")
    :parameters (?p - Person
		 ?n - Nation)
    :vars (?c - city)
    :value (?poe - PortOfEntry)
    :precondition (and (located ?p ?poe)
		       (located ?poe ?c)
		       (possesses ?p Visa)
		       (geographicSubregion ?c ?n)
		       (not (deportedFrom ?p ?n)))
    :effect (gainAccess ?p ?n)
    :duration 1.0
    :probability 0.8)

(define (durative-action "Illegal Entry")
    :parameters (?p - Person
		 ?n - Nation)
    :value (?poe - BorderCrossing)
    :precondition (and (located ?p ?poe)
		       (geographicSubregion (located ?poe) ?n))
    :effect (gainAccess ?p ?n)
    :duration 2.0
    :probability 0.5)

;;;==== observe =======

(define (durative-action Reconnoiter)
    :parameters (?p - Person
		 ?o - StationaryArtifact)
    :vars (?where - (get-value located ?o))
    :precondition (located ?p ?where)
    :effect (observe ?p ?o)
    :duration 1.0)

(define (durative-action Move_&_Reconnoiter)
    :parameters (?p - Person
		 ?o - StationaryArtifact)
    :vars (?where - (get-value located ?o))
    :precondition (not (located ?p ?where))
    :expansion (series
		(located ?p ?where)
		(observe ?p ?o))
    :effect (observe ?p ?o)
    :duration 1.0)

;;;===== possesses: obtain ?stuff ======

(define (durative-action obtain_transport)
    :parameters (?o - Organization
		 ?td - TransportationDevice)
    :vars (?c - (get-value located ?td))
    :value (?p - Person)
    :precondition (occupiesPosition ?p Member ?o)
    :expansion (series 
		(located ?p ?c)
		(possesses ?p ?td))
    :effect (possesses ?o ?td)
    :comment "go get it")

;;;---- situations and problems

(define (situation two_agents)
    (:immediately-after simple_world)
  (:objects Kalid Hani - ForeignNational
	    AirCanada109 KLM865 - Airliner)
  (:init
   (possesses al-Qaeda money)
   (possesses Hani money)
   (possesses Kalid money)
   (located Hani Winsor)
   (deportedFrom Hani USA)
   (occupiesPosition Hani Member al-Qaeda)
   (located Kalid Toronto)
   (possesses Kalid Visa)
   (occupiesPosition Kalid Member al-Qaeda)
   (located AirCanada109 TPI))
  (:comment "pull out to test plan-recognition"))

(define (problem get_agent_in)
    (:situation two_agents)
  (:goal (agentOperatesInArea al-Qaeda Chicago)))

(define (problem attack_in_Chicago)
    (:situation two_agents)
  (:objects U-haul_C - rental_truck
	    ANFO_C - ANFO)
  (:init (located U-haul_C Chicago)
	 (located ANFO_C Chicago))
  (:goal (destroy al-Qaeda searsTower))
  (:deadline 360.0))

(define (problem attack_in_Northcentral)
    (:situation two_agents)
  (:objects U-haul_C U-haul_D - rental_truck
	    ANFO_C ANFO_D - ANFO)
  (:init (located U-haul_C Chicago)
	 (located U-Haul_D Detroit)
	 (located ANFO_D Detroit)
	 (located ANFO_C Chicago))
  (:goal (either (destroy al-Qaeda SearsTower)
		 (destroy al-Qaeda Ren_Center)))
  (:deadline 360.0))
|#
