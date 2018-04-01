;; $VAR1 = {
;;           'Units' => undef,
;;           'Includes' => {
;;                           'BASEKB_HYGIENE1' => {}
;;                         }
;;         };

(define
 (domain BASEKB_HYGIENE1)
 (:requirements :derived-predicates :typing)
 (:types hygiene-tool - tool towel article-of-clothing - laundry electric-razor - battery-powered-device shirt pants - article-of-clothing)
 (:predicates
  (acceptable-to-perform-hygiene-actions ?p - person ?l - location)
  (presentable ?p - person)
  (shaved ?p - person)
  (ship-shape)
  (showered ?p - person)
  (wearing ?person - person ?aoc - article-of-clothing))
 (:derived
  (acceptable-to-perform-hygiene-actions ?p - person ?br - bathroom)
  (has-permission-to-use ?p ?br))
 (:derived
  (presentable ?p - person)
  (and
   (shaved ?p)
   (showered ?p)))
 (:derived
  (ship-shape)
  (exists
   (?p - person ?la - laundry ?r - electric-razor ?t - towel ?l - location)
   (and
    (presentable ?p)
    (at-location ?la ?l)
    (at-location ?r ?l)
    (at-location ?t ?l))))
 (:durative-action shave :parameters
  (?r - electric-razor ?p - person ?l - location) :duration
  (= ?duration 0.25) :condition
  (and
   (over all
    (holding ?p ?r))
   (over all
    (acceptable-to-perform-hygiene-actions ?p ?l))
   (at start (>= (charge-level ?r) 0.25))
   (over all
    (at-location ?p ?l))) :effect
  (and
   (at end (shaved ?p))
   (at end (assign (charge-level ?r) (- (charge-level ?r) 0.25)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action shower :parameters
  (?p - person ?t - towel ?s - shower ?l - location) :duration
  (= ?duration 1) :condition
  (and
   (at start (at-location ?p ?l))
   (over all
    (at-location ?s ?l))
   (at start (use-is-required ?t))
   (over all
    (not
     (exists
      (?o - object)
      (holding ?p ?o))))) :effect
  (and
   (at end (showered ?p))
   (at end (assign (actions) (+ (actions) 1)))
   (at end (not (use-is-required ?t))))))