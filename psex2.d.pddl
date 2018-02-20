(define

 (domain PSEX2)

 (:timing
  (units 0000-00-00_01:00:00)
  )

 (:requirements :timed-initial-literals :negative-preconditions
  :equality :typing :fluents :durative-actions
  :derived-predicates)

 (:types
  unilang-entry person - object
  )

 (:predicates
  (completed ?e - unilang-entry)
  (depends ?e1 ?e2 - unilang-entry)
  (provides ?e1 ?e2 - unilang-entry)
  (eases ?e1 ?e2 - unilang-entry)
  (possible ?e - unilang-entry)
  (has-time-constraints ?e - unilang-entry)
  )

 (:functions
  (costs ?e - unilang-entry)
  (earns ?e - unilang-entry)
  (budget ?p - person)
  (duration ?e - unilang-entry)
  )

 (:durative-action Complete
  :parameters (?e1 - unilang-entry ?p - person)
  :duration (= ?duration (duration ?e1))
  :condition (and
              ;; ensure we have enough money                                                                                                                                                                        
              (over all
               (or
                (not (has-time-constraints ?e1))
                (possible ?e1)))
              (at start
               (>= (budget ?p) (costs ?e1))
               )
              ;; make sure there are no unsatisfied preconditions                                                                                                                                                   
              (at start
               (not
                (exists (?e2 - unilang-entry)
                 (and
                  (depends ?e1 ?e2)
                  (not (completed ?e2))
                  ))))
              ;; make sure if a provides exists one is used                                                                                                                                                         
              (at start
               (or
                (not
                 (exists (?e3 - unilang-entry)
                  (provides ?e3 ?e1)))
                (exists (?e4 - unilang-entry)
                 (and
                  (provides ?e4 ?e1)
                  (completed ?e4)))))
              (at start (not (completed ?e1)))
              )
  :effect (and
           (at end (completed ?e1))
           (at start (decrease (budget ?p) (costs ?e1)))
           (at end (increase (budget ?p) (earns ?e1)))
           )
  )
 )
