;; $VAR1 = {
;;           'Units' => undef,
;;           'Includes' => {
;;                           'test1' => {
;;                                        'groceries' => 1
;;                                      }
;;                         }
;;         };

(define
 (domain test1)
 (:requirements :typing)
 (:types day-of-week date - string string person object bus - object stop - location)
 (:predicates
  (at-location ?ob - object ?l - location)
  (can-ride-bus ?p - person)
  (day-of-week ?date - date ?dow - day-of-week)
  (has-groceries ?p - person)
  (has-store ?s - stop)
  (pay-day ?date - date))
 (:functions
  (transit-time ?b - bus ?s1 ?s2 - stop))
 (:durative-action BuyGroceries :parameters
  (?p - person ?s - stop) :duration
  (= ?duration 1.0) :condition
  (and
   (over all
    (at-location ?p ?s))
   (over all
    (has-store ?s))) :effect
  (and
   (at end (has-groceries ?p))))
 (:durative-action RideBus :parameters
  (?p - person ?b - bus ?s1 ?s2 - stop) :duration
  (= ?duration (transit-time ?b ?s1 ?s2)) :condition
  (and
   (at start (at-location ?b ?s1))
   (at start (at-location ?p ?s1))
   (at start (can-ride-bus ?p))
   (at end (at-location ?b ?s2))) :effect
  (and
   (at end (at-location ?p ?s2))
   (at end (not (at-location ?p ?s1))))))