;; $VAR1 = {
;;           'Includes' => {},
;;           'Units' => '0000-00-00_01:00:00'
;;         };

(define
 (domain PSEX)
 (:requirements :equality :durative-actions :fluents :typing :negative-preconditions :timed-initial-literals :derived-predicates)
 (:types unilang-entry person - object)
 (:predicates
  (completed ?e - unilang-entry)
  (depends ?e1 ?e2 - unilang-entry)
  (eases ?e1 ?e2 - unilang-entry)
  (has-time-constraints ?e - unilang-entry)
  (possible ?e - unilang-entry)
  (provides ?e1 ?e2 - unilang-entry))
 (:functions
  (budget ?p - person)
  (costs ?e - unilang-entry)
  (duration ?e - unilang-entry)
  (earns ?e - unilang-entry))
 (:durative-action Complete :parameters
  (?e1 - unilang-entry ?p - person) :duration
  (= ?duration (duration ?e1)) :condition
  (and
   (over all
    (or
     (not
      (has-time-constraints ?e1))
     (possible ?e1)))
   (at start (>= (budget ?p) (costs ?e1)))
   (at start (not (exists (?e2 - unilang-entry) (and (depends ?e1 ?e2) (not (completed ?e2))))))
   (at start (or (not (exists (?e3 - unilang-entry) (provides ?e3 ?e1))) (exists (?e4 - unilang-entry) (and (provides ?e4 ?e1) (completed ?e4)))))
   (at start (not (completed ?e1)))) :effect
  (and
   (at end (completed ?e1))
   (at start (decrease (budget ?p) (costs ?e1)))
   (at end (increase (budget ?p) (earns ?e1))))))