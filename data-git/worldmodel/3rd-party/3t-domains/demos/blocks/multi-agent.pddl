(in-package :AP)

(define (domain multi-agent)
    (:documentation "multi-armed robot")
  (:extends ap htn)				; has Planner and associated predicates
  (:requirements :multi-agent :durative-actions)
  (:types Arm - Agent)
  (:constants robot - Agent)
  (:functions (gripping ?a - Arm) - Block
	      (strength - fact ?a - Arm) ; range is Number if not specified
	      (charge ?p - Agent)
	      (mass - fact ?b - Block))
  (:axiom
   :vars (?arm1 ?arm2 - Arm)
   :context (holding nothing)
   :implies (and (gripping ?arm1 nothing)
		 (gripping ?arm2 nothing))))

;;;------ multi-agent operators --------------
;;; Note: according to PDDL 2.1, durative-action effects
;;;       must be temporally annotated.

(define (durative-action put-underneath)
    :parameters (?block1 ?block2 ?something - Block)
    :vars (?arm1 ?arm2 - Arm
	   ?support - object)
    :precondition (and (holding nothing)
		       (on ?block1 ?support)
		       (> (strength ?arm1)(mass ?block1))
		       (> (strength ?arm2)(mass ?block2))
		       (not (= ?arm1 ?arm2))
		       (not (= ?something ?block2))
		       (not (= ?something ?block1))
		       (not (= ?block1 ?block2)))
    :expansion (series
		(clear ?block2)
		(parallel (gripping ?arm1 ?block1)
			  (gripping ?arm2 ?block2))
		(covers (on ?block2 nothing) ;; lift it up
			(gripping ?arm1 nothing))
		(gripping ?arm2 nothing))
    :effect (and (at end (on ?block2 ?block1))
		 (at end (on ?something ?block2)))
    :duration 4.0
    :documentation "test temporal relations")

(defun 2-arm-duration (action-instance)
  "example duration function"
  (let ((block (gsv action-instance '?block)))
    (if (samep block 'heavy)
	2.0
      1.0)))

(define (durative-action 2-arm-grasp)
    :parameters (?block - Block)
    :vars (?arm1 ?arm2 - Arm)
    :condition (and (at start (clear ?block))
		    (at start (holding nothing))
		    (at start (not (= ?arm1 ?arm2))))
    :expansion (simultaneous
		(gripping ?arm1 ?block)
		(gripping ?arm2 ?block))
    :effect (at end (holding ?block))
    :documentation "holding is more abstract than gripping")

(define (durative-action 2-arm-lift)
    :parameters (?block - Block
		 ?something - object)
    :vars (?arm1 ?arm2 - Arm)
    :condition (and (at start (on ?block ?something))
		    (at start (gripping ?arm1 ?block))
		    (at start (gripping ?arm2 ?block))
		    (at start (not (= ?arm1 ?arm2)))
		    (at start (not (= ?block ?something)))
		    (over all (gripping ?arm1 ?block))
		    (over all (gripping ?arm2 ?block))
		    ;;(over all (> (+ (strength ?arm1)(strength ?arm2))(mass ?block)))
		    )
    :effect (and (at end (on ?block nothing))
		 (at end (clear ?something))
		 ;;(at end (decrease (charge robot)(mass ?block)))
		 );; test fluents
    :duration 1.0
    :documentation "when held by two arms")

(define (durative-action 2-arm-place)
    :parameters (?block ?something - Block)
    :vars (?arm1 ?arm2 - Arm)
    :precondition (and (on ?block nothing) ; you can use :precondition or :condition
		       (clear ?something)
		       (gripping ?arm1 ?block)
		       (gripping ?arm2 ?block)
		       (not (= ?arm1 ?arm2))
		       (not (= ?block ?something)))
    :effect (and (at end (on ?block ?something))
		 ;;(at end (decrease (charge robot)(mass ?block)))
		 )
    :duration 1.0
    :documentation "when held by two arms")

(define (durative-action multi-arm-release)
    :parameters (?block - Block)
    :vars (?arm1 ?arm2 - Arm)
    :precondition (and (gripping ?arm1 ?block)
		       (gripping ?arm2 ?block)
		       (not (= ?arm1 ?arm2)))
    :expansion (simultaneous
		(gripping ?arm1 nothing)
		(gripping ?arm2 nothing))
    :effect (and (at end (holding nothing))
                 (at end (clear ?block))
		 (at end (on ?block table)))
    :documentation "don't know that ?block was over table!! fix this")

;;;---- actions with no :expansion ---------------

(define (durative-action grasp)
    :parameters (?block - Block
		 ?arm - Arm)
    :condition (and (at start (clear ?block))
		    (at start (gripping ?arm nothing)))
    :effect (gripping ?arm ?block)
    :duration 0.5
    :probability-of-success 0.8
    :documentation "redefinition of grasp in blocks.pddl")

(define (durative-action 1-arm-lift)
    :parameters (?block - Block
		 ?something - object)
    :vars (?arm - Arm)
    :condition (and (at start (gripping ?arm ?block))
		    (at start (on ?block ?something))
		    (at start (not (= ?block ?something)))
		    (over all (< (mass ?block) (strength ?arm))))
    :effect (and (at end (clear ?something))
		 (at end (on ?block nothing))
		 (at end (decrease (charge robot) 10)))
    :duration 0.75
    :documentation "redefinition of 'lift' in blocks.pddl")

(define (durative-action let-go)
    :parameters (?block - Block
		 ?arm - Arm)
    :condition (at start (gripping ?arm ?block))
    :effect (and (at end (gripping ?arm nothing))
		 (at end (on ?block table)))
    :duration 0.1)

;;;======== situation and problem definitions ================

(define (situation two-arm)
    (:documentation "all the problems inherit this state")
  (:domain multi-agent)
  (:objects heavy medium light - Block
	    strong-arm weak-arm - Arm)
  (:init 
   ;;--first set of facts same as three-block in blocks.pddl
   (clear table)
   (holding nothing)			; robot and arms are not engaged
   (on medium table)
   (on heavy medium)
   (clear heavy)
   (on light table)
   (clear light)
   ;;--unique to multi-blocks
   (strength strong-arm 10)
   (strength weak-arm 7.5)
   (charge robot 100)
   (mass heavy 15)
   (mass medium 9)
   (mass light 6)))

(define (problem medium-on-light)
    (:domain multi-agent)
  (:situation two-arm)
  (:deadline 20.0)
  (:goal (on medium light)))

(define (problem light-on-covered-medium)
    (:domain multi-agent)
  (:situation two-arm)
  (:goal (on light medium)))

(define (problem heavy-on-light)
    (:domain multi-agent)
  (:situation two-arm)
  (:goal (on heavy light))) ;; force it to pick up heavy


