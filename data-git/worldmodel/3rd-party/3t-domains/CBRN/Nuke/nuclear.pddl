(in-package :ap)

#|
reprocess spent fuel -> PU
|#

(define (domain nuclear)
    (:extends event ap mining-milling enrichment weapon)
  (:types
   NuclearFacility - Facility 
   NuclearPowerPlant HeavyWaterPlant - NuclearFacility
   NuclearReactor - (and NuclearRadiologicalEquipment Facility)
   LightWaterReactor HeavyWaterReactor - NuclearReactor
   NucRelatedEquipment - ControlledEquipment
   NuclearWeaponPlan - Plan
   DeuteriumOxide - Water
   )
  (:predicates
    (radioactiveDecayType - fact ?d ?r - Thing)
   )
  (:functions
    (atomicWeight - fact ?d - NuclearRadiologicalMaterial)
    (atomicNumber - fact ?d - NuclearRadiologicalMaterial)
    (radioactiveDecayEnergy - fact ?d - NuclearRadiologicalMaterial)
    (radioactiveContaminationQuantity ?d - NuclearRadiologicalMaterial)
    (radioactiveHalflife - fact ?d - NuclearRadiologicalMaterial)
    (hasCentrefuges ?a - Agent)
    )
  (:axiom 
   :vars (?n - Country
	     ?f - NuclearFacility
	     ?loc - (located ?f))
   :context (hasGeographicSubregion ?n ?loc)
   :implies (hasAccessTo ?n ?f))
  )

;;;=== obtainFissileMaterial ===

(define (action "Reprocess Spent Fuel")
    :parameters (?a - Agent)
    :vars (?plant - HeavyWaterReactor)
    :value PlutoniumMetal
    :precondition (and (hasAccessTo ?a ?plant)
		       (possesses ?a DeuteriumOxide))
    :effect (and (obtainFissileMaterial ?a)
		 (possesses ?a PlutoniumMetal))
    :duration 52.0
    :probability 0.7)
