(in-package :ap)

(define (domain bio)
  (:extends AGENT BioAgent)
  (:prefix "BioAgent")
  (:uri "http://agent.jhuapl.edu/2010/07/02/bio/BioAgent#")
  (:types "Biological Laboratory" - Laboratory
	  BiologicalResourceCenter - Vendor
	  BiologicalReferenceMaterial - InformationContentEntity)
  (:predicates
   ;; customized in each sub-domain:
   (hasBRCSourceMaterial - fact ?m - Microorganism ?sm - BWARelatedSubstance)
   (obtainSourceMaterial ?a - Agent ?m - Microorganism)
   (weaponize ?a - Agent ?b - Microorganism)
   (collectSourceMaterial ?a - Agent ?o - Microorganism) ; not from a vendor
   (acquireSeedstock ?a - Agent ?bd - Bacterium)
   (prepareSourceMaterial ?a - Agent ?bd - Microorganism) ; give it :input
   (prepare ?a - Agent ?b - BWARelatedSubstance)
   (mix ?a - Agent ?m - BiologicalAgentSourceMaterial)
   (sterilize ?a - Agent ?m - CellCultureMedium)
   (treat ?a - Agent ?b - Bacterium)
   (isolate ?a - Agent ?m - Microorganism)
   (concentrate ?a - Agent ?b - Bacterium)
   (validate ?a - Agent ?m - Microorganism)
   (grow ?a - Agent ?b - Bacterium)
   (harvest ?a - Agent ?b - Microorganism)
   (scaleUp ?a - Agent ?b - Microorganism) ; make lots of it
   (incubated ?a - Agent ?o - Microorganism)
   (growCulture ?a - Agent ?b - BiologicalAgentSourceMaterial)
   (heatShock ?a - Agent ?b - Bacterium)
   (postProcess ?a - Agent ?b - Bacterium)
   (activate ?a - Agent ?b - Bacterium)
   (stabilized ?a - Agent ?b - Microorganism)
   (dry ?a - Agent ?b - Bacterium)	; common actions below
   (milled ?a - Agent ?b - Bacterium)
   (fluidize ?a - Agent ?b - Bacterium)
   (virulenceTest ?a - Agent ?b - Bacterium))
  (:axiom
   :context (hasAccessTo ?a BioRelatedEquipment)
   :implies (and (possesses ?a StreakPlate)
		 (hasAccessTo ?a Spreader)
		 (hasAccessTo ?a Stirrer)
		 (hasAccessTo ?a Sterilizer)
		 (hasAccessTo ?a Chiller)
		 (hasAccessTo ?a Heater)
		 (hasAccessTo ?a SolidsDrying)
		 (hasAccessTo ?a SprayDryer)
		 (hasAccessTo ?a Spreader)
		 (hasAccessTo ?a Centrifuge)
		 (hasAccessTo ?a Fermentor)
		 (hasAccessTo ?a Comminuter)
		 (hasAccessTo ?a Microscope)
		 (hasAccessTo ?a Thermocycler)
		 (hasAccessTo ?a SafetyContainment)))
  )

;;;=== Actions common to B.a, BoTox, Marburg ===

(define (action "Rent Bio Lab")
    :subClassOf Rent
    :precondition (not (hasAccessTo ?a BiologicalLaboratory))
    :effect (and (hasAccessTo ?a BiologicalLaboratory)
		 (hasAccessTo ?a BioRelatedEquipment))
    :duration 60.0
    :probability 0.6)

(define (action "Gather Biology Labratory Equipment")
    :subClassOf Gather
    :precondition (and (not (hasAccessTo ?a BiologicalLaboratory))
		       (not (hasAccessTo ?a BioRelatedEquipment)))
    :expansion (parallel
		(possesses ?a Sterilizer) ; bot
		(possesses ?a Fermentor) ; bot
		(possesses ?a SolidsDrying) ; bot
		(possesses ?a Heater)	; bot
		(possesses ?a SprayDryer) ; bot
		(possesses ?a Centrifuge) ; bot
		(possesses ?a Comminuter) ; bot
		(possesses ?a Microscope)
		(possesses ?a Chiller) ; marv ba bot
		(possesses ?a SafetyContainment)) ;bot 
    :effect (hasAccessTo ?a BioRelatedEquipment)
    :duration 60.0
    :probability 0.5)

;;;------------

(define (action "Obtain Source Material From Repository")
    :subClassOf Purchase
    :parameters (?a - Agent
		 ?m - Microorganism)
    :precondition (knowsAbout ?a ?m)
    :vars (?sm - (hasBRCSourceMaterial ?m))
    :value ?sm
    :expansion (series
		(contact ?a BiologicalResourceCenter)
		(link (purchased ?a ?sm) :input BiologicalResourceCenter))
    :effect (obtainSourceMaterial ?a ?m)
    :probability 0.3
    :duration 14.0)

;;;---------------------------------------------------

(define (action "Store Growth Medium")
    :subClassOf Keep
    :parameters (?gm - GrowthMedium)
    :precondition (and (possesses ?a ?gm)
		       (hasAccessTo ?a Chiller))
    :effect (store ?a ?gm)
    :probability 0.95
    :duration 0.05)

(define (action "Mix Source Material")
    :subClassOf Mix
    :parameters (?sm - BiologicalAgentSourceMaterial)
    :precondition (and (possesses ?a ?sm)
		       (hasAccessTo ?a Comminuter))
    :effect (mix ?a ?sm)
    :duration 0.01
    :probability 0.95)

(define (action "Heat Treat Source Material")
    :subClassOf React
    :parameters (?sm - BiologicalAgentSourceMaterial)
    :precondition (and (possesses ?a ?sm)
		       (hasAccessTo ?a Heater))
    :effect (treat ?a ?sm)
    :duration 0.01
    :probability 0.6)

(define (action "Chemically Treat Source Material")
    :subClassOf React
    :parameters (?sm - BiologicalAgentSourceMaterial)
    :expansion (possesses ?a Lysin)
    :precondition (possesses ?a ?sm)
    :effect (treat ?a ?sm)
    :duration 0.05
    :probability 0.75)

(define (action "Observe Using Microscopy")
    :subClassOf Study
    :parameters (?mo - (or Microorganism
			   BiologicalAgentSourceMaterial))
    :precondition (and (possesses ?a ?mo)
		       (hasAccessTo ?a Microscope))
    :effect (validate ?a ?mo)
    :duration 0.01   
    :probability 0.6)

(define (action "Mix With Fluidizer")
    :subClassOf Mix
    :parameters (?a - Agent
		    ?b - BioAgentRelatedEntity) ; would like to have a less general class
    :expansion (parallel
		(possesses ?a FluidizerAdditive)
		(possesses ?a Respirator))
    :precondition (and (possesses ?a ?b)
		       (hasAccessTo ?a SafetyContainment))
    :effect (fluidize ?a ?b)
    :duration 0.01
    :probability 0.95
    :comment "need a way to assert possession of Fluidized FormOf ?b")

;;;--- sterilize --

(define (action "Filter Sterilize Culture Medium")
    :subClassOf Wipe
    :parameters (?a - Agent
		    ?m - CellCultureMedium)
    :precondition (and (possesses ?a ?m)
		       (hasAccessTo ?a Filter))
    :effect (sterilize ?a ?m)
    :probability 0.85
    :duration 0.05)

;;;-- stabilize [virus and toxin] --

(define (action "Add Stabilizer")
    :subClassOf Mix
    :parameters (?a - Agent
		    ?m - Microorganism)
    :precondition (possesses ?a ?m)
    :expansion (possesses ?a Stabilizer)
    :effect (stabilized ?a ?m)
    :probability 0.9
    :duration 0.05)

;;;--- Validate presence

(define (action "Validate Using Immunological Assay")
    :subClassOf Study
    :parameters (?a - Agent
		    ?b - BioAgentRelatedEntity)
    :precondition (possesses ?a ?b)
    :expansion (possesses ?a ImmunoassayKit)
    :effect (validate ?a ?b)
    :duration 0.67			; Ba much different (?)
    :probability 0.9
    :comment "?b can be ClostridiumBotulinum or MarburgVirus")

(define (action "Test Lethality")
    :subClassOf Investigate
    :parameters (?a - Agent
		    ?b - BioAgentRelatedEntity)
    :precondition (possesses ?a ?b)
    :expansion (parallel
		(possesses ?a Respirator)
		(possesses ?a SafetyContainment)
		(possesses ?a TestAnimal)
		(possesses ?a AnimalTestingEquipment))		
    :effect (virulenceTest ?a ?b)
    :duration 4.0
    :probability 0.85)

#|-----------  test problems --------------

(define (problem "Access To Equipment")
    (:domain bio)
  (:parameters ?a - Agent)
  (:goal (hasAccessTo ?a BioRelatedEquipment)))


(define (problem BRC_purchase)
    (:parameters ?p - Person)
  (:goal (obtainSourceMaterial ?p BacillusAnthracis)))

|#
