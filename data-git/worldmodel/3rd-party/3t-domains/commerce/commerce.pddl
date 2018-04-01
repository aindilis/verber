(in-package :AP)

(define (domain commerce)
    (:extends physob communication)
  (:prefix "event")
  (:requirements :durative-actions)
  ;; most classes moved here from event.pddl
  (:types CommercialOrganization - BusinessEntity
	  FinancialOrganization TradeAssociation - CommercialOrganization
	  Bank - FinancialOrganization
	  BoardOfDirectors - Organization
	  FinancialDocument - Document
	  BillOfSales Invoice CreditCard SalesReceipt RealEstateAgreement - FinancialDocument
	  Lease Mortgage RentalAgreement - RealEstateAgreement
	  TaxIDDocument CommercialLicense - OfficialDocument
	  VendorsLicense - CommercialLicense
	  FinancialStatement - (and OfficialDocument FinancialDocument)
	  EconomicEntity - InformationContentEntity
	  Money Cost Price - EconomicEntity
	  Bitcoin - Money
	  RetailStoreAccount CreditCardAccount BrokerageAccount 
	  BankAccount BitcoinAccount - Account
	  ConsumableResource NonConsumableResource - PhysicalEntity ; not a Resource so no designator
	  Commodity Merchandise - ConsumableResource
	  BulkCommodity - Commodity)
  (:predicates
   (hasFinancialResources ?c - Agent)
   (accountHolder ?e - Entity ?a - Account)
   (vendorFor ?a - Entity ?b - Thing)
   (vendorTo ?a ?b - Entity)
   (hasVendorsLicense ?a ?b - Entity)
   (doesBusinessWith ?a ?b - Entity)
   (customerFor ?a ?b - Entity)
   (sells ?org - Vendor ?o - PhysicalEntity)
   (businessAssociate ?a ?b - Entity)
   (hasFinancer ?a ?b - Entity)
   (produce ?a - Agent ?s - PhysicalEntity)
   (acquire ?a - Agent ?e - PhysicalEntity)
   (obtain ?a - Agent ?o - object)
   (sold ?seller - Agent ?thing - PhysicalEntity ?buyer - Customer)
   (purchased ?buyer - Customer ?thing - PhysicalEntity)
   (transactionReport ?buyer - Customer ?s - ControlledSubstance)
   ;; these are not :functions because one can make more than one at a time
   (transferFunds ?from ?to - Agent ?n - number)   
   (withdraw ?a - Agent ?n - number)
   (deposited ?a - Agent ?n - number))
  (:functions
   (hasInAccount ?p - Agent)
   (transactionAmount ?a - Thing)
   (hasPriceOf ?a - Thing))
  (:axiom
   :context (produce ?a ?o)
   :implies (possesses ?a ?o))
  (:axiom
   :context (purchased ?a ?o)
   :implies (possesses ?a ?o))
  (:axiom 
    :vars (?a - Agent
 	  ?e - PhysicalEntity)
    :context (acquire ?a ?e)
    :implies (possesses ?a ?e))
  (:axiom
   :vars (?a - Agent
	     ?o - object)
   :context (obtain ?a ?o)
   :implies (possesses ?a ?o))
  )

(define (action Make)
    :effect (produce ?a ?o)
    :probability 0.4
    :documentation "see Construct in commerce.pddl")

(define (action Obtain)
    :precondition (not (instance ?o ControlledSubstance))
    :effect (possesses ?a ?o)
    :label ("Obtain" ?o)		; see *pprint-plan*
    :comment "change possession of an object")

;;;-- commercial actions to change possession ---

(define (action Purchase)
    :parameters (?buyer - Agent
		 ?o - PhysicalEntity)
    :vars (?seller - Agent)
    :value ?seller
    :precondition (and (possesses ?seller ?o)
		       (possesses ?buyer Money)
		       ;;(contact ?buyer ?seller) ; know who it is
		       (not (instance ?o Money))
		       (not (instance ?o ControlledSubstance))
		       (not (= ?buyer ?seller)))
    :effect (and (possesses ?buyer ?o)
		 (purchased ?buyer ?o))
    :probability 0.9)

(define (action "Buy Controlled Substance")
    :subClassOf Purchase
    :parameters (?buyer ?seller - Agent
		 ?o - ControlledSubstance)
    :value ?seller
    :precondition (and (possesses ?seller ?o)
		       (possesses ?buyer Money)
		       (contact ?buyer ?seller)
		       (not (instance ?seller CommercialOrganization))
		       (not (= ?buyer ?seller)))
    :expansion (transferFunds ?buyer ?seller Money)
    :effect (and (possesses ?buyer ?o)
		 (purchased ?buyer ?o)
		 (sold ?seller ?o ?buyer)
		 )
    :probability 0.3)

(define (action "Purchase ControlledSubstance")
    :subClassOf Purchase
    :parameters (?buyer - Agent
		 ?o - ControlledSubstance)
    :vars (?seller - Agent)
    :value ?seller
    :precondition (and (possesses ?seller ?o)
		       (possesses ?buyer Money)
		       ;;(contact ?buyer ?seller)		       
		       (not (instance ?o Contraband))
		       (not (= ?buyer ?seller)))
    :effect (and (possesses ?buyer ?o)
		 (purchased ?buyer ?o)
		 ;;(sold ?seller ?o ?buyer)
		 (transactionReport ?buyer ?o))
    :probability 0.2
    :comment "commercial transaction causes transactionReport")

(define (action Rent)
    :parameters (?a - Agent
		 ?o - NonConsumableResource)
    :vars (?from - Agent)
    :value ?from
    :precondition (and (possesses ?from ?o)
		       (possesses ?a Money)
		       (not (instance ?o 'ControlledSubstance))
		       (not (= ?a ?from)))
    :effect (possesses ?a ?o)
    :probability 0.9)

(define (action "Rent Facility")
    :subClassOf Rent
    :parameters (?a - Agent
		    ?f - Facility)
    :precondition (possesses ?a Money)
    :effect (hasAccessTo ?a ?f)
    :probability 0.9)

;;;--- other ways to possess --

(define (action Steal)
    :subClassOf Remove
    :parameters (?a - Agent
		 ?o - PhysicalEntity)
    :vars (?from - Agent)
    :value ?from
    :precondition (and (possesses ?from ?o)
		       (not (instance ?o BulkCommodity))
		       (not (= ?a ?from)))
    :effect (and (possesses ?a ?o)
		 (not (possesses ?from ?o)))
    :probability 0.1)

;;;---- monitory transactions ---
#|
(define (durative-action Finance)
    :subClassOf Obtain
    :effect (possesses ?a Money)
    :duration 5.0)
|#

(define (durative-action MineBitcoin)
    :subClassOf Obtain
    :effect (and (possesses ?a Bitcoin)
		 (increase (hasInAccount ?a) 250000))   
    :duration 1.0
    :comment "mining Bitcoin produces about $250k/day")

#|
(define (action "Transfer Funds")
    :subClassOf Transfer
    :parameters (?from ?to - Agent
		       ?funds - Money)
  ;;  :precondition (and (not (instance ?from Country))
;;		       (not (instance ?to Country)))
    :expansion (series
		(withdraw ?from ?funds)
		(link (deposited ?to ?funds) :input ?from))
    :effect (transferFunds ?from ?to ?funds)
    :duration 1.0)

(define (action Withdraw)
    :subClassOf Remove
    :parameters (?p - Agent)
    :precondition (>= (hasInAccount ?p) ?amount)
    :effect (and (withdraw ?p ?amount)
		 (decrease (hasInAccount ?p) ?amount)))

(define (action Deposit)
    :subClassOf Move
    :parameters (?p - Agent)
    :value (?from - Agent)
    :effect (and (deposited ?p ?amount)
		 (increase (hasInAccount ?p) ?amount)))

(define (problem "Test transfer")
    (:objects Peter Paul - Person)
    (:init (hasInAccount Peter 500)
	   (hasInAccount Paul 100))
    (:goal (transferFunds Peter Paul 200)))
|#

;;; generic actions.  need to add preconditions 
(define (action "Transfer Money")
    :subClassOf Transfer
    :parameters (?from ?to - Agent)
    :expansion (series
		(withdraw ?from Money)
		(link (deposited ?to Money) :input ?from))
    :effect (transferFunds ?from ?to Money)
    :duration 1.0)

(define (action "Withdraw Money")
    :subClassOf Remove
    :parameters (?p - Agent)
    :effect (withdraw ?p Money))

(define (action "Deposit Money")
    :subClassOf Move
    :parameters (?p - Agent)
    :value (?from - Agent)
    :precondition (withdraw ?from Money)
    :effect (deposited ?p Money))
