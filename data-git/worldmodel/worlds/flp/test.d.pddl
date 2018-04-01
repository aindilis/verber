;; $VAR1 = {
;;           'Includes' => {},
;;           'Units' => undef
;;         };

(define
 (domain flptest)
 (:requirements :derived-predicates :typing :timed-initial-literals :equality :conditional-effects :disjunctive-preconditions :durative-actions :fluents :negative-preconditions)
 (:types task - object)
 (:predicates
  (completed ?t - task))
 (:functions
  (time))
 (:durative-action complete :parameters
  (?t - task) :duration
  (= ?duration 0.1) :condition
  (and
   (at start (not (completed ?t)))) :effect
  (and
   (at end (completed ?t))
   (at end (assign (time) (total-time))))))