(in-package :ap)

(define (domain enrichment)
    (:extends CBRNEChemical CBRNEMatEquip manufacturing)
  (:types
   FissileMaterial - ChemicalEntity
   UraniumHexafluoride - LowEnrichedUranium
   HighlyEnrichedUranium PlutoniumMetal - FissileMaterial
   GasCentrefuge - NuclearRadiologicalEquipment
   FuelEnrichmentPlant - Factory
   )
  (:predicates
   (obtainFissileMaterial ?a - Agent)
   (enrich ?a - Agent ?u - UraniumElementalEntity)
   )
  (:functions
   (hasCentrefuges ?a - Agent)
   )
  (:axiom
   :vars (?a - Agent)
   :context (> (hasCentrefuges ?a) 0)
   :implies (possesses ?a GasCentrefuge))
  (:axiom
   :vars (?a - Agent)
   :context (<= (hasCentrefuges ?a) 0)
   :implies (not (possesses ?a GasCentrefuge))
   :comment "for planned situations")
  )

(define (action Make_HEU)
    :parameters (?a - Agent)
    :precondition (not (possesses ?a LowEnrichedUranium))
    :expansion (series
		(parallel
		 (possesses ?a NaturalUranium)
		 (possesses ?a GasCentrefuge))
		(possesses ?a LowEnrichedUranium)
		(enrich ?a LowEnrichedUranium))
    :value HighlyEnrichedUranium
    :effect (and (obtainFissileMaterial ?a)
		 (possesses ?a HighlyEnrichedUranium)))

(define (action Centrefuge)
    :parameters (?a - Agent)
    :vars (?plant - FuelEnrichmentPlant)
    :precondition (and (possesses ?a NaturalUranium)
		       (possesses ?a GasCentrefuge)
		       (hasAccessTo ?a ?plant))
    :effect (and (possesses ?a LowEnrichedUranium)
		 (possesses ?a UraniumHexafluoride))
    :duration 100.0			; weeks
    :probability 0.95
    :comment "going from Natural to Low is 2/3rds the work to bomb grade")

(define (action Concentrate)
    :parameters (?a - Agent)
    :vars (?plant - FuelEnrichmentPlant)
    :precondition (and (possesses ?a LowEnrichedUranium)
		       (possesses ?a GasCentrefuge)
		       ;;(>= (hasCentrefuges ?a) 5000)
		       (hasAccessTo ?a ?plant))
    :value HighlyEnrichedUranium
    :effect (and (obtainFissileMaterial ?a)
		 (enrich ?a LowEnrichedUranium)
		 (possesses ?a HighlyEnrichedUranium))
    :duration 52.0			; weeks
    :probability 0.95
    :comment "5,000 is about the number needed to make a bomb")

(define (action Build_Centrefuges)
    :parameters (?a - Agent)
    :effect (and (possesses ?a GasCentrefuge)
		 (increase (hasCentrefuges ?a) 1000))
    :duration 40.0
    :probability 0.9
    :comment "hasCentrefuges must be initialized")

;;;;;;;;;;;;;;;;;;;;;;;;
