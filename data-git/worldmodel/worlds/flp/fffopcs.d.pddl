;; $VAR1 = {
;;           'Includes' => {},
;;           'Units' => undef
;;         };

(define
 (domain fffopcs)
 (:requirements :derived-predicates :fluents :durative-actions :conditional-effects :equality :timed-initial-literals :disjunctive-preconditions :negative-preconditions :typing)
 (:types pred idOrObject - object location agent - myObject myObject id - idOrObject)
 (:predicates
  (triple ?s - id ?p - pred ?arg1 ?arg2 - idOrObject))
 (:durative-action learn :parameters
  (?a - agent ?v1v1 ?v1v2 ?v1v3 ?v2v1 - id) :duration
  (= ?duration 1.0) :condition
  (and
   (at start (and (triple ?v1v1 neg ?v1v2 null) (triple ?v1v2 knows ?a ?v1v3)))) :effect
  (and
   (at end (and (not (triple ?v1v1 neg ?v1v2 null)) (not (triple ?v1v2 knows ?a ?v1v3))))
   (at end (and (triple ?v2v1 knows ?a ?v1v3))))))