(in-package :ap)

(define (domain international-commerce)
    (:extends commerce transportation internet)
  (:prefix "event")
  (:constants SWIFT - SecureNetwork)
  (:predicates
   (hasLogisticalResources ?c - Agent ?w - Thing)
   )
  (:axiom
   :vars (?c - Agent)
   :context (hasFinancialResources ?c)
   :implies (possesses ?c Money))
  )
  
(define (action "International Sale")
    :domain international-commerce
    :parameters (?buyer ?seller - Country
		 ?c - PhysicalEntity)
    :precondition (and (possesses ?seller ?c)
		       (possesses ?buyer Money))
    :expansion (series
		(link (purchased ?buyer ?c) :input ?seller)
		(transferFunds ?buyer ?seller Money)
		(transport ?c ?seller ?buyer)
		)
    :effect (sold ?seller ?c ?buyer))

(define (action InterbankTransfer)
    :subClassOf Transfer
    :parameters (?from ?to - Country)
    :precondition (and (hasAccessTo ?from SWIFT)
		       (hasAccessTo ?to SWIFT))
    :effect (transferFunds ?from ?to Money)
    :probability 0.99
    :duration 1.0)
