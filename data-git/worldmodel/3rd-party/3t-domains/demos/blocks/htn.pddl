(in-package :AP)

;;; blocks world addressed using HTN planning (because AP does not do non-linear planning)
;;;  HTNs tell how to accomplish a goal by providing
;;;  recipies consisting of partially-ordered subgoals that get the job done.

(define (domain htn)
    (:comment "Demo of HTN planning in the blocks world")
  (:types Support - object		; object is PDDL for Thing
	  Block - Support)
  (:constants nothing - object
	      table - Support)
  (:predicates				; multi-valued
   (clear ?s - Support))
  (:functions				; single-valued, like owl:FunctionalProperty
   (holding) - object
   (on ?b - object) -  object)
  (:init 
   (clear table))			; you can always put a Block
  (:axiom				;  on the table
   :vars (?b1 ?b2 - Block)
   :context (on ?b1 ?b2)
   :implies (not (clear ?b2)))
  ;;=== HTN templates [with :expansion]
  (:action makeOn
	   :parameters (?block1 ?block2 - Block)
	   :precondition (not (clear ?block2))
	   :expansion (series
		       (clear ?block2)
		       (holding ?block1)
		       (on ?block1 nothing)
		       (on ?block1 ?block2))
	   :effect (on ?block1 ?block2))
  (:action put-on
	   :parameters (?block - Block
			?support - Support)
	   :precondition (and (clear ?support)
			      (not (holding ?block)))
	   :expansion (series 
		       (holding ?block)
		       (on ?block nothing)
		       (on ?block ?support))
	   :effect (on ?block ?support)
	   :comment "?support is already on clear, ready to pickup")
  (:action clear-top
	   :parameters (?block - Block)
	   :vars (?top - Block)
	   :precondition (and (on ?top ?block)
			      (not (clear ?top))
			      (not (= ?top ?block))) ; performance hack
	   :expansion (series
		       (clear ?top)
		       (clear ?block))
	   :effect (clear ?block)
	   :comment "If ?top is clear, just shove, not this")
  (:action drop-and-grasp
	   :parameters (?block - Block)
	   :vars (?y - Block)
	   :precondition (and (holding ?y)
			      (not (= ?y ?block)))
	   :expansion (series
		       (holding nothing)
		       (holding ?block))
	   :effect (holding ?block)
	   :comment "can only hold one thing at a time")
  (:action holding-by-unstack
	   :parameters (?block - Block)
	   :vars (?covering - Block)
	   :precondition (on ?covering ?block)
	   :expansion (series 
		       (clear ?covering)
		       (holding nothing)
		       (on ?covering table)
		       (holding ?block))
	   :effect (holding ?block)
	   :comment "when ?covering is on ?block")
  );;define domain 

;;; These are defined outside a domain definition to show that is allowed.  
;;; The domain defaults to *domain*, the last one defined.  In this case, htn.

(define (action pickup_and_putdown)
    :parameters (?block - Block)
    :vars (?top - Block
	   ?new-resting-place - Support)
    :precondition (and (on ?top ?block)
		       (clear ?top)
		       (clear ?new-resting-place)
		       ;; performance hack:
		       (not (= ?new-resting-place ?top))
		       (not (= ?new-resting-place ?block)))
    :expansion (series 
		(holding nothing)	; empty your hand if it isn't already
		(holding ?top)		; grasp it
		(on ?top nothing)	; lift it
		(on ?top ?new-resting-place)
		(holding nothing))	; ungrasp
    :effect (clear ?block))

;;;----  primitives, i.e., no :expansion  ----------

(define (action grasp)
    :parameters (?block - Block)
    :precondition (and (clear ?block)
		       (holding nothing))
    :effect (and (holding ?block)
		 (not (clear ?block))))

(define (action lift)
    :parameters (?block - Block
		 ?underneath - Support)
    :precondition (and (holding ?block)
		       (on ?block ?underneath))
    :effect (and (on ?block nothing)
		 (clear ?underneath)))

(define (action place-on-something)
    :parameters (?block - Block
		 ?something - Support)
    :precondition (and (holding ?block)
		       (on ?block nothing)
		       (clear ?something)
		       (not (= ?something ?block)))
    :effect (on ?block ?something))

(define (action release)
    :parameters (?block - Block)
    :vars (?something - Support)
    :precondition (and (holding ?block)
		       (on ?block ?something))
    :effect (and (holding nothing)
		 (clear ?block))
    :comment "done after place ?block on ?something")

;;;======= test problems ========

(define (situation heavy-on-medium-on-table)
    (:domain htn)
  (:objects heavy medium light - Block)
  (:init (holding nothing)
	 ;;small stack
	 (on heavy medium)
	 (on medium table)
	 ;; you can put light on heavy or on the table
	 (clear light))
  (:comment "these props are true for all the problems
             that specify this situation."))

(define (problem lift-heavy-off-medium)
  (:situation heavy-on-medium-on-table)
  (:init (clear heavy))			; note this in addition to those above
  (:goal (clear medium))
  (:comment "trivial problem. Just lift heavy off medium"))

(define (problem lift-heavy-and-light-off-medium)
  (:situation heavy-on-medium-on-table)
  (:init (on light heavy))		; make it a three-block tower
  (:goal (clear medium))		; heavy and light are on top of it
  (:comment "clear top has to do two steps"))

(define (problem restack)		; light
    (:domain htn)			; heavy
  (:situation heavy-on-medium-on-table)	; medium
  (:init (on light heavy))		; table
  (:goal (series			; Accomplish in this order:
	  (on light table)
	  (on medium light)
	  (on heavy medium)))
  (:comment "heavy on medium on light on table"))

#| need to discover that the subgoals should be accomplished in order
(define (problem restack-and)		; light
    (:domain htn)			; heavy
  (:situation heavy-on-medium-on-table)	; medium
  (:init (on light heavy))		; table
  (:goal (and				; Accomplish in any order
	  (on light table)
	  (on medium light)
	  (on heavy medium)))
  (:comment "heavy on medium on light on table"))
|#

;;;----------
;;; The point of HTN planning is that you avoid search by order subgoals.
;;; This classic problem is difficult without the first subgoal
;;;  Otherwise one might first put light on heavy and then have to 
;;;   clear it or first put medium on light and not be able to pick it up
;;;   to put the short stack on heavy.

;;; Here is a way to cheat by using a complex goal that tells the planner
;;;   what order to accomplish the goals:

(define (situation Sussman_situation)
    (:objects C A B - Block)
  (:init (holding nothing)
	 ;; C -> A -> table
	 (clear C)
	 (on C A)
	 (on A table)
	 ;; B -> table
	 (clear B)
	 (on B table)))  

(define (problem Standard_Sussman)
    (:situation Sussman_situation)
  (:goal (and (on A B)
	      (on B C))))

(define (problem Micromanaged_Sussman)
    (:situation Sussman_situation)
  (:goal (series 
	  (on C table)		; this is cheating
	  (on B C)
	  (on A B)))
  (:comment "A -> C -> B -> table"))

(define (problem grasp_C)
    (:situation Sussman_situation)
  (:goal (holding C))
  (:comment "simplest test for belief net"))

(define (problem Sussman_step-1)
    (:situation Sussman_situation)
  (:goal (on C table))
  (:comment "more complicated test for belief net"))