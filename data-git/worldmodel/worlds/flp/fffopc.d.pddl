;; $VAR1 = {
;;           'Units' => undef,
;;           'Includes' => {}
;;         };

(define
 (domain fffopc)
 (:requirements :typing :conditional-effects :derived-predicates :negative-preconditions :disjunctive-preconditions :durative-actions :fluents :equality :timed-initial-literals)
 (:types self location agent - object)
 (:predicates
  (atLocation ?s - self ?a - agent ?l - location)
  (knows ?s - self ?a - agent ?arg2 - self)
  (neg ?s - self ?arg1 - self))
 (:durative-action learn :parameters
  (?a - agent ?v1v1 ?v1v2 ?v1v3 ?v2v1 - self) :duration
  (= ?duration 1.0) :condition
  (and
   (at start (and (neg ?v1v1 ?v1v2) (knows ?v1v2 ?a ?v1v3)))) :effect
  (and
   (at end (and (not (neg ?v1v1 ?v1v2)) (not (knows ?v1v2 ?a ?v1v3))))
   (at end (and (knows ?v2v1 ?a ?v1v3))))))