(define (domain cycle)

 (:requirements :negative-preconditions :conditional-effects
  :equality :typing :fluents :durative-actions
  :derived-predicates)

 (:types 
  task - object
  )

 (:predicates
  (finished ?t - task)
  (pending ?t - task)
  (subtask ?t - task ?s - task)
  )

 (:functions
  (estimated-duration ?t - task)
  )

 (:durative-action complete-task
  :parameters (?t - task)
  :duration (= ?duration (estimated-duration ?t))
  :condition (and
	      (at start (pending ?t))
	      )
  :effect (and
	   (at end (finished ?t))
	   )
  )
 )
