;; $VAR1 = {
;;           'Units' => undef,
;;           'Includes' => {
;;                           'BASEKB_MISC1' => {}
;;                         }
;;         };

(define
 (domain BASEKB_MISC1)
 (:requirements :typing :derived-predicates)
 (:types date - text-string informational-object collection - object text-string set - informational-object)
 (:predicates
  (dirty ?o - object))
 (:functions
  (actions)
  (speed ?ob - object)
  (total-walking-distance))
 (:durative-action wait :parameters
  (?p - person ?l - location) :duration
  (= ?duration 0.25) :condition
  (and
   (over all
    (at-location ?p ?l))) :effect
  (and
   (at end (at-location ?p ?l)))))