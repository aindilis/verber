;; $VAR1 = {
;;           'Units' => undef,
;;           'Includes' => {}
;;         };

(define
 (domain flpinventory)
 (:requirements :fluents :negative-preconditions :equality :derived-predicates :disjunctive-preconditions :typing :durative-actions :timed-initial-literals :conditional-effects)
 (:types type location agent - object)
 (:predicates
  (has-location ?a - agent ?l - location)
  (out-of-type ?t - type ?l - location))
 (:functions
  (has-inventory ?t - type ?l - location))
 (:durative-action consume :parameters
  (?a - agent ?l - location ?t - type) :duration
  (= ?duration 1.25) :condition
  (and
   (at start (has-location ?a ?l))
   (at start (> (has-inventory ?t ?l) 0))) :effect
  (and
   (at end (assign (has-inventory ?t ?l) (- (has-inventory ?t ?l) 1)))
   (at end (out-of-type ?t ?l))))
 (:durative-action resupply :parameters
  (?a - agent ?l - location ?t - type) :duration
  (= ?duration 1.25) :condition
  (and
   (at start (has-location ?a ?l))) :effect
  (and
   (at end (assign (has-inventory ?t ?l) (+ (has-inventory ?t ?l) 1))))))