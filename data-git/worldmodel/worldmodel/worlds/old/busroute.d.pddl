;; $VAR1 = {
;;           'Includes' => {},
;;           'Units' => undef
;;         };

(define
 (domain BUSROUTE)
 (:requirements :typing)
 (:types person bus - object stop - location)
 (:predicates
  (at ?o - object ?s - location)
  (can-ride-bus ?p - person))
 (:functions
  (transit-time ?b - bus ?s1 ?s2 - stop))
 (:durative-action RideBus :parameters
  (?p - person ?b - bus ?s1 ?s2 - stop) :duration
  (= ?duration (transit-time ?b ?s1 ?s2)) :condition
  (and
   (at start (at ?b ?s1))
   (at start (at ?p ?s1))
   (at start (can-ride-bus ?p))
   (at end (at ?b ?s2))) :effect
  (and
   (at end (at ?p ?s2))
   (at end (not (at ?p ?s1))))))