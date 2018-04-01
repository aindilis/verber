
(define (domain perl)

 (:requirements :negative-preconditions :conditional-effects
  :equality :typing :fluents :durative-actions
  :derived-predicates)

 (:types 
  file dir - object
  script module - file
  )

 (:predicates
  (dir-has-file ?d - dir ?f - file)
  (is-executable ?f - file)
  (is-script ?f - file)
  (is-module ?f - file)
  (has-dependency ?m1 - module ?m2 - module)
  )

 (:functions
  )

 (:durative-action create-file
  :parameters (?f - file ?d - dir)
  :duration (= ?duration 0.1)
  :condition (and
	      (at start (not (dir-has-file ?d ?f)))
	      )
  :effect (and
	   (at end (dir-has-file ?d ?f))
	   )
  )

 (:durative-action make-executable
  :parameters (?f - file ?d - dir)
  :duration (= ?duration 0.1)
  :condition (and 
	      (at start (dir-has-file ?d ?f))
	      )
  :effect (and
	   (at end (is-executable ?f))
	   )
  )

 )
