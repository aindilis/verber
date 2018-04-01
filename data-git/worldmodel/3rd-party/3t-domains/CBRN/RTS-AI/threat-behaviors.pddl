(in-package :ap)

#| to add:
making money by hacking SWIFT
|#

(define (domain threat-behaviors)
    (:extends ap DIMEFIL AGENT capability air water weapon)
  (:requirements :durative-actions :domain-axioms)
  (:time-unit week)
  (:predicates
   (threaten ?c1 ?c2 - Country)
   )
  (:functions
   (hasPlan - fact ?w - Weapon) - Plan
   (hasIntentToAcquire ?a - Agent ?w - Weapon)
   (hasIntentToUse ?a - Agent ?w - Weapon)
   )
  (:axiom
   :vars (?a - Agent
	  ?w - Weapon
	  ?p - (hasPlan ?w))
   :context (performR&D ?a ?w)
   :implies (hasAccessTo ?a ?p)
   :comment "performR&D not quite subPropertyOf hasAccessTo")
  )

(remove-action 'Make)			; from commerce
#|
Acquire Materials
Move Materials to Safe Assembly Location
Assemble Device

Purchace or Steal Device

Move Device to US
Cross US Border

Move to Target
Device to Target
Detonate

Acqusition
Diversion
Proliferaction
Donation
Innovation

Elimination
Safeguard
Counter-Proliferation
Deterrance
Counter Trafficing
Homeland Defense
|#

(define (action Threaten)
    :parameters (?c1 ?c2 - Country
		     ?w - Weapon)
    :precondition (hasAdversary ?c1 ?c2)
    :expansion (series
		(acquire ?c1 ?w)
		(prepareForDelivery ?a ?w))
    :effect (threaten ?c1 ?c2))

;;;=== financing ====

(define (action "Sell Contraband")
    :subClassOf Sell
    :parameters (?a - RogueState)
#|    :expansion (series
		(produce ?a IllegalDrugs)
		(sold ?a IllegalDrugs DrugCartel))|#
    :effect (hasFinancialResources ?a)
    :probability 0.8
    :duration 12.0)
