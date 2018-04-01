(in-package :ap)

(define (domain mining-milling)
    (:comment "P1 in IAEA pathway")
  (:extends CBRNEChemical CBRNEMatEquip manufacturing)
  (:types UraniumCompound - ControlledSubstance
	  UraniumOre UraniumSolution
	  TetravalentUranium HexavalentUranium - UraniumCompound
	  CrushedUraniumOre UraniumOreConcentrate ThoriumBearingUraniumOre
	  SodiumDiuranate MagnesiumDiuranate AmmoniumDiuranate - UraniumOre
	  ;;; and so on
	  )
  (:predicates 
   (mine ?a - Agent ?o - ChemicalEntity)
   (calcinate ?a - Agent ?o - ChemicalEntity)
   (solventExtraction ?a - Agent ?o - ChemicalEntity)
   (mill ?a - Agent ?o - ChemicalEntity)
   (crush ?a - Agent ?o - ChemicalEntity)
   (extract ?a - Agent ?o - ChemicalEntity)
   (leached ?a - Agent ?o - ChemicalEntity)
   (percipitated ?a - Agent ?o - ChemicalEntity)
   (ionExchangeRecover ?a - Agent ?o - ChemicalEntity)
   )
  )

(define (action Mining_&_Milling)
    :parameters (?a - Agent)
    :effect (possesses ?a NaturalUranium)
    :duration 40.0
    :probability 0.9)
