;; $VAR1 = {
;;           'Includes' => {},
;;           'Units' => undef
;;         };

(define
 (domain mealPlanningPantry)
 (:requirements :typing :negative-preconditions :derived-predicates :fluents :conditional-effects :equality :disjunctive-preconditions :durative-actions :timed-initial-literals)
 (:types SUPPLIER INSTANCE AGENT - object)
 (:predicates
  (consumed ?instance - INSTANCE)
  (consumedByAgent ?instance - INSTANCE ?agent - AGENT)
  (notConsumed ?instance - INSTANCE)
  (replete ?agent - AGENT))
 (:functions
  (caloricIntake ?agent - AGENT)
  (calories ?instance - INSTANCE))
 (:durative-action CONSUME :parameters
  (?agent - AGENT ?instance - INSTANCE) :duration
  (= ?duration 0.1) :condition
  (and
   (at start (notConsumed ?instance))) :effect
  (and
   (at end (consumed ?instance))
   (at end (not (notConsumed ?instance)))
   (at end (consumedByAgent ?instance ?agent))
   (at end (increase (caloricIntake ?agent) (calories ?instance)))))
 (:durative-action ISREPLETE :parameters
  (?agent - AGENT) :duration
  (= ?duration 0.1) :condition
  (and
   (at start (>= (caloricIntake ?agent) 1500.0))
   (at end (<= (caloricIntake ?agent) 1900.0))) :effect
  (and
   (at end (replete ?agent)))))