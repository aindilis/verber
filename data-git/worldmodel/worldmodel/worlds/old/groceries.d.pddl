;; $VAR1 = {
;;           'Includes' => {
;;                           'GROCERIES' => {
;;                                            'busroute' => 1
;;                                          }
;;                         },
;;           'Units' => undef
;;         };

(define
 (domain GROCERIES)
 (:requirements :typing)
 (:types person object bus - object stop - location)
 (:predicates
  (at ?o - object ?s - location)
  (can-ride-bus ?p - person)
  (has-groceries ?p - person)
  (has-store ?s - stop))
 (:functions
  (transit-time ?b - bus ?s1 ?s2 - stop))
 (:durative-action BuyGroceries :parameters
  (?p - person ?s - stop) :duration
  (= ?duration 1.0) :condition
  (and
   (over all
    (at ?p ?s))
   (over all
    (has-store ?s))) :effect
  (and
   (at end (has-groceries ?p))))
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