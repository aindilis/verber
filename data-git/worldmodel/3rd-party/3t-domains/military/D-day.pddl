(in-package :AP)

(define (domain D-day)
    (:extends water weapon)
  (:requirements :true-negation)
  (:types Belligerent - Agent
	  MilitaryCommand - MilitaryOrganization
	  Troopship - PassengerShip
	  Mulberry - ArtificialHarbor
	  POL - (and Cargo Fuel))
  (:predicates
   (establishBeachHead ?a - MilitaryCommand ?l - Beach)
   (beachLanding ?a - MilitaryOrganization ?b - Beach)
   (invade ?a - Agent ?l - Location))
  (:axiom
   :vars (?p - Passengers)
   :implies (size ?p 200))
  (:axiom
   :vars (?f - Fuel)
   :implies (size ?f 50))
  (:axiom
   :vars (?w - Waterway
	     ?gp1 ?gp2 - GeopoliticalArea
	     ?b - Beach)
   :context (and (connectedBy ?gp1 ?gp2 ?w)
		 (geographicSubregionOf ?b ?gp2))
   :implies (connectedBy ?gp1 ?b ?w)
   :documentation "tedious to list all the beaches")
  (:axiom
   :vars (?w - Waterway
	     ?gp1 ?gp2 - GeopoliticalArea
	     ?b - Beach
	     ?n - (distance ?gp1 ?gp2))
   :context (and (connectedBy ?gp1 ?gp2 ?w)
		 (connectedBy ?gp1 ?b ?w))
   :implies (distance ?gp1 ?b ?n)
   :documentation "tedious to list all the beaches")
  )

;;; need Invade, Defend, Prepare Invasion knowsAbout Deception

(define (action Invade_Country)
    :parameters (?b - MilitaryCommand
		 ?c - StateOrProvince)
    :vars (?c - City
	   ?army - MilitaryCommand)
    :precondition (and (geographicSubregionOf ?s ?c)
		       (subOrganizationOf ?army ?b))
    :expansion (invade ?army ?s)
    :effect (invade ?b ?c))


(define (durative-action Invade_at_Port_City)
    :parameters (?command - MilitaryCommand 
		 ?c - City)
    :vars (?city - (geographicSubregionOf ?beach))
    :condition (at start (hasPort ?c))
    :expansion (concurrent		; must have this
		(forall (?sub - (hasSubOrganization ?command))
			(beachLanding ?sub ?beach)))
    :effect (at end (establishBeachHead ?command ?beach)))

(define (durative-action Invade_City)
    :parameters (?troops - MilitaryOrganization
		 ?dest - City)
    :vars (?start - (located ?troops)
		  ?td - Troopship)
    :condition (and (over all (hasPort ?dest) )
		    (at start (located ?td ?start)))
    :expansion (series
		(contains ?td ?troops)
		(located ?td ?dest)
		(not (contains ?td ?troops)))
    :effect (at end (invade ?troops ?dest)))

;;;--- establishBeachHead ---

(define (durative-action EstablishBeachHead)
    :parameters (?command - MilitaryCommand ; VCorps
		 ?beach - Beach)
    :vars (?where - (geographicSubregionOf ?beach))
    :condition (at start (not (hasPort ?where))) ; why do it otherwise?
    :expansion (concurrent		; must have this
		(forall (?sub - (hasSubOrganization ?command))
			(beachLanding ?sub ?beach)))
    :effect (at end (establishBeachHead ?command ?beach)))

(define (durative-action BeachLanding)
    :parameters (?unit - MilitaryOrganization
		 ?beach - Beach)
    :vars (?start - (located ?unit)
	   ?where - (geographicSubregionOf ?beach)
	   ?td - Troopship)
    :condition (and (at start (located ?td ?start))
		    (at start (not (hasPort ?where)))) ; why do it otherwise?
    :expansion (series
		(contains ?td ?unit)
		(located ?td ?beach)
		(not (contains ?td ?unit)))
    :effect (at end (beachLanding ?unit ?beach)))

(define (durative-action Come_Ashore)
    :parameters (?td - Troopship
		     ?unit - MilitaryOrganization)
    :vars (?beach - Beach)
    :condition (at start (located ?td ?beach))
    :effect (not (contains ?td ?unit))
    :duration 5.0)

;; need (not (contains ?td ?troops)) on Beach when no port
;; using landing craft
    
(define (durative-action "Construct Artificial Harbor")
    :parameters (?dest - Location)
    :condition (at start (not (hasPort ?dest)))
    :effect (at end (hasPort ?dest))
    :probability 0.7
    :duration 60.0)

;;;-- counterplanning --

#|
(define (durative-action Defend)
    :parameters (?dest - Location)
    :vars (?defender - MilitaryOrganization)
    )
|#

(define (durative-action "Destroy Port")
    :parameters (?dest - Location)
    :condition (at start (hasPort ?dest))
    :effect (at end (not (hasPort ?dest)))
    :probability 0.7
    :duration 2.0)

;;;========= situations, problems ========

(define (situation D_Day_geography)
    (:domain D-day)
  (:objects 
   England France - Country
   Normandy Pas-de-Calais - StateOrProvince
   ;;Grandcamps
   Dover Portsmouth Calais Caen - City
   EnglishChannel - Waterway
   OmahaBeach UtahBeach GoldBeach JunoBeach - Beach
   )
  (:init 
   (geographicSubregionOf Dover England)
   (geographicSubregionOf Portsmouth England)
   (geographicSubregionOf Pas-de-Calais France)
   (geographicSubregionOf Calais Pas-de-Calais)
   (geographicSubregionOf Caen Normandy)
  ;; (geographicSubregionOf Grandcamps Normandy)
   (geographicSubregionOf OmahaBeach Normandy)
   (geographicSubregionOf UtahBeach Normandy)
   (geographicSubregionOf GoldBeach Normandy)
   (geographicSubregionOf JunoBeach Normandy)
   (geographicSubregionOf Normandy France)
   
   (distance Portsmouth Calais 160)
   (distance Portsmouth Normandy 150)
   (distance Portsmouth Dover 110)
   (distance Dover Normandy 80)
   (distance Dover Calais 32)
   (distance Normandy Calais 20)
   (hasPort Dover)
   (hasPort Portsmouth)
   (hasPort Calais)
   (not (hasPort Normandy))
   (connectedBy Dover Normandy EnglishChannel)
   (connectedBy Portsmouth Normandy EnglishChannel)
   (connectedBy Dover Pas-de-Calais EnglishChannel)
   (connectedBy Dover Portsmouth EnglishChannel)
   (connectedBy Portsmouth Pas-de-Calais EnglishChannel)
   (connectedBy Normandy Pas-de-Calais EnglishChannel) ; completeness
   ))

(define (situation German_OB)
    (:domain D-day)
  (:immediately-after D_Day_geography)
  (:objects
   Germany - Belligerent
   7thArmy - MilitaryCommand
   352ndInfantryDivision 716thStaticInfantryDivision
   919thGrenadierRegiment		; Grandcamps Sector - Omaha
   5thPanzerArmy
   21stPanzerDivision			; Caen - Gold, Juno, Sword
   709thStaticInfantryDivision		; Cotentin Peninsula, mainly conscripts
   - MilitaryOrganization
   ArmyGroupB PanzerGroupWest - MilitaryCommand) ; Oberbefehlshaber West
  (:init
   (allegiance 7thArmy Germany)
   (subOrganizationOf 352ndInfantryDivision 7thArmy)
   (located 352ndInfantryDivision Grandcamps)
   (subOrganizationOf 716thStaticInfantryDivision 7thArmy)
   (located 716thStaticInfantryDivision Caen)
   (subOrganizationOf 709thStaticInfantryDivision 7thArmy)
   
   (allegiance 5thPanzerArmy Germany)
   (subOrganizationOf 21stPanzerDivision 5thPanzerArmy)
   (located 21stPanzerDivision Caen)

   (allegiance 919thGrenadierRegiment Germany)
   (located 919thGrenadierRegiment OmahaBeach)
   (allegiance ArmyGroupB Germany) 
   (allegiance PanzerGroupWest Germany)
   )
  )

(define (situation Allied_OB)
    (:domain D-day)
  (:immediately-after D_Day_geography)
  (:objects
   AlliedForces - Belligerent
   VCorps - MilitaryCommand
   1stInfrantyDivision 29thInfrantyDivision ; Omaha
   VIICorps - MilitaryCommand
   4thInfantryDivision			; Utah
   23rdHeadquartersSpecialTroops - MilitaryOrganization ;;(and MilitaryOrganization Passengers)
   USSSamuelChase USSBayfield - Troopship
   Mulberry_A Mulberry_B - Mulberry
   )
  (:init
   (subOrganizationOf VCorps AlliedForces)
   (subOrganizationOf 1stInfrantyDivision VCorps) ; Omaha
   (subOrganizationOf 29thInfrantyDivision VCorps) ; Omaha
   (located 1stInfrantyDivision Dover)
   (located 29thInfrantyDivision Portsmouth)
   (located USSSamuelChase Dover)
   (located USSBayfield Portsmouth)
   
   (subOrganizationOf VIICorps AlliedForces)
   (subOrganizationOf 4thInfantryDivision VIICorps)
   
   (subOrganizationOf 23rdHeadquartersSpecialTroops AlliedForces)
   )
  )

(define (situation 6_June_1944)
    (:immediately-after Allied_OB German_OB)
  )

;;;--- test problems ---

(define (problem Test_Invade)
    (:situation 6_June_1944)
  (:goal (invade AlliedForces France)))

(define (problem Operation_Neptune)
  (:situation 6_June_1944)
  (:goal (invade 29thInfrantyDivision Normandy)))

(define (problem Omaha)
    (:situation Allied_OB)
  (:goal (establishBeachHead VCorps OmahaBeach)))

(define (problem North_option)
    (:situation Allied_OB)
  (:goal (invade VCorps Pas-de-Calais)))


#|
(define (problem Cargo-to-Normandy)
    (:situation D_Day_logistics)
  (:parameters ?cargo - Cargo)
  (:goal (located ?cargo Normandy)))

(define (problem via_Calais)
  (:situation D_Day_logistics)
  (:parameters ?cargo - (either Cargo Passengers))
  (:goal (located ?cargo Calais)))

(define (problem Bodyguard)
    (:requirements :assumptions)
  (:situation D_Day_logistics)
  (:parameters ?cargo - (either Cargo Passengers))
  (:goal (either (located ?cargo Calais)
		 (located ?cargo Normandy))))

(define (problem Bodyguard_light)
    (:requirements :assumptions)
  (:situation D_Day_logistics)
  (:parameters ?fuel - POL)
  (:goal (either (located ?fuel Pas-de-Calais)
		 (located ?fuel Normandy)))
  (:comment "test contingency witout interior choices"))

(define (problem test_geoloc)
    (:situation D_Day_logistics)
  (:parameters ?cargo - (either Cargo Passengers))
  (:constraints (geographicSubregionOf (located ?cargo) England))
  (:goal (located ?cargo Pas-de-Calais))
  (:comment "move cargo in England to Pas-de-Calais"))
|#
;;;--testing assumptions of resources that don't exits
#| does not work. need to fix create-problem-bindings at (assumptions-p problem)
(define (problem Normandy_to_Dover)
    (:requirements :assumptions)
  (:situation D_Day_geography)		; note difference
  (:parameters ?cargo - (either Cargo Passengers))
  (:constraints (located ?cargo Normandy))
  (:goal (located ?cargo Dover))
  (:comment "?cargo is an unknown resource"))
|#