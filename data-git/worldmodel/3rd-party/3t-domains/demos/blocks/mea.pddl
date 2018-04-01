(in-package :ap)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 4 Op-blocks world
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; standard blocks world with no task decomposition
;; compare with blocks-domain-new.pddl that uses
;; :object-fluents which are basically predicates
;; but called :functions and where one uses = 
;; to specify that the function has a given value
;; in the input and output situations.

(define (domain BLOCKS)
  (:types block)
  (:predicates (on ?x - block ?y - block)
	       (ontable ?x - block)
	       (clear ?x - block)
	       (handempty)
	       (holding ?x - block)
	       )
  (:action pick-up
	   :parameters (?x - block)
	   :precondition (and (clear ?x) 
			      (ontable ?x) 
			      (handempty))
	   :effect (and (not (ontable ?x))
			(not (clear ?x))
			(not (handempty))
			(holding ?x)))
  (:action put-down
	   :parameters (?x - block)
	   :precondition (holding ?x)
	   :effect (and (not (holding ?x))
			(clear ?x)
			(handempty)
			(ontable ?x)))
  (:action stack
	   :parameters (?x - block ?y - block)
	   :precondition (and (holding ?x) 
			      (clear ?y))
	   :effect (and (not (holding ?x))
			(not (clear ?y))
			(clear ?x)
			(handempty)
			(on ?x ?y)))
  (:action unstack
	   :parameters (?x - block ?y - block)
	   :precondition (and (on ?x ?y) 
			      (clear ?x) 
			      (handempty))
	   :effect (and (holding ?x)
			(clear ?y)
			(not (clear ?x))
			(not (handempty))
			(not (on ?x ?y)))))

(define (problem BLOCKS-4-0)
    (:domain BLOCKS)
  (:objects D B A C - block)
  (:INIT 	
   (CLEAR C) 
   (CLEAR A) 
   (CLEAR B) 
   (CLEAR D) 
   (ONTABLE C) 
   (ONTABLE A)
   (ONTABLE B) 
   (ONTABLE D) 
   (HANDEMPTY))
  (:goal (AND (ON D C) 
	      (ON C B) 
	      (ON B A)))
  )
