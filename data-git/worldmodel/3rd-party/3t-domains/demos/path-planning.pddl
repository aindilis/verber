(in-package :ap)

(define (domain path-planning)
    (:extends Geography)
  (:requirements :domain-axioms :durative-actions :action-expansions)
  (:types Room - Location	       
	  Hallway Stairway - Path)
  (:predicates
   (visited ?l - Location))
  (:functions
   (randomWalk ?a - Agent))   
  (:axiom 
   :vars (?agent - Agent
	  ?location - Location)
   :context (located ?agent ?location)
   :implies (visited ?location)
   :documentation "prevent cycles")
  ;;--actions
  (:action move
    :parameters (?a - Agent
		 ?current ?new - Location)
    :precondition (and (located ?a ?current)
		       (connected ?current ?new))
    :effect (and (located ?a ?new)
		 (not (located ?a ?current)))
    :duration 1.0)
  (:action getCloser
    :parameters (?a - Agent
		 ?current ?nearer ?new - Location)
    :precondition (and (located ?a ?current)
		       (connected ?current ?nearer)
		       (not (connected ?current ?new))
		       (not (visited ?nearer)) ; necessary to avoid cycles
		       )
    :expansion (series
		(located ?a ?nearer)
		(located ?a ?new))
    :effect (and (located ?a ?new)
		 (not (located ?a ?current)))
    :duration 2.5
    :documentation "try to get closer. Use of
                    visited preconditon prevents cycles")
  )

#| this does not work because of visited predicate
(define (action Random_Walk)
    :parameters (?p - Agent
		    ?steps - Number)
    :expansion (series
		(forall (?dest - (random-list ?steps (all-instances Location)))
			(located ?p ?dest)))
    :effect (randomWalk ?p ?steps)
    :comment "demo action showing use of forall, random-list")
|#

(define (action Random_Walk)
    :parameters (?p - Agent
		    ?steps - Number)
    :vars (?current-loc - (located ?p)
	   ?next-loc - (select-random (connected-neighbors ?current-loc))
	   ?steps-left - (1- ?steps))
    :precondition (> ?steps 0)
    :expansion (series
		(located ?p ?next-loc)
		(randomWalk ?p ?steps-left))
    :effect (randomWalk ?p ?steps)
    :comment "demo action showing use of recursion. allows return to visited loc")

(define (action Walk_done)
    :parameters (?p - Agent)
    :effect (randomWalk ?p 0)
    :comment "needed to terminate Random Walk")


(define (situation home)
    (:objects living dining kitchen - Room
	      down - Hallway
	      stair - Stairway
	      laundry power garage - Room
	      up - Hallway
	      bed1 bath1 loft
	      bed2 bed3 bath2 - Room
	      robot - Agent)
  (:init (connected living dining)
	 (connected living kitchen)
	 (connected dining down)
	 (connected kitchen down)
	 (connected down stair)
	 (connected stair laundry)
	 (connected laundry power)
	 (connected laundry garage)
	 (connected stair up)
	 (connected up loft)
	 (connected up bed1)
	 (connected bed1 bath1)
	 (connected up bed2)
	 (connected up bed3))
  )
  
(define (problem Laundry_to_Bath1)
    (:situation home)
  (:init (located robot garage))
  (:goal (located robot bath1)))

(define (problem Make_Random_Walk)
    (:situation home)
  (:init (located robot living))
  (:goal (randomWalk robot 8)))