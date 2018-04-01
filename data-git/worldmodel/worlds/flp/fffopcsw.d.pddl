;; $VAR1 = {
;;           'Units' => undef,
;;           'Includes' => {}
;;         };

(define
 (domain fffopcsw)
 (:requirements :fluents :equality :typing :derived-predicates :timed-initial-literals :durative-actions :disjunctive-preconditions :negative-preconditions :conditional-effects)
 (:types pred myObject id - value value arg - object location agent - myObject)
 (:predicates
  (argIsa ?s - id ?arg - arg ?value - value))
 (:durative-action learn :parameters
  (?a - agent ?v1v1 ?v1v2 ?v1v3 ?v2v1 - id) :duration
  (= ?duration 1.0) :condition
  (and
   (at start (and (argIsa ?v1v1 a0 neg) (argIsa ?v1v1 a1 ?v1v2) (argIsa ?v1v2 a0 knows) (argIsa ?v1v2 a1 ?a) (argIsa ?v1v2 a2 ?v1v3)))) :effect
  (and
   (at end (and (not (argIsa ?v1v1 a0 neg)) (not (argIsa ?v1v1 a1 ?v1v2)) (not (argIsa ?v1v1 a2 null)) (not (argIsa ?v1v2 a0 knows)) (not (argIsa ?v1v2 a1 ?a)) (not (argIsa ?v1v2 a2 ?v1v3))))
   (at end (and (argIsa ?v2v1 a0 knows) (argIsa ?v2v1 a1 ?a) (argIsa ?v2v1 a2 ?v1v3))))))