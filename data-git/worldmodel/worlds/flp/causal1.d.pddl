;; $VAR1 = {
;;           'Units' => undef,
;;           'Includes' => {}
;;         };

(define
 (domain flpCausal1)
 (:requirements :typing :fluents :disjunctive-preconditions :equality :derived-predicates :timed-initial-literals :negative-preconditions :durative-actions :universal-preconditions :conditional-effects)
 (:types event condition - object)
 (:predicates
  (aboutToHappen ?e - event)
  (directlyCauses ?e1 ?e2 - event)
  (happened ?e - event)
  (indirectlyCauses ?e1 ?e2 - event)
  (reachable ?e - event)
  (staticCausalLaw ?e1 ?e2 - event ?c - condition))
 (:functions
  (actions))
 (:derived
  (aboutToHappen ?e2 - event)
  (exists
   (?e1 - event)
   (and
    (happened ?e1)
    (directlyCauses ?e1 ?e2)
    (not
     (happened ?e2)))))
 (:derived
  (indirectlyCauses ?e1 ?e3 - event)
  (exists
   (?e2 - event)
   (and
    (or
     (directlyCauses ?e1 ?e2)
     (indirectlyCauses ?e1 ?e2))
    (or
     (directlyCauses ?e2 ?e3)
     (indirectlyCauses ?e2 ?e3)))))
 (:derived
  (reachable ?e2 - event)
  (exists
   (?e1 - event)
   (and
    (happened ?e1)
    (or
     (directlyCauses ?e1 ?e2)
     (indirectlyCauses ?e1 ?e2)))))
 (:durative-action cause :parameters
  (?e1 ?e2 - event) :duration
  (= ?duration 1.0) :condition
  (and
   (at start (directlyCauses ?e1 ?e2))
   (at start (happened ?e1))
   (at start (not (happened ?e2)))) :effect
  (and
   (at end (happened ?e2))
   (at end (assign (actions) (+ (actions) 1))))))