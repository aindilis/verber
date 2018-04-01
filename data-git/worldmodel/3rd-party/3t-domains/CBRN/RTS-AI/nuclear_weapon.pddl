(in-package :ap)

(define (domain nuclear_weapon)
    (:extends threat-behaviors nuclear)
  (:requirements :durative-actions :domain-axioms)
  (:time-unit week)
  (:types ReEntryCapability - WeaponComponent
	  THAAD - MissileDefenseSystem
	  EnrichedUranium - ControlledSubstance
	  NuclearTestFacility - (and GeographicArea MilitaryFacility)
	  UndergroundFacility - NuclearTestFacility
	  UndergroundTestSite - UndergroundFacility)
  (:objects NuclearAttackCapability BreakoutCapability - Thing) ; for hasIntent
  (:predicates
   (hasBreakoutCapability ?c - Nation)
   (hasNuclearAttackCapability ?c - Nation)
   (miniaturize ?c - Agent ?w - NuclearWeapon)
   (test ?c - Agent ?o - Thing)
   (canDeliverTo ?c - Agent ?w - Weapon ?ga - GeographicArea)
   )
  (:functions
   (builtAndTested ?a - Country ?w - NuclearWeapon)
   (numBuilt ?a - Country ?w - NuclearWeapon)
   (numTests ?a - Country ?w - NuclearWeapon)
   )
  (:init
   (requiredEquipment NuclearWeapon NucRelatedEquipment)
   (weaponDeliveryMeans NuclearWeapon ICBM)
   (weaponDeliveryMeans NuclearWeapon Airplane)
   (weaponDeliveryMeans ImplosionWeapon ICBM)
   (weaponDeliveryMeans ImplosionWeapon Airplane)
   (weaponDeliveryMeans GunTypeWeapon Airplane)
   (hasWeaponComponent ICBM WeaponGuidance)
   (hasWeaponComponent ICBM Rocket)
   (hasWeaponComponent ICBM ReEntryCapability)
   )
  (:axiom
   :vars (?a - Agent
	     ?o - PhysicalEntity)
   :context (produce ?a ?o)
   :implies (possesses ?a ?o))
  )

(remove-action 'Obtain)

(define (action "Nuclear Weapon Program")
    :parameters (?n - Nation)
    :precondition (hasIntent ?n NuclearAttackCapability)
    :expansion (series
		(parallel
		 (hasBreakoutCapability ?n)
		 (produce ?n ICBM))
		(link (acquire ?n NuclearWeapon) :output ?nw)
		(test ?n ?nw)
		(miniaturize ?n ?nw))
    :effect (hasNuclearAttackCapability ?n))

;;;--- subprocesses --

(define (durative-action "Breakout Capability")
    :parameters (?n - Nation)
    :condition (over all (hasIntent ?n BreakoutCapability))
    :expansion (covers-start
		(hasFinancialResources ?n)
		(parallel
		 (conductResearch ?n NuclearWeapon)
		 (hasLogisticalResources ?n NuclearWeapon)))
    :effect (at end (hasBreakoutCapability ?n)))

(define (action "Conduct Research")
    :label ("Conduct" ?pe "Research")
    :subClassOf Study
    :parameters (?a - Agent
		 ?pe - PhysicalEntity)
    ;;:precondition (hasFinancialResources ?a ?pe)
    :expansion (series
		(hasSomeKnowledgeOf ?a ?pe)
		(performR&D ?a ?pe))
    :effect (conductResearch ?a ?pe)
    :probability 0.98)

(define (action "Develop Experts")
    :label ("Develop" ?pe "Experts")
    :subClassOf Command
    :parameters (?a - Country
		 ?pe - PhysicalEntity)
    :effect (hasSomeKnowledgeOf ?a ?pe)
    :probability 0.95
    :duration 30.0
    :documentation "takes a long time, but will probably succeed")

(define (action "Recruit Experts")
    :label ("Recruit" ?pe "Experts")
    :subClassOf Persuade
    :parameters (?a - Country
		 ?pe - PhysicalEntity)
    :effect (hasSomeKnowledgeOf ?a ?pe)
    :probability 0.7
    :duration 18.0
    :documentation "faster, but less likely to succeed")

(define (action "Kidnap Experts")
    :label ("Kidnap" ?w "Experts")
    :subClassOf Command
    :parameters (?a - RogueState
		 ?w - Weapon)
    :effect (hasSomeKnowledgeOf ?a ?w)
    :probability 0.3
    :duration 10.0
    :documentation "precondition: bat-shit crazy")

(define (action "Perform R&D")
    :label ("Perform" ?pe "R&D")
    :subClassOf Research
    :parameters (?a - Agent
		 ?pe - PhysicalEntity)
    :precondition (hasSomeKnowledgeOf ?a ?pe)
    :effect (and (performR&D ?a ?pe)
		 (increase (hasKnowledgeAbout ?a ?pe) 1))
    :duration 24.0
    :probability 0.8)

;;; mininig, milling, manufacturing - all the IAEA stuff
(define (durative-action "Develop Logistical Resources")
    :subClassOf Grow
    :parameters (?a - Agent
		 ?w - NuclearWeapon)
    :condition (at start (hasFinancialResources ?a))
    :expansion (possesses ?a NucRelatedEquipment)
    :effect (and (hasLogisticalResources ?a ?w)
		 (possessesEquipment ?a ?w))
    :probability 0.95
    :duration 60.0)

;;;=== now for the nasty and hard parts ===

(define (action "Develop Nuclear Weapon")
    :parameters (?n - Nation)
    :vars (?fm - FissileMaterial
	   ?nw - NuclearWeapon)
    :value ?nw
    :precondition (hasBreakoutCapability ?n)
    :expansion (series
		(link (obtainFissileMaterial ?n) :output ?fm)
		(link (produce ?n NuclearWeapon) :input ?fm :output ?nw))
    :effect (acquire ?n NuclearWeapon))

;;;--- Nuke materials ---

;;; this does not get in plan when :expansion included
;;;  but causes stupid countergoals when it is not 12/3/2016
(define (action "Import HEU")
    :subClassOf Purchase
    :parameters (?a - Agent)
    :vars (?seller - Nation)
    :precondition (and (hasFinancialResources ?a)
		       (not (partyTo ?seller NNPT))
		       (not (hasAdversary ?a ?seller))
		       (possesses ?seller HighlyEnrichedUranium)
		       (not (= ?a ?seller)))
    :value HighlyEnrichedUranium
    ;;:expansion (link (purchased ?a HighlyEnrichedUranium) :input ?seller)
    :expansion (series
		(transferFunds ?a ?seller Money)
		;;(transport ?seller HighlyEnrichedUranium ?a)
		)
    :effect (and (obtainFissileMaterial ?a)
		 (possesses ?a HighlyEnrichedUranium))
    :duration 10.0
    :probability 0.9)

;;;--- build

(defun build-probability (?a ?w)
  (let ((times (get-value 'numBuilt ?a ?w)))
    (case times
      (0 0.5)
      (1 0.7)
      (otherwise
       0.95))))

(define (action "Build Implosion Weapon")
    :subClassOf Military
    :parameters (?a - Agent)
    :vars (?fm - FissileMaterial)	; Pu or HEU
    :input ?fm				; optional, if provided
    :output ImplosionWeapon
    :precondition (and (performR&D ?a NuclearWeapon)
		       (possesses ?a NucRelatedEquipment)
		       (possesses ?a ?fm))
    :effect (and (produce ?a ImplosionWeapon)
		 (produce ?a NuclearWeapon)
		 (hasCapability ?a ImplosionWeapon)
		 (increase (numBuilt ?a ImplosionWeapon) 1)
		 (not (test ?a ImplosionWeapon))) ; not yet anyway
    ;;:probability (build-probability ?a ImplosionWeapon)
    :duration 60.0)

;;;--- test the weapon --

(define (action "Test Nuclear Weapon")
    :subClassOf Military
    :parameters (?a - Agent
		    ?w - NuclearWeapon)
    :vars (?tf - NuclearTestFacility)
    :precondition (and (possesses ?a ?w)
		       (hasAccessTo ?a ?tf))
    :value ?tf
    :effect (and (test ?a ?w)
		 ;;(increase (numTests ?a ?w) 1)
		 ;;(not (produce ?a ?w))
		 ;;(not (possesses ?a ?w))
		 )			; destroyed it, eh?
    :probability 0.9
    :duration 10.0)			; weeks

;;;--- weapon delivery ---
#|
(define (action "Prepare Delivery")
    :parameters (?a - Agent
		 ?w - NuclearWeapon) 
    :vars (?carrier - (weaponDeliveryMeans ?w))
    :expansion (parallel
		(miniaturize ?a ?w)
		(produce ?a ?carrier))
    :effect (prepareForDelivery ?a ?w))
|#

(define (action "Miniaturize Nuclear Weapon")
    :subClassOf Military
    :parameters (?a - Agent
		    ?w - NuclearWeapon)
    :vars (?num-so-far - (builtAndTested ?a ?w))
    :precondition (and (possesses ?a ?w)
		       (possesses ?a NucRelatedEquipment)
		       (< ?num-so-far 5))
#|    :expansion (series
		(forall (?k - (seq (1+ ?num-so-far) 5))
			(builtAndTested ?a ?w ?k))
		(produce ?a ?w))|#		; make a new one
    :effect (miniaturize ?a ?w)
    :probability 0.8
    :duration 52.0
    :documentation "took US, USSR, UK, France, & China 4 tries")

(define (action "Build & Test Nuclear Weapon")
    :parameters (?a - Agent
		    ?w - NuclearWeapon
		    ?k - Number)
    :vars (?n - (builtAndTested ?a ?w))
    :precondition (< ?n ?k)		       
    :expansion (series
		(produce ?a ?w)
		(test ?a ?w))
    :effect (builtAndTested ?a ?w ?k))

;;;--- delivery 

(define (action "Develop Delivery System")
    :subClassOf Develop
    :parameters (?a - Agent
		 ?m - Missile)
    :expansion (series
		(parallel
		 (forall (?c - (hasWeaponComponent ?m))
			 (buildAndTest ?a ?c)))
		(buildAndTest ?a ?m))
    :effect (produce ?a ?m))

(define (action "Build & Test")
    :subClassOf Manufacture
    :parameters (?a - Agent
		 ?c - WeaponComponent)
    :effect (and (buildAndTest ?a ?c)
		 (possessesEquipment ?a ?c))
    :probability 0.98
    :duration 12.0)

(define (action "Assemble Missile")
    :subClassOf Develop
    :parameters (?a - Agent
		 ?m - Missile)
    :precondition (and
		   (forall (?c - (hasWeaponComponent ?m))
			   (possessesEquipment ?a ?c)))
    :effect (buildAndTest ?a ?m)
    :probability 0.99
    :duration 12.0)

;;;=== counterplans ===

(define (action "Cyber Attack")
    :subClassOf Disinformation
    :parameters (?a - Agent)
    :precondition (possesses ?a GasCentrefuge)
    :effect (not (possesses ?a GasCentrefuge))
    ;;(decrease (hasCentrefuges ?a) 1000)
    :duration 10.0
    :probability 0.1)

(define (action "Destroy Facility")
    :subClassOf Destruct
    :parameters (?a - Agent
		 ?f - Facility)
    :precondition (not (instance ?f UndergroundFacility))
    :effect (not (hasAccessTo ?a ?f))
    :duration 8.0
    :probability 0.4)

(define (action "Destroy Underground Facility")
    :subClassOf Destruct
    :parameters (?a - Agent
		 ?f - UndergroundFacility)
    :vars (?planner - (hasAdversary ?a))
    :precondition (possesses ?planner NuclearWeapon)
    :effect (not (hasAccessTo ?a ?f))
    :duration 8.0
    :probability 0.4)



#|
(define (action Build_GunTypeWeapon)
    :parameters (?a - Agent)
    :vars (?fm - FissileMaterial)	; Pu or HEU
    :value ?fm
    :precondition (and (performR&D ?a NuclearWeapon)
		       (possesses ?a ?fm)
		       (not (possesses ?a GunTypeWeapon)))
    :effect (and (produce ?a GunTypeWeapon)
		 (produce ?a NuclearWeapon)
		 (hasCapability ?a GunTypeWeapon))
    :probability 0.8
    :duration 60.0)

(define (action BuildMissileDefense)
    :subClassOf Defend
    :parameters (?a - Nation
		  ?w - NuclearWeapon)
    :precondition (weaponDeliveryMeans ?w ICBM)
    :effect (not (canDeliver ?a ?w))
    :duration 78.0			; year and a half to build
    )
|#
