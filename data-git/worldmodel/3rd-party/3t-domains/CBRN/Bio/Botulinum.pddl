(in-package :ap)

;;; Important: be sure that each step has a precondition from 
;;;            a preceeding step and that each step's effects
;;;            provide at least one precondition to a succeeding step.

(define (domain Botulinum)
    (:extends bio)
  (:predicates
   (make ?a - Agent ?c - Thing))	; for belief net tests
  (:constants 
   RecipeForProducingBotulinumToxin
   - (and BiologicalReferenceMaterial Recipe))
  (:init
   (containsInformation wikipedia.org ClostridiumBotulinum)
   (hasRecipe ClostridiumBotulinum RecipeForProducingBotulinumToxin)
   (hasBRCSourceMaterial ClostridiumBotulinum ClostridiumBotulinumSourceMaterial)
   (sells BiologicalResourceCenter ClostridiumBotulinumSourceMaterial))
  (:axiom
   :vars (?a - Agent)
   :context (knowsAbout ?a ClostridiumBotulinum)
   :implies (possesses ?a RecipeForProducingBotulinumToxin))
  (:axiom
   :vars (?a - Agent)
   :context (hasAccessTo ?a BioRelatedEquipment)
   :implies (and (hasAccessTo ?a AnaerobicGrowthEquipment)
		 (hasAccessTo ?a Dialysis)
		 (hasAccessTo ?a CationIonExchangeColumn)
		 (hasAccessTo ?a UltrafiltrationSystem)
		 (hasAccessTo ?a Ultracentrifuge)))
  )

(remove-action 'Purchase)

(define (action "Weaponize Toxin")
    :subClassOf Weaponize
    :parameters (?a - Agent)
    :vars (?p - Person)
    :precondition (>  (hasKnowledge ?a) 1)
    :expansion (series
		(knowsAbout ?p ClostridiumBotulinum)
		(hasAccessTo ?p BioRelatedEquipment)
		(produce ?p BotulinumToxinIsolate)
		(postProcess ?p BotulinumToxinIsolate)
		(virulenceTest ?p BotulinumToxinIsolate))
    :effect (weaponize ?a ClostridiumBotulinum)
    :probability 0.2)

;;;--- formulations we know will (probably) not work ---
;;;
;;;  Important to tie together subactions with preconditions
;;;   and to have the primary effect of the top node the same.

(define (action "Home Made Botulinum Toxin")
    :subClassOf Make
    :parameters (?a - Agent)
    :precondition (< (hasKnowledge ?a) 2)
    :expansion (series
		(knowsAbout ?a ClostridiumBotulinum)
		(growCulture ?a ClostridiumBotulinum)
		(harvest ?a ClostridiumBotulinum)
		(virulenceTest ?a BotulinumToxinIsolate))
    :effect (weaponize ?a ClostridiumBotulinum)
    :probability 0.001)

(define (action "Home Grow Culture")
    :subClassOf Grow
    :parameters (?a - Agent)
    :precondition (and (possesses ?a RecipeForProducingBotulinumToxin)
		       ;;(knowsAbout ?a ClostridiumBotulinum)
		       (not (hasAccessTo ?a BioRelatedEquipment)))
    :expansion (parallel
		(either (acquire ?a FoodSourceMaterial)
			(acquire ?a AnimalSourceMaterial))
		(possesses ?a GlassContainer)
		(possesses ?a Meat))
    :effect (and (growCulture ?a ClostridiumBotulinum)
		 (possesses ?a ClostridiumBotulinumCulture))
    :duration 10.0
    :probability 0.01
    :comment "Will almost certainly fail if Container not sterilized")

(define (action "Harvest Botulinum Toxin")
    :subClassOf Gather
    :parameters (?a - Agent)
    :precondition (possesses ?a ClostridiumBotulinumCulture)
    :expansion (parallel
		(possesses ?a Gloves)
		(possesses ?a FaceProtection))
    :effect (and (harvest ?a ClostridiumBotulinum)
		 (possesses ?a BotulinumToxinIsolate))
    :duration 0.1
    :probability 0.4
    :comment "If present, will still probably screw it up")

;;;=== Make it as a microbiologist would ===

(define (action "Produce Botulinum Toxin")
    :subClassOf Make
    :parameters (?a - Agent)
    :precondition (and (possesses ?a RecipeForProducingBotulinumToxin)
		       (hasAccessTo ?a BioRelatedEquipment))
    :expansion (series
		(parallel
		 (prepare ?a BotGrowthMedium)
		 (obtainSourceMaterial ?a ClostridiumBotulinum))
		(grow ?a ClostridiumBotulinum)
		(scaleUp ?a ClostridiumBotulinum)
		(activate ?a ClostridiumBotulinumCulture))
    :effect (produce ?a BotulinumToxinIsolate))

;;;=== Obtain Source Material ===

;;;-- unless getting from repository, need to prepare --

(define (action "Obtain and Prep Source Material")
    :parameters (?a - Agent)
    :precondition (hasAccessTo ?a BioRelatedEquipment)
    :expansion (series
		(parallel
		 (acquire ?a ClostridiumBotulinumSourceMaterial)
		 (possesses ?a BotSolidGrowthMedium))
		(prepare ?a ClostridiumBotulinumCulture))
    :effect (obtainSourceMaterial ?a ClostridiumBotulinum))

(define (action "Obtain Clostridium Botulinum Infected Animal")
    :parameters (?a - Agent)
    :effect (and (acquire ?a ClostridiumBotulinumSourceMaterial)
		 (acquire ?a AnimalSourceMaterial)
		 (possesses ?a ClostridiumBotulinumSpore))
    :probability 0.15
    :duration 0.1)

(define (action "Obtain Clostridium Botulinum Contaminated Food Sources")
    :parameters (?a - Agent)
    :effect (and (acquire ?a ClostridiumBotulinumSourceMaterial)
		 (acquire ?a FoodSourceMaterial)
		 (possesses ?a ClostridiumBotulinumSpore))
    :probability 0.6
    :duration 0.1)

(define (action "Obtain Clostridium Botulinum Source Material Reservoir")
    :parameters (?a - Agent)
    :effect (and (acquire ?a ClostridiumBotulinumSourceMaterial)
		 (possesses ?a ClostridiumBotulinumSpore))
    :probability 0.5
    :duration 3.5)

;;;===  Prepare Clostridium Botulinum Seed Stock from Source Material ===

;; Note we do not incude the growh step of the isolate because
;;   the very next major step is growing it and the preconditions and observables
;;   are basicaly the same.

(define (action "Prepare Seed Stock from Source Material")
    :subClassOf Prepare
    :parameters (?a - Agent)
    :precondition (possesses ?a ClostridiumBotulinumSourceMaterial)
    :expansion (series
		(mix ?a ClostridiumBotulinumSourceMaterial)
		(treat ?a ClostridiumBotulinumSourceMaterial)
		(concentrate ?a ClostridiumBotulinumSourceMaterial)
		(isolate ?a ClostridiumBotulinum)
		(validate ?a ClostridiumBotulinum))
    :effect (prepare ?a ClostridiumBotulinumCulture)
    :comment "when obtained from nature")

;;- concentrate Source Material

(define (action "Concentrate Clostridium Botulinum Source Material Via Centrifugation")
    :subClassOf Concentrate
    :parameters (?a - Agent)
    :precondition (and (possesses ?a ClostridiumBotulinumSourceMaterial)
		       (hasAccessTo ?a Centrifuge))
    :effect (and (concentrate ?a ClostridiumBotulinumSourceMaterial)
		 (possesses ?a ClostridiumBotulinumSupernatant))
    :probability 0.9)

(define (action "Concentrate Clostridium Botulinum Source Material Via Filtration")
    :subClassOf Concentrate
    :parameters (?a - Agent)
    :precondition (and (possesses ?a ClostridiumBotulinumSourceMaterial)
		       (hasAccessTo ?a Filter))
    :effect (and (concentrate ?a ClostridiumBotulinumSourceMaterial)
		 (possesses ?a ClostridiumBotulinumFiltrate))
    :duration 1.0
    :probability 0.75)

(define (action "Concentrate Clostridium Botulinum Source Material Settling")
    :subClassOf Concentrate
    :parameters (?a - Agent)
    :precondition (possesses ?a ClostridiumBotulinumSourceMaterial)
    :effect (and (concentrate ?a ClostridiumBotulinumSourceMaterial)
		 (possesses ?a ClostridiumBotulinumSupernatant))
    :probability 0.8
    :duration 1.0)

;;;--- isolate

(define (action "Isolate Clostridium Botulinum By Streak Culture")
    :subClassOf Purify
    :parameters (?a - Agent)
    :precondition (and (possesses ?a ClostridiumBotulinumSourceMaterial)
		       (possesses ?a BotSolidGrowthMedium)
		       (hasAccessTo ?a Spreader)
		       (hasAccessTo ?a Heater))
    :effect (and (isolate ?a ClostridiumBotulinum)
		 (possesses ?a StreakPlate)
		 (possesses ?a ClostridiumBotulinum)
		 (possesses ?a ClostridiumBotulinumColony))
    :probability 0.45
    :duration 0.6)
    
;;;--- Validate

(define (action "Validate Clostridium Botulinum Observing Colony Morphology")
    :subClassOf Study
    :parameters (?a - Agent)
    :precondition (and (possesses ?a ClostridiumBotulinumColony)
		       (possesses ?a StreakPlate))
    :effect (validate ?a ClostridiumBotulinum)
    :duration 0.01   
    :probability 0.5)

(define (action "Validate Clostridium Botulinum Using PCR")
    :subClassOf Study
    :parameters (?a - Agent)
    :expansion (possesses ?a DNAExtractionKit)
    :precondition (and (possesses ?a ClostridiumBotulinum)
		       (hasAccessTo ?a Thermocycler))
    :effect (validate ?a ClostridiumBotulinum)
    :duration 0.6  
    :probability 0.5)

(define (action "Validate Clostridium Botulinum Using Immunological Assay")
    :subClassOf Study
    :parameters (?a - Agent)
    :expansion (possesses ?a ImmunoassayKit)
    :precondition (possesses ?a ClostridiumBotulinum)
    :effect (validate ?a ClostridiumBotulinum)
    :duration 0.6
    :probability 0.85)

;;;==== prepare growth media ====

(define (action "Prepare Clostridium botulinum Broth Culture Medium")
    :subClassOf Prepare
    :parameters (?a - Agent)
    :expansion (series
		(possesses ?a BotLiquidGrowthMedium)
		(store ?a BotLiquidGrowthMedium))
    :effect (and (prepare ?a BotGrowthMedium)
		 (prepare ?a BotLiquidGrowthMedium))
    :duration 0.1
    :probability 0.85)

(define (action "Prepare Clostridium botulinum Agar Culture Medium")
    :subClassOf Prepare
    :parameters (?a - Agent)
    :precondition (hasAccessTo ?a Sterilizer)
    :expansion (possesses ?a BotSolidGrowthMedium)
    :effect (and (prepare ?a BotGrowthMedium)
		 (prepare ?a BotSolidGrowthMedium))
    :duration 0.1
    :probability 0.85
    :comment "no storeage required")

;;;=== Grow Clostridium botulinum culture From Seed Stock ===

(define (action "Grow Clostridium Botulinum Using Biphasic Method")
    :subClassOf Grow
    :parameters (?a - Agent)
    :precondition (and (prepare ?a BotLiquidGrowthMedium)
		       (possesses ?a ClostridiumBotulinumSourceMaterial))
    :effect (and (grow ?a ClostridiumBotulinum)
		 (possesses ?a ClostridiumBotulinumCulture))
    :duration 9.5
    :probability 0.7)	

(define (action "Grow Clostridium Botulinum using Broth Culture Method")
    :subClassOf Grow
    :parameters (?a - Agent)
    :precondition (and (prepare ?a BotLiquidGrowthMedium)
		       (possesses ?a ClostridiumBotulinumSourceMaterial)
		       (hasAccessTo ?a AnaerobicGrowthEquipment)
		       (hasAccessTo ?a Heater))
    :effect (and (grow ?a ClostridiumBotulinum)
		 (possesses ?a ClostridiumBotulinumCulture))
    :duration 2.0
    :probability 0.75)	

(define (action "Grow Clostridium Botulinum Using Solid Growth Medium")
    :subClassOf Grow
    :parameters (?a - Agent)
    :precondition (and (prepare ?a BotSolidGrowthMedium)
		       (possesses ?a ClostridiumBotulinumSourceMaterial)
		       (hasAccessTo ?a Heater)
		       (hasAccessTo ?a Spreader))
    :effect (and (grow ?a ClostridiumBotulinum)
		 (possesses ?a ClostridiumBotulinumCulture))
    :duration 1.5
    :probability 0.6)	

;;;--- scaleUp culture ---

(define (action "Scale Up Using Large Container")
    :subClassOf Grow
    :parameters (?a - Agent)
    :precondition (and (possesses ?a ClostridiumBotulinumCulture)
		       (possesses ?a BotLiquidGrowthMedium)
		       (hasAccessTo ?a Heater)
		       (hasAccessTo ?a AnaerobicGrowthEquipment)) ;;Carboy
    :effect (scaleUp ?a ClostridiumBotulinum)
    :duration 10.0
    :probability 0.75)

(define (action "Scale Up Bot Using Culture Flasks")
    :subClassOf Grow
    :parameters (?a - Agent)
    :precondition (and (possesses ?a  ClostridiumBotulinumCulture)
		       (possesses ?a BotLiquidGrowthMedium)
		       (hasAccessTo ?a AnaerobicGrowthEquipment)
		       (hasAccessTo ?a Heater)
		       (hasAccessTo ?a Flask))
    :effect (scaleUp ?a ClostridiumBotulinum)
    :duration 6.0
    :probability 0.75)

(define (action "Scale Up Bot Using Fermentor")
    :subClassOf Grow
    :subClassOf Manufacture
    :parameters (?a - Agent)
    :precondition (and (possesses ?a  ClostridiumBotulinumCulture)
		       (possesses ?a BotLiquidGrowthMedium)
		       (hasAccessTo ?a Fermentor)
		       (hasAccessTo ?a Chiller))
    :effect (scaleUp ?a ClostridiumBotulinum)
    :duration 11.0
    :probability 0.9)

(define (action "Scale Up Bot Using Spread Plates")
    :subClassOf Grow
    :parameters (?a - Agent)
    :precondition (and (possesses ?a  ClostridiumBotulinumCulture)
		       (possesses ?a BotSolidGrowthMedium)
		       (hasAccessTo ?a AnaerobicGrowthEquipment)
		       (hasAccessTo ?a Heater)
		       (hasAccessTo ?a Spreader))
    :effect (and (scaleUp ?a ClostridiumBotulinum)
		 (possesses ?a SpreadPlate))
    :duration 3.0
    :probability 0.4)

;;;--- activate --

(define (action "Activate Botulinum Toxin Culture")
    :subClassOf Activate
    :parameters (?a - Agent)
    :precondition (possesses ?a ClostridiumBotulinumCulture)
    :expansion (possesses ?a Protease)
    :effect (and (activate ?a ClostridiumBotulinumCulture)
		 (possesses ?a BotulinumToxinIsolate))
    :duration 0.01
    :probability 0.95)

;;;=========== Post process to make it a weapon ================

(define (action "Post Process Botulinum Toxin")
    :subClassOf Modify
    :parameters (?a - Agent)
    :precondition (possesses ?a BotulinumToxinIsolate)
    :expansion (series
		(parallel
		 (series
		  (purified ?a BotulinumToxinIsolate)
		  (activate ?a BotulinumToxinIsolate)
		  (stabilized ?a BotulinumToxinIsolate))
		 (possesses ?a Respirator))
		(dry ?a BotulinumToxinIsolate)
		(milled ?a DriedBotulinumToxin)
		(fluidize ?a MilledBotulinumToxin))
    :effect (postProcess ?a BotulinumToxinIsolate)
    :duration 2.0
    :probability 0.8)

;;;-- purified

;;; why is BotulinumToxin not an effect, as it is a precondition of the 
;;;  activate step?

(define (action "Purify Botulinum Toxin Via Organic Solvent Precipitation")
    :subClassOf Purify
    :parameters (?a - Agent)
    :precondition (and (possesses ?a BotulinumToxinIsolate)
		       (hasAccessTo ?a Stirrer))
    :expansion (possesses ?a Solvent)
    :effect (purified ?a BotulinumToxinIsolate)
    :duration 2.0
    :probability 0.8)

(define (action "Purify Botulinum Toxin Via Affinity Chromatography")
    :subClassOf Purify
    :parameters (?a - Agent)
    :precondition (and (possesses ?a BotulinumToxinIsolate)
		       (hasAccessTo ?a Column))
    :expansion (possesses ?a ColumnBuffer)
    :effect (purified ?a BotulinumToxinIsolate)
    :duration 2.0
    :probability 0.3)

(define (action "Purify Botulinum Toxin Via Ultrafiltration")
    :subClassOf Purify
    :parameters (?a - Agent)
    :precondition (and (possesses ?a BotulinumToxinIsolate)
		       (hasAccessTo ?a UltrafiltrationSystem))
    :effect (purified ?a BotulinumToxinIsolate)
    :duration 0.1
    :probability 0.6)

(define (action "Purify Botulinum Toxin via Acid Precipitation")
    :subClassOf Purify
    :parameters (?a - Agent)
    :precondition (and (possesses ?a BotulinumToxinIsolate)
		       (hasAccessTo ?a Stirrer))
    :effect (purified ?a BotulinumToxinIsolate)
    :duration 2.0
    :probability 0.5)

(define (action "Purify Botulinum Toxin Via Gel-Filtration")
    :subClassOf Purify
    :parameters (?a - Agent)
    :precondition (and (possesses ?a BotulinumToxinIsolate)
		       (hasAccessTo ?a Column))
    :expansion (parallel
		(possesses ?a ColumnBuffer)
		(possesses ?a GelFiltrationMedium))
    :effect (purified ?a BotulinumToxinIsolate)
    :duration 2.0
    :probability 0.5)

(define (action "Purify Botulinum Toxin Via Dialysis")
    :subClassOf Purify
    :parameters (?a - Agent)
    :precondition (and (possesses ?a BotulinumToxinIsolate)
		       (hasAccessTo ?a Dialysis)) ; this is a process!
    :expansion (possesses ?a DialysisBuffer)
    :effect (purified ?a BotulinumToxinIsolate)
    :duration 1.5
    :probability 0.65)

(define (action "Purify Botulinum Toxin Via Ion-Exchange Chromatography")
    :subClassOf Purify
    :parameters (?a - Agent)
    :precondition (and (possesses ?a BotulinumToxinIsolate)
		       (hasAccessTo ?a CationIonExchangeColumn))
    :expansion (possesses ?a ColumnBuffer)
    :effect (purified ?a BotulinumToxinIsolate)
    :duration 2.0
    :probability 0.3)

(define (action "Purify Botulinum Toxin Via Salting Out")
    :subClassOf Purify
    :parameters (?a - Agent)
    :precondition (possesses ?a BotulinumToxinIsolate)
    :expansion (possesses ?a AmmoniumSulfate)
    :effect (purified ?a BotulinumToxinIsolate)
    :duration 2.0
    :probability 0.5)

(define (action "Purify Botulinum Toxin Via Ultracentrifugation")
    :subClassOf Purify
    :parameters (?a - Agent)
    :precondition (and (possesses ?a BotulinumToxinIsolate)
		       (hasAccessTo ?a  Ultracentrifuge))
    :effect (purified ?a BotulinumToxinIsolate)
    :duration 2.0
    :probability 0.5)

;;;--- activate purified toxin

(define (action "Activate Purified Botulinum Toxin")
    :subClassOf Activate
    :parameters (?a - Agent)
    :precondition (purified ?a BotulinumToxinIsolate)
    :expansion (possesses ?a Protease)
    :effect (and (activate ?a BotulinumToxinIsolate)
		 (possesses ?a BotulinumToxinIsolate))
    :duration 0.01
    :probability 0.9)

;;;-- Stabalize

(define (action "Add Stabilizer To Botulinum Toxin")
    :subClassOf Mix
    :parameters (?a - Agent)
    :precondition (possesses ?a BotulinumToxinIsolate)
    :expansion (possesses ?a BacterialStabilizer)
    :effect (stabilized ?a BotulinumToxinIsolate)
    :duration 0.01
    :probability 0.9)

;;;--- dry ----

(define (action "Dry Botulinum Toxin Isolate")
    :subClassOf Dry
    :parameters (?a - Agent)
    :precondition (and (possesses ?a BotulinumToxinIsolate)
		       (stabilized ?a BotulinumToxinIsolate)
		       (hasAccessTo ?a SolidsDrying)
		       (possesses ?a Respirator)
		       (hasAccessTo ?a SafetyContainment))
    :effect (and (dry ?a BotulinumToxinIsolate)
		 (possesses ?a DriedBotulinumToxin))
    :duration 1.5
    :probability 0.9)

(define (action "Dry via Spray Dryer")
    :subClassOf Dry
    :parameters (?a - Agent)
    :precondition (and (possesses ?a BotulinumToxinIsolate)
		       (stabilized ?a BotulinumToxinIsolate)
		       (hasAccessTo ?a SprayDryer)
		       (possesses ?a Respirator)
		       (hasAccessTo ?a SafetyContainment))
    :effect (and (dry ?a BotulinumToxinIsolate)
		 (possesses ?a DriedBotulinumToxin))
    :duration 0.1
    :probability 0.1)

(define (action "Dry via Acetone Solvent Extraction")
    :subClassOf Dry
    :parameters (?a - Agent)
    :precondition (and (possesses ?a BotulinumToxinIsolate)
		       (stabilized ?a BotulinumToxinIsolate)
		       (possesses ?a Respirator)
		       (hasAccessTo ?a SafetyContainment))
    :expansion (possesses ?a Acetone)
    :effect (and (dry ?a BotulinumToxinIsolate)
		 (possesses ?a DriedBotulinumToxin))
    :duration 1.5
    :probability 0.85)

(define (action "Dry via Evaporation")
    :subClassOf Dry
    :parameters (?a - Agent)
    :precondition (and (possesses ?a BotulinumToxinIsolate)
		       (stabilized ?a BotulinumToxinIsolate)
		       (possesses ?a Respirator)
		       (hasAccessTo ?a SafetyContainment))
    :effect (and (dry ?a BotulinumToxinIsolate)
		 (possesses ?a DriedBotulinumToxin))
    :duration 7.0
    :probability 0.95)

;;;--- mill

;; Example of abstraction:
;;  Homogenizer, Griner, Ball Mill collapsed into superclass
;;  of Comminuter since all other preconditions, duration, and probability
;;  are the same.

(define (action "Mill Botulinum Toxin")
    :subClassOf Mill
    :parameters (?a - Agent)
    :precondition (and (possesses ?a DriedBotulinumToxin)
		       (hasAccessTo ?a Comminuter)
		       (possesses ?a Respirator)
		       (hasAccessTo ?a SafetyContainment))
    :effect (and (milled ?a DriedBotulinumToxin)
		 (possesses ?a MilledBotulinumToxin))
    :duration 0.05     
    :probability 0.85)

;;;========== problems =====

(define (problem "Bot Toxin")
    (:domain Botulinum)
  (:requirements :assumptions)
  (:objective ClostridiumBotulinum)
  (:goal (weaponize TerroristGroup ClostridiumBotulinum)))

(define (problem "BoTox For Idiots")
  (:domain Botulinum)
  (:objects JoeBlow - Person)
  (:init (hasKnowledge JoeBlow 1))
  (:goal (weaponize JoeBlow ClostridiumBotulinum)))


(define (problem "PR test")
    (:domain Botulinum)
  (:objects GOP - TerroristGroup)
  (:observation
   (acquire GOP ClostridiumBotulinumSourceMaterial)))

;;;==== belief net test ====

;;; run with all-plans and make a belief net
;;;  to lear how to deal with test-pc

(define (action Smart_Make)
    :parameters (?a - Agent)
    :precondition (>= (hasKnowledge ?a) 2)
    :expansion (knowsAbout ?a ClostridiumBotulinum)
    :effect (make ?a ClostridiumBotulinum)
    :probability 0.6)

(define (action Dumb_Make)
    :parameters (?a - Agent)
    :precondition (<= (hasKnowledge ?a) 1)
    :expansion (knowsAbout ?a ClostridiumBotulinum)
    :effect (make ?a ClostridiumBotulinum)
    :probability 0.4)

(define (problem Belief-net_test_assumption)
    (:requirements :assumptions)
  (:objects JoeBlow - Person)
  (:goal (make JoeBlow ClostridiumBotulinum)))

(define (problem Belief-net_test_init)
  (:objects JoeShmo - Person)
  (:init (hasKnowledge JoeShmo 2))
  (:goal (make JoeShmo ClostridiumBotulinum)))