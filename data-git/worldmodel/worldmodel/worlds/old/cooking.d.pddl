;; actions to model

;; let's do a recipe from the CURD corpus

;; convert

;; need to ensure they know how to do each operation before doing it,
;; add a pedagogical aspect

;; plans are created from knowledge combined with planning skills

(define (domain cooking)

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
