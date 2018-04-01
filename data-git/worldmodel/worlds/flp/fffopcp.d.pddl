;; $VAR1 = {
;;           'Units' => undef,
;;           'Includes' => {}
;;         };

(define
 (domain fffopcp)
 (:requirements :disjunctive-preconditions :equality :typing :fluents :negative-preconditions :conditional-effects :durative-actions :timed-initial-literals :derived-predicates)
 (:types self myObject - selfOrObject selfOrObject pred - object location agent - myObject)
 (:predicates
  (p0 ?p - pred ?s - self)
  (p1 ?p - pred ?s - self ?arg1 - selfOrObject)
  (p2 ?p - pred ?s - self ?arg1 ?arg2 - selfOrObject)
  (p3 ?p - pred ?s - self ?arg1 ?arg2 ?arg3 - selfOrObject))
 (:durative-action learn :parameters
  (?a - agent ?v1v1 ?v1v2 ?v1v3 ?v2v1 - self) :duration
  (= ?duration 1.0) :condition
  (and
   (at start (and (p1 neg ?v1v1 ?v1v2) (p2 knows ?v1v2 ?a ?v1v3)))) :effect
  (and
   (at end (and (not (p1 neg ?v1v1 ?v1v2)) (not (p2 knows ?v1v2 ?a ?v1v3))))
   (at end (and (p2 knows ?v2v1 ?a ?v1v3))))))