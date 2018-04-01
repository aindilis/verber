(define
 (domain REQUIREMENT-TEST-UNIVERSAL-PRECONDITIONS)
 (:requirements :universal-preconditions)
 (:types type1 - object)
 (:predicates
  (pred1 ?obj - type1))
 (:action action1 :parameters
  (?o1 ?o2 - object) :precondition
  (and
   (pred1 ?o1)) :effect
  (and
   (pred1 ?o2))))