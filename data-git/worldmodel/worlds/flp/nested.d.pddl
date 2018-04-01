;; $VAR1 = {
;;           'Units' => undef,
;;           'Includes' => {}
;;         };

(define
 (domain nested)
 (:requirements :typing :timed-initial-literals :equality :disjunctive-preconditions :durative-actions :derived-predicates :negative-preconditions :fluents :conditional-effects)
 (:types billtype agent - object)
 (:predicates
  (paybill ?agent - agent ?bill - billtype)
  (stillalive ?agent - agent))
 (:durative-action gohomeless :parameters
  (?agent - agent ?bill - billtype) :duration
  (= ?duration 0.5) :condition
  (and
   (at start (paybill ?agent ?bill))) :effect
  (and
   (at end (stillalive ?agent)))))