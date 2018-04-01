(in-package :ap)

;; extracted from event.pddl

(define (domain manufacturing)
    (:extends event commerce)
  (:types
   MachineSystem ManufacturedForm Machine ChemicalEqupment NuclearRadiologicalEquipment 
   Supply MachineComponent BiologicalEquipment - Equipment
   Factory - CommercialFacility
   ConveyorBelt - StationaryConveyor
   Manufacturer - Vendor
   ControlledEquipment - ControlledSubstance ; harder to purchase
   ;; Events
   Mill - Carve
   Build Design - Develop
   Create Construct Manufacture - Build)
  (:predicates
   (assemble ?a - Agent ?b - PhysicalEntity)
   (madeBy ?b - PhysicalEntity ?a - Manufacturer)
   (makes  ?a - Manufacturer ?b - PhysicalEntity)
   (madeFrom - fact ?pe1 ?pd2 - PhysicalEntity)
   (requiredEquipment - fact ?pe1 ?pd2 - PhysicalEntity)
   (buildAndTest ?c - Agent ?c - PhysicalEntity)
   (possessesEquipment ?a - Agent ?t - Thing)
   (possessComponents ?a - Agent ?ca - Artifact))
   (:functions
    (manufacturingSector - fact ?a - Manufacturer) - Thing))

(inverseOf 'madeBy 'makes)
(inverseOf 'madeFrom 'hasPart)