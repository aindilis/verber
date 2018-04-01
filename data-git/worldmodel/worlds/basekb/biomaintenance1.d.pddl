;; $VAR1 = {
;;           'Units' => undef,
;;           'Includes' => {
;;                           'BASEKB_BIOMAINTENANCE1' => {}
;;                         }
;;         };

(define
 (domain BASEKB_BIOMAINTENANCE1)
 (:requirements :derived-predicates :typing)
 (:types)
 (:predicates
  (exhausted ?p - person)
  (tired ?p - person))
 (:durative-action eat :parameters
  (?p - person ?m - mealtype ?l - location) :duration
  (= ?duration (/ (how-filling ?m ?p) (rate-of-eating ?p))) :condition
  (and
   (at start (>= (quantity ?m ?l) 1))
   (at start (at-location ?p ?l))) :effect
  (and
   (at end (assign (hunger-level ?p) (- (hunger-level ?p) (how-filling ?m ?p))))
   (at end (assign (food-ingested ?p) (+ (food-ingested ?p) (how-filling ?m ?p))))
   (at end (assign (quantity ?m ?l) (- (quantity ?m ?l) 1)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action sleep :parameters
  (?p - person ?b - bed ?l - location) :duration
  (= ?duration 3) :condition
  (and
   (over all
    (at-location ?p ?l))
   (over all
    (at-location ?b ?l))
   (over all
    (not
     (exists
      (?o - object)
      (holding ?p ?o))))
   (at start (isolated ?l))) :effect
  (and
   (at end (not (exhausted ?p)))
   (at end (not (tired ?p)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action use-the-restroom :parameters
  (?p - person ?br - bathroom) :duration
  (= ?duration 0.25) :condition
  (and
   (over all
    (acceptable-to-perform-hygiene-actions ?p ?br))
   (over all
    (at-location ?p ?br))
   (at start (autonomous ?p))) :effect
  (and
   (at end (not (autonomous ?p))))))