(in-package :ap)

;; action templates are :subClassOf these types

(define (domain DIMEFIL)
    (:comment "classes of actions")
  (:extends event ap international-commerce CBRNEChemical)
  (:requirements :durative-actions)
  (:types
   DIMEFILevent - ArtificialEvent
   Diplomatic Information Military Economic Financial Intelligence Legal
   - DIMEFILevent
   TreatyObligation Cooperate Demarche SecurityAssistance Abrogate - Diplomatic
   Communicate Disinformation - Information
   Blockade Strengthen Weaken Defend CovertOperations SecurityAssistance
   ShowOfForce - Military
   ArmedConflict - (and Military Conflict)
   Attack - ArmedConflict
   DirectAction - Attack
   Embargo Sanction ProvideAid StartMVNStatus EndMVNStatus Grow Shrink
   FreeTradeAgreement - Economic
   BusinessEvent Purchase Sell Loan SeizeAssets Sanction USBankAccess - Financial
   Search - Intelligence
   Judge Enforce InternationalCourtClaim LawEnforcement LawSuit Reparations - Legal 
   ;; other classes
   Treaty - InformationBearingEntity
   Nation - (and Country Planner)
   RogueState - Nation
   ;; things one can sell
   NaturalGas - (and HydrocarbonFuel BulkCommodity)
   CrudeOil - (and Oil HydrocarbonFuel BulkCommodity)
   )
  (:predicates				; properties
   (hasTreatyObligation ?a - Nation ?i - TreatyObligation)
   (partyTo ?a - Nation ?t - Treaty)
   (hasAllianceWith ?n1 ?n2 - Nation))
  (:constants
   IAEA - NonGovernmentalOrganization
   NATO - (and OrganizationOfCountries SecurityAssistance)
   USA - Nation
   NNPT - Treaty
   startRelations endRelations - Diplomatic
   counterProliferation mutualDefense - TreatyObligation
   startMilitarySales endMilitarySales - Sell
   )
  (:init
   (partyTo USA NNPT)
   (memberOf USA NATO))
  ;; These axioms point out that hasTreatyObligation should be 
  ;;  a 4-tuple having itself as its inverseOf  2016-11-28
  (:axiom
   :vars (?n - Nation)
   :context (partyTo ?n NNPT)
   :implies (hasTreatyObligation ?n counterProliferation))
  (:axiom 
   :vars (?n - Nation)
   :context (memberOf ?n NATO)
   :implies (hasTreatyObligation ?n mutualDefense))
  )

(inverseOf 'hasAllianceWith 'hasAllianceWith)

;;; diplomatic:  Snapback - reimpose sanctions
;;;     would CHI RUS enforce them?  no
;;; heavy water limit
;;;  (hasAccessTo IAEA Natanz)

;;-- financial/economic --

(define (action "Interdict Bank Transfers")
    :subClassOf USBankAccess
    :parameters (?n - Nation)
    :vars (?planner - (hasAdversary ?n))
    :precondition (and (hasAdversary ?planner ?n)
		       (= ?planner USA))
    :effect (not (hasAccessTo ?n SWIFT))
    :duration 10.0
    :probability 0.9
    :comment "sorry Israel, we're not going to do that to our friends")

(define (durative-action "Reimpose Sanctions")
    :subClassOf Abrogate
    :parameters (?n - Nation)
    :vars (?planner - (hasAdversary ?n))
    :precondition (and (hasAdversary ?planner ?n)
		       (= ?planner USA))
    :effect (over all (not (hasFinancialResources ?n)))
    :duration 10.0
    :probability 0.9)

;;; make some money

(defun potential-customers (nation)
  "return list of Nations that might buy Oil or Gas from NATION"
  (let ((adversaries (get-value 'hasAdversary nation)))
    (loop for country in (all-instances 'Nation)
	if (not (or (eql country nation)
		    (find country adversaries)
		    (find-if (lambda (s)(subclass-p s 'HydrocarbonFuel))
			     (get-value 'hasAccessTo country))))
	collect country)))

(define (action "Sell Hydrocarbon Fuel")
    :subClassOf Sell
    :parameters (?planner - Nation)
    :precondition (hasAccessTo ?planner HydrocarbonFuel)
    :expansion (covers-start
		(produce ?planner HydrocarbonFuel)
		(parallel
		 (forall (?buyer - (potential-customers ?planner))
			 (sold ?planner HydrocarbonFuel ?buyer))))
    :effect (hasFinancialResources ?planner))

(define (action "Produce Fuel")
    :subClassOf Develop
    :parameters (?a - Nation
		 ?f - HydrocarbonFuel)
  ;;  :vars (?field - (located ?f))
  ;;  :value ?field
    :precondition (hasAccessTo ?a ?f) ;;?field)
    :effect (produce ?a ?f)
    :duration 12.0)

(define (durative-action "Sell Fuel")
    :subClassOf Sell
    :parameters (?a ?buyer - Nation
		    ?f - HydrocarbonFuel)
    :condition (at start (possesses ?a ?f))
    :expansion (series 
		(transferFunds ?buyer ?a Money)
		;;(transport ?f ?a ?buyer)
		)
    :effect (at end (sold ?a ?f ?buyer))
    :probability 0.95
    :duration 12.0)
