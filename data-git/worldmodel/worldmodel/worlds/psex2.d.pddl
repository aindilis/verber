;; $VAR1 = {
;;           'Units' => undef,
;;           'Includes' => {}
;;         };

(define
 (domain PSEX2)
 (:requirements :durative-actions :fluents :derived-predicates :typing :timed-initial-literals :equality :negative-preconditions)
 (:types person entry - object unilang-entry sayer-index-entry pse-entry - entry)
 (:predicates
  (completed ?e - entry)
  (depends ?e1 ?e2 - entry)
  (eases ?e1 ?e2 - entry)
  (has-time-constraints ?e - entry)
  (possible ?e - entry)
  (provides ?e1 ?e2 - entry))
 (:functions
  (budget ?p - person)
  (costs ?e - entry)
  (duration ?e - entry)
  (earns ?e - entry))
 (:durative-action Complete :parameters
  (?e1 - entry ?p - person) :duration
  (= ?duration (duration ?e1)) :condition
  (and
   (over all
    (or
     (not
      (has-time-constraints ?e1))
     (possible ?e1)))
   (at start (>= (budget ?p) (costs ?e1)))
   (at start (not (exists (?e2 - entry) (and (depends ?e1 ?e2) (not (completed ?e2))))))
   (at start (or (not (exists (?e3 - entry) (provides ?e3 ?e1))) (exists (?e4 - entry) (and (provides ?e4 ?e1) (completed ?e4)))))
   (at start (not (completed ?e1)))) :effect
  (and
   (at end (completed ?e1))
   (at start (decrease (budget ?p) (costs ?e1)))
   (at end (increase (budget ?p) (earns ?e1))))))