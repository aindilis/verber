(in-package :ap)

#|

issue:  read json problem description
issue:  induce replanning during execution
    create report with time
    if time > report time, assert prop, notice failure, etc.
issue:  reward
|#

#|  
Dip:  UK, France, Germany : IAEA observation
requires cooperation
Deal, number of years ...
Demarche,  

20% enrichment 

heavy water at Arak

2002:  Nataz does not yet exist (up to speed)

counter:  attack facilities
cooperation, negotiation

Make multiple outputs:  thread throgh contingency plus
relevant counterplans 
   make JSON for each action for each time tick for each contingency

need replanning triggered.

need ID for each thread

is Intent relevant?
put it as a precondition?
(probability 0.5 (hasIntent IRN NuclearAttackCapability))
when encountered in :init, make assumed-pc on situation

different plans based on intent?

blow-back if CP executed?

break out capability, not weapon?

countergoal for USA:  (not (acquire IRN NuclearAttackCapability))

Zero Days on Showtime
STUXNET took several years, two phases
[purpose was to keep Israel out of bombing Natanz]

members of P3:  US, GB, Fra

deception
|#

(define (situation Iran_now)
    (:domain nuclear_weapon)
  (:objects IRN ISR RUS IND PAK CHI GBR FRA DEU SDN - Nation
	    P5+1 - GeoPoliticalEntity
	    JCPOA - Treaty
	    ISA - Sanction
	    Qom Arak - City
	    QomProvence Tomsk Markazi - StateOrProvince
	    KargIsland - (and PortFacility Island)
	    PersianGulf StraitOfHormuz GulfOfOman ArabianSea - Waterway
	    SouthPars - WaterArea
	    Fodrow Seversk - FuelEnrichmentPlant
	    Natanz - (and UndergroundFacility FuelEnrichmentPlant)
	    Bushehr - NuclearPowerPlant
	    IR-40 - HeavyWaterReactor
	    Khondab - HeavyWaterPlant
	    Petropars ChinaNationalPetrolium - CommercialOrganization ; oil trader
	    QomAirport TomskAirport - Airport)
  (:init
   (possesses ISR NuclearWeapon)
   (not (partyTo ISR NNPT))
   (hasAccessTo ISR SWIFT)
   (hasAllianceWith USA ISR)
   (hasAllianceWith USA GBR)
   (hasAllianceWith USA FRA)
   (hasAllianceWith USA SDN)
   (hasAccessTo USA SWIFT)
   (possesses USA NuclearWeapon)
   (memberOf USA P5+1)
   (partyTo USA JCPOA)
   (possesses GBR NuclearWeapon)
   (memberOf GBR NATO)
   (partyTo GBR NNPT)
   (memberOf GBR P5+1)
   (partyTo GBR JCPOA)
   (possesses FRA NuclearWeapon)
   (memberOf FRA NATO)
   (partyTo FRA NNPT)
   (partyTo FRA JCPOA)
   (memberOf FRA P5+1)
   (possesses FRA NucRelatedEquipment)
   (memberOf DEU P5+1)
   (partyTo DEU JCPOA)
   (possesses DEU NucRelatedEquipment)
   ;; adversaries
   (partyTo IRN NNPT)
   (hasAdversary IRN USA)
   (hasAdversary IRN ISR)
   (hasAdversary IRN SDN)
   (hasAdversary ISR SDN)
   (hasAdversary USA RUS)
   (hasAllianceWith IRN RUS)
   (partyTo RUS NNPT)
   (memberOf RUS P5+1)
   (partyTo RUS JCPOA)
   (possesses RUS NucRelatedEquipment)
   (possesses RUS NuclearWeapon)
   (possesses RUS PlutoniumMetal)
   (possesses RUS HighlyEnrichedUranium)
   (hasAccessTo RUS SWIFT)
   (located HighlyEnrichedUranium Seversk)
   (possesses PAK NuclearWeapon)
   (possesses PAK HighlyEnrichedUranium)
   (hasAccessTo PAK SWIFT)
   (not (partyTo PAK NNPT))
   (not (partyTo IND NNPT))
   (memberOf CHI P5+1)
   (possesses CHI NuclearWeapon)
   (partyTo CHI NNPT)
   (possesses CHI HighlyEnrichedUranium)
   (located ChinaNationalPetrolium CHI)
   (hasAccessTo CHI SWIFT)
   ;;-geospatial facts
   (meetsSpatially IRN PersianGulf)
   (hasGeographicSubregion PersianGulf SouthPars)
   (meetsSpatially IRN SouthPars)
   (meetsSpatially PersianGulf StraitOfHormuz)
   (meetsSpatially StraitOfHormuz GulfOfOman)
   (meetsSpatially GulfOfOman ArabianSea)
   (connected KargIsland PersianGulf)
   (connected PersianGulf StraitOfHormuz)
   (connected StraitOfHormuz GulfOfOman)
   (connected GulfOfOman ArabianSea)
   (hasGeographicSubregion IRN Markazi)
   (hasGeographicSubregion Markazi Arak)
   (hasGeographicSubregion IRN KargIsland)
   (hasPort IRN KargIsland)
   (hasGeographicSubregion IRN QomProvence)
   (hasGeographicSubregion QomProvence Qom)
   (located Fodrow QomProvence)
   (hasTransitTerminal QomProvence QomAirport)
   ;;-Russia
   (hasGeographicSubregion RUS Tomsk)
   (located Seversk Tomsk)
   (hasTransitTerminal Tomsk TomskAirport)
   (hasAccessTo RUS CrudeOil)		; will not buy
   (hasAccessTo RUS NaturalGas)
   (hasAccessTo RUS HydrocarbonFuel)
   ;;-logistical facts
   ;;(hasAccessTo IRN SWIFT)		; not yet!
   (hasAccessTo IRN CrudeOil)
   (hasAccessTo IRN NaturalGas)
   (located Petropars IRN)
   (located NaturalGas SouthPars)
   (hasAccessTo IRN SouthPars)
   (located CrudeOil KargIsland)
   (hasAccessTo IRN Fodrow)
   (hasAccessTo IRN Bushehr)
   (hasAccessTo IRN Natanz)
   (hasAccessTo IRN Khondab)
   (located IR-40 Arak)			; heavy water reactor
   (located Khondab Arak)		; heavy water plant
   (hasAccessTo IRN IR-40)
   (hasAccessTo IRN Khondab)
   (possesses IRN NaturalUranium)
   (possesses IRN LowEnrichedUranium)
   (possesses IRN GasCentrefuge)
   (hasCentrefuges IRN 20000)
   (possesses IRN DeuteriumOxide)
   ;;--nuclear weapon init
   (hasKnowledgeAbout IRN NuclearWeapon 2)
   (builtAndTested IRN ImplosionWeapon 0)
   (numBuilt IRN ImplosionWeapon 0)
   (numTests IRN ImplosionWeapon 0)
   ))

;;; Break Out capability:  Plan B, 6 months from weapon
;;;   dual use
;;;   cover it up

;;; spook the Great Satin
;;;    peaceful
;;;    heavy water

(define (problem "Nuclear Weapon Attack Capability")
    (:situation Iran_now)
  (:requirements :counterplanning)
  (:planner IRN)
  (:init (probabilistic 0.5 (hasIntent IRN NuclearAttackCapability))
	 (probabilistic 0.5 (hasIntent IRN BreakoutCapability)))
  (:goal (hasNuclearAttackCapability IRN))
  (:deadline 416.0)			; 8 years
  (:comment "need to get highly enriched, build weapon, etc."))

(define (problem "Break Out Capability")
    (:situation Iran_now)
  (:requirements :counterplanning)
  (:planner IRN)
  (:init (probabilistic 0.5 (hasIntent IRN BreakoutCapability)))
  (:goal (hasBreakoutCapability IRN))
  (:deadline 102.0)
  (:comment "just the building part"))

;;-- test subplans --
#|
(define (problem Sell_fuel)
    (:situation Iran_now)
  (:planner IRN)
  (:goal (hasFinancialResources IRN))
  (:comment "test links"))

(define (problem Buy_equipment)
    (:situation Iran_now)
  (:planner IRN)
  (:init (possesses IRN Money))
  (:goal (possesses IRN NucRelatedEquipment)))

(define (situation India)
    (:after Iran_now)
  (:objects Kandla - PortFacility
	    Gujarat - StateOrProvince
	    IndianOcean - WaterArea)
  (:init 
   (possesses IND NuclearWeapon)
   (not (partyTo IND NNPT))
   (meetsSpatially IndianOcean IND)
   (connected ArabianSea IndianOcean)
   (connected IndianOcean Kandla)
   (hasPort Gujarat Kandla)
   (geographicSubregionOf Gujarat IND)
   (hasAccessTo IND SWIFT)
   (possesses IND Money)))


(define (problem "Iran Oil Sales")
    (:situation India)
  (:requirements :counterplanning)
  (:objects Mersk1 - TankerShip)
  (:planner IRN)
  (:init (possesses IRN CrudeOil)
	 (located Mersk1 PersianGulf))
  (:goal (sold IRN CrudeOil IND)))
|#