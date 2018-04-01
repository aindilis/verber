(in-package :ap)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 4 Op-blocks world
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#|
standard blocks world with no task decomposition
compare with mea-blocks.pddl
The difference is that this one uses :object-fluents 
  which are like predicates but called :functions because
  (a) they can have at most one value in a given situation
      wherease a predicate might have more than one value
  (b) one uses = to test or assign a function value
Note:  the PDDL syntax for object-fluents (= (in-hand) no-block)
       is translated by AP to standard predicate-like preconditions 
       and effects to (in-hand no-block). Therefore, either syntax
       will yield the same result.
|#

(define (domain BLOCKS-object-fluents)
  (:requirements :typing :equality :object-fluents)
  (:types block)
  (:constants no-block - block)		; could be called "nothing"
  (:predicates (on-table ?x - block))
  (:functions (in-hand) - block
	      (on-block ?x - block) - block) ; what is in top of block ?x
  (:action pick-up
	   :parameters (?x - block)
	   :precondition (and (= (on-block ?x) no-block) 
			      (on-table ?x) 
			      (= (in-hand) no-block))
	   :effect (and (not (on-table ?x))
			(assign (in-hand) ?x)))
  (:action put-down
	   :parameters (?x - block)
	   :precondition (= (in-hand) ?x)
	   :effect (and (assign (in-hand) no-block)
			(on-table ?x)))
  (:action stack
	   :parameters (?x - block ?y - block)
	   ;; at least in AP, could write (in-hand ?x) (on-block ?y no-block)
	   :precondition (and (= (in-hand) ?x) 
			      (= (on-block ?y) no-block))
	   :effect (and (assign (in-hand) no-block)
			(assign (on-block ?y) ?x)))
  (:action unstack
	   :parameters (?x - block ?y - block)
	   :precondition (and (= (on-block ?y) ?x) 
			      (= (on-block ?x) no-block) 
			      (= (in-hand) no-block))
	   :effect (and (assign (in-hand) ?x)
			(assign (on-block ?y) no-block))))

(define (problem BLOCKS-4-0)
    (:domain BLOCKS-object-fluents)
  (:objects D B A C - block)
  (:INIT 	
   (= (on-block C) no-block) 
   (= (on-block A) no-block) 
   (= (on-block B) no-block) 
   (= (on-block D) no-block)
   (on-table C) 
   (on-table A)
   (on-table B) 
   (on-table D)
   (= (in-hand) no-block)
   )
  (:goal (AND (= (on-block C) D) 
	      (= (on-block B) C) 
	      (= (on-block A) B))))
