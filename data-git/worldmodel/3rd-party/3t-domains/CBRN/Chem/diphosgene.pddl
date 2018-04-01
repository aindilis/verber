;;;; sample problem in CBRN based on reading Wikipedia\
;;;; why diphosgene?
;;;; because it is a WMD
;;;; but probably not something anybody would make
;;;; useful info on wikipedia
;;;; simple but complex enough to be interesting

;;; Make diphosgene (https://en.wikipedia.org/wiki/Diphosgene)
;;; - Path 1: Chlorine gas + methyl chloroformate with UV light
;;; - Path 2: Chlorine gas + methyl formate with UV light
;;;   o methyl formate production path 1: methanol + formic acid
;;;   o methyl formate production path 2: methanol + carbon monoxide with a
;;;     base 
;;;     * commonly used base: sodium methoxide
;;; ie, 
;;; - obtain knowledge (search Wikipedia)
;;; - obtain equipment (reaction vessel, UV light)
;;; - obtain precursors (...)
;;; - recurse to obtain precursors to those
;;; - react
;;; - result = diphosgene
;;; - store

;;; SodiumMethylate (APL's version of Sodium Methoxide, a Base, but not
;;;                 given as a base in the ontology)

(in-package :ap)

(define (domain diphosgene)
    (:extends AGENT ChemAgent)
  (:predicates
   (weaponize ?a - Agent ?e - Entity))
  (:init
   (containsInformation wikipedia.org Diphosgene))
  ;; the axiom doesn't do all produce->possess so the BN linkage is odd
  #|(:axiom
   :vars (?a - Agent)
   :context (produce ?a ?e)
   :implies (possesses ?a ?e))|#
  )

;;; axiom for weaponize -> possesses

;;(remove-action 'Purchase)
;;(remove-action 'Obtain)
(remove-action 'Make)

(define (action "Make Diphosgene Weapon")
    :subClassOf Weaponize
    :parameters (?a - Agent)
    :vars (?p - Person)
    :expansion (series
                (knowsAbout ?p Diphosgene)
                (parallel
                 (possesses ?p ChlorineGas)
                 (possesses ?p UltravioletLamp)
                 (possesses ?p ReactionVessel))
                (produce ?p Diphosgene)
                (store ?p Diphosgene))                 
    :effect (weaponize ?a Diphosgene)
    :probability 0.2)

(define (action "Produce Diphosgene using MethylChloroformate")
    :subClassOf Make
    :parameters (?p - Person)
    :precondition (and (knowsAbout ?p Diphosgene)
                       (possesses ?p ChlorineGas)
                       (possesses ?p UltravioletLamp)
                       (possesses ?p ReactionVessel))
    :expansion (possesses ?p MethylChloroformate)
               ;;(series
               ;; (possesses ?p MethylChloroformate)
               ;; (react ?p ...)          ;? need predicate and operator
               ;; )
    :effect (and (produce ?p Diphosgene)
                 (possesses ?p Diphosgene))
    :probability 0.2)

(define (action "Produce Diphosgene using MethylFormate")
    :subClassOf Make
    :parameters (?p - Person)
    :precondition (and (knowsAbout ?p Diphosgene)
                       (possesses ?p ChlorineGas)
                       (possesses ?p UltravioletLamp)
                       (possesses ?p ReactionVessel))
    :expansion (produce ?p MethylFormate)
    :effect (and (produce ?p Diphosgene)
                 (possesses ?p Diphosgene))
    :probability 0.2)

(define (action "Produce MethylFormate using FormicAcid")
    :subClassOf Make
    :parameters (?p - Person)
    :precondition (possesses ?p ReactionVessel)
    :expansion (parallel
                (possesses ?p Methanol)
                (possesses ?p FormicAcid))
    :effect (and (produce ?p MethylFormate)
                 (possesses ?p MethylFormate))
    :probability 0.2)

(define (action "Produce MethylFormate using CarbonMonoxide")
    :subClassOf Make
    :parameters (?p - Person)
    :precondition (possesses ?p ReactionVessel)
    :expansion (parallel
                (possesses ?p Methanol)
                (possesses ?p CarbonMonoxide)
                (possesses ?p Base))
    :effect (and (produce ?p MethylFormate)
                 (possesses ?p MethylFormate))
    :probability 0.2)
                
(define (action "Store Diphosgene")
    :subClassOf Keep
    :parameters (?p - Person)
    :precondition (possesses ?p Diphosgene)
    :expansion (possesses ?p Container)
    :effect (store ?p Diphosgene)
    :probability 0.9)

;;; redefine 
(define (action Obtain)
    :precondition (not (instance ?o ControlledSubstance))
    :effect (possesses ?a ?o)
    :probability 0.5
    :label ("Obtain" ?o)		; see *pprint-plan*
    :comment "change possession of an object")

;;;; Problems

(define (problem "Diphosgene")
    (:domain diphosgene)
  (:requirements :assumptions)
  (:objective Diphosgene)
  (:goal (weaponize Person Diphosgene)))

;;; get intent/attempt out of the BN --
(setq *add-intent* nil)

;;; make-belief-network produces disconnected net + things
;;; that are connected don't seem right, etc
