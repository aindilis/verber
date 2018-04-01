(in-package :ap)

;; physob is an example of an abstract domain in an application that 
;;  would normally have a cascade of more specialized domains.

(define (domain physob)
    (:requirements :object-fluents)
  (:extends foaf event)			; foaf defines Agent class
  (:predicates
   (possesses ?a - Agent ?o - object) 
   (contains ?o1 ?o2 - object)
   ;;(containedBy ?o2 ?o1 - object)
   (contained_by ?o2 ?o1 - object))
  (:functions				; functions are predicates who's range has cardinality 1
   (size - fact ?o - object)		; default range is number. facts are monotonic.
   (possessed_by ?o - object) - Agent
   ;;(possessedBy ?o - object) - Agent
   )
  ;; constants are objects available in all domains that extends
  ;;   the domain in which the constants are defined.
  (:constants nothing - Thing)
  (:init				; This proposition will be true in 
   (size nothing 0))			;  all initial-situations of all extensions
  (:axiom
   :vars (?a - Agent
	  ?o1 ?o2 - object)
   :context (and (contains ?o1 ?o2)	; put least-used first
		 (possessed_by ?o1 ?a)	; important to use function!
		 ;;(possessedBy ?o1 ?a)
		 (not (= ?o2 nothing))
		 (not (= ?o1 ?o2)))
   :implies (possessed_by ?o2 ?a)	; inverseOf will assert (possesses ?a ?o2) 
   ;;(possessedBy ?o2 ?a)
   :comment "possesses/possessed_by is transitive over contains")
  (:axiom
   :vars (?o1 ?o2 - object)
   :context (and (contains ?o1 ?o2)
		 (contains ?o1 nothing)
		 (not (= ?o2 nothing))
		 (not (= ?o1 ?o2)))
   :implies (not (contains ?o1 nothing))
   :documentation "can contain multiple things, but not something and nothing"))

#| move to your domain
(define (action Obtain)
    :precondition (not (instance ?o ControlledSubstance))
    :effect (possesses ?a ?o)
    :label ("Obtain" ?o)		; see *pprint-plan*
    :comment "change possession of an object")
|#

(inverseOf 'possessed_by 'possesses)
;;(inverseOf 'possessedBy 'possesses)
;;(inverseOf 'containedBy 'contains)
(inverseOf 'contained_by 'contains)
