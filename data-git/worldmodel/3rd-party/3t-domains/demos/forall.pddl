(in-package :ap)

;;; the syntax of FORALL is:
;;;   (forall (?variable - <type or a function returning a list>)
;;;      (<predicate> ... ?variable ...))
;;; results in an expansion of this sort:
;;;   (parallel
;;;      (<predicate> ... ?VAR1 ...)
;;;      ...
;;;      (<predicate> ... ?VARn ...))  where n = how many
;;; 
;;; FOREACH is similar, but it results in a series of subgoals:
;;;  (foreach ...) results in:
;;;    (series
;;;      (<predicate> ... ?VAR1 ...)
;;;      ...
;;;      (<predicate> ... ?VARn ...))  where n is how many of type
;;;
;;; if used in an axiom, forall => must hold for every ?variable
;;;            foreach doesn not make sense in an axiom.

;;;-- a domain for testing:

(define (domain simple-forall-test)
    (:documentation "test FORALL,:EXECUTE in action definition
                     Note the requirement that makes :EXECUTE work.")
  (:requirements :action-expansions :multi-agent :domain-axioms
		 :executable-actions  ;; so (execute *problem*) does something
		 :true-negation) ;; cause awake to be predicate
  (:types Person - Agent
	  message activity - object)
  (:constants execute-daily-schedules available - message
	      sleep - activity)
  (:predicates (activities-handled ?p - planner ?m - message)
	       (activity-list-handled - predicate ?a - Agent)
	       (task-performed ?a - Agent ?t - activity)
	       (presence ?a - Agent ?m - message)
	       (awake ?a - Agent))
  (:action carry-out-activities
    :parameters (?planner - planner)
    :precondition (forall (?agent - Person)
		     (presence ?agent available))
    :expansion (parallel
		(forall (?agent - Person) 
			(activity-list-handled ?agent)))
    :effect (activities-handled ?planner execute-daily-schedules)
    :documentation "top-most action. Note ?agent is NOT a parameter.
                    If it was, that's cool too."))

;;;--- dummy functions for testing
;;;    Defining these could have been done with a file load
;;;     (compile-file "<pathname>" :load-after-compile t)

(defun get-available-agents (type)
  "dummy. Returns all objects in *domain* of TYPE"
  (all-instances type))

(defun get-agent-tasks (agent)
  "dummy. This could return them in order, for example."
  (declare (ignore agent)(special sleep))
  (remove sleep (all-instances 'activity)))

;;;--- HTN action that demonstrates use of forall consruct

(define (action perform-activities)
    :parameters (?agent - Person)
    :precondition (presence ?agent available)
    :expansion (series
		(awake ?agent)
		(forall (?task - (get-agent-tasks ?agent))
		 (task-performed ?agent ?task)))
    :effect (activity-list-handled ?agent)
    :documentation 
    "demo (1) using function instead of a type in forall.
          (2) forall implies temporal relation PARALLEL
            [foreach would imply SERIES]")

;;;--- base-level actions that include AP's :execute extension
;;;    which will cause user-defined code to execute (if implemented)

(defun tell-user (&rest args)
  "test :execute directive"
  ;; return non-NIL => action succeeds, NIL => action keeps executing
  (ask-user-p "action=~s args=~s" *current-action* args))

(define (action perform-task)
    :parameters (?agent - Person
		 ?task - activity)
    :precondition (and (awake ?agent)
		       (not (= ?task sleep)))
    :execute (tell-user ?task)
    :effect (task-performed ?agent ?task)
    :documentation "primitive action"
    :probability 0.9)

(define (action rise-and-shine)
    :parameters (?agent - Person)
    :precondition (not (awake ?agent))
    :execute (tell-user ?agent)
    :effect (awake ?agent)
    :probability 0.99
    :documentation "test getting the right order")

(define (action go-to-sleep)
    :parameters (?agent - Person)
    :precondition (awake ?agent)
    :execute (tell-user ?agent)
    :effect (and (task-performed ?agent sleep)
		 (not (awake ?agent)))
    :duration 8.0
    :probability 0.95
    :documentation "test modal truth in parallel tasks")

;;;--- test problem:

(define (problem easy-test)
    (:objects jose joe_bob - Person
	      eat clean - activity)
  (:planner pete)
  (:init (presence joe_bob available)
	 (presence jose available)
	 (awake jose)
	 (not (awake joe_bob)));;needed because :true-negation
  (:goal (activities-handled pete execute-daily-schedules))
  )
	 