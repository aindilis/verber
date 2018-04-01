;; $VAR1 = {
;;           'Includes' => {},
;;           'Units' => undef
;;         };

(define
 (domain mealPlanningPantry)
 (:requirements :fluents :equality :durative-actions :derived-predicates :timed-initial-literals :negative-preconditions :conditional-effects :disjunctive-preconditions :typing)
 (:types SUPPLIER INSTANCE AGENT - object)
 (:predicates
  (consumed ?instance - INSTANCE)
  (consumed-by-agent ?instance - INSTANCE ?agent - AGENT))
 (:functions
  (caloric-intake ?agent - AGENT)
  (calories ?instance - INSTANCE))
 (:durative-action CONSUME :parameters
  (?agent - AGENT ?instance - INSTANCE) :duration
  (= ?duration 0.1) :condition
  (and
   (at start (not (consumed ?instance)))) :effect
  (and
   (at end (consumed ?instance))
   (at end (consumed-by-agent ?instance ?agent))
   (at end (increase (caloric-intake ?agent) (calories ?instance))))))