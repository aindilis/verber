;; $VAR1 = {
;;           'Units' => undef,
;;           'Includes' => {
;;                           'BASEKB_CHORES1' => {}
;;                         }
;;         };

(define
 (domain BASEKB_CHORES1)
 (:requirements :typing :derived-predicates)
 (:types bedding - laundry laundry-load - container)
 (:predicates
  (location-is-clean ?o - location)
  (wet ?la - laundry))
 (:durative-action clean-location :parameters
  (?p - person ?l - location) :duration
  (= ?duration 0.25) :condition
  (and
   (over all
    (at-location ?p ?l))) :effect
  (and
   (at end (not (dirty ?l)))))
 (:durative-action dry-laundry-load :parameters
  (?p - person ?d - laundry-dryer-machine ?l - location ?ll - laundry-load ?la1 ?la2 ?la3 - laundry) :duration
  (= ?duration 0.75) :condition
  (and
   (at start (at-location ?p ?l))
   (at start (at-location ?ll ?l))
   (at start (at-location ?d ?l))
   (over all
    (is-contained-by ?la1 ?ll))
   (over all
    (is-contained-by ?la2 ?ll))
   (over all
    (is-contained-by ?la3 ?ll))
   (at start (wet ?la1))
   (at start (wet ?la2))
   (at start (wet ?la3))
   (at start (>= (cash ?p) (fee-for-use ?d)))
   (over all
    (is-contained-by ?ll ?d))) :effect
  (and
   (at end (and (not (wet ?la1)) (not (wet ?la2)) (not (wet ?la3))))
   (at end (decrease (cash ?p) (fee-for-use ?d)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action wash-laundry-load :parameters
  (?p - person ?w - laundry-washing-machine ?l - location ?ll - laundry-load ?la1 ?la2 ?la3 - laundry) :duration
  (= ?duration 0.75) :condition
  (and
   (at start (at-location ?p ?l))
   (at start (at-location ?ll ?l))
   (at start (at-location ?w ?l))
   (over all
    (is-contained-by ?la1 ?ll))
   (over all
    (is-contained-by ?la2 ?ll))
   (over all
    (is-contained-by ?la3 ?ll))
   (at start (dirty ?la1))
   (at start (dirty ?la2))
   (at start (dirty ?la3))
   (at start (>= (cash ?p) (fee-for-use ?w)))
   (over all
    (is-contained-by ?ll ?w))) :effect
  (and
   (at end (and (not (dirty ?la1)) (not (dirty ?la2)) (not (dirty ?la3)) (wet ?la1) (wet ?la2) (wet ?la3)))
   (at end (decrease (cash ?p) (fee-for-use ?w)))
   (at end (assign (actions) (+ (actions) 1))))))