;; $VAR1 = {
;;           'Units' => undef,
;;           'Includes' => {
;;                           'BASEKB_AGENT1' => {}
;;                         }
;;         };

(define
 (domain BASEKB_AGENT1)
 (:requirements :typing :derived-predicates)
 (:types person - object)
 (:predicates
  (autonomous ?ob - object)
  (holding ?ob0 ?ob1 - object)
  (mobile ?ob - object))
 (:derived
  (mobile ?ob - object)
  (autonomous ?ob))
 (:durative-action move :parameters
  (?ob0 - object ?l0 ?l1 - location) :duration
  (= ?duration 0.15) :condition
  (and
   (over all
    (autonomous ?ob0))
   (at start (at-location ?ob0 ?l0))
   (at start (not (inaccessible ?l0)))
   (at end (not (inaccessible ?l1)))
   (at end (not (exists (?lo - lockable-container) (not (locked-container ?lo)))))) :effect
  (and
   (at end (not (at-location ?ob0 ?l0)))
   (at end (at-location ?ob0 ?l1))
   (at end (assign (actions) (+ (actions) 1)))
   (at end (assign (total-walking-distance) (+ (total-walking-distance) 1)))))
 (:durative-action pick-up :parameters
  (?ob0 - object ?ob1 - object ?l - location) :duration
  (= ?duration 0.1) :condition
  (and
   (over all
    (autonomous ?ob0))
   (over all
    (mobile ?ob1))
   (over all
    (at-location ?ob0 ?l))
   (at start (at-location ?ob1 ?l))) :effect
  (and
   (at end (holding ?ob0 ?ob1))
   (at end (not (at-location ?ob1 ?l)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action set-down :parameters
  (?ob0 - object ?ob1 - object ?l - location) :duration
  (= ?duration 0.1) :condition
  (and
   (over all
    (autonomous ?ob0))
   (at start (holding ?ob0 ?ob1))
   (over all
    (at-location ?ob0 ?l))) :effect
  (and
   (at end (not (holding ?ob0 ?ob1)))
   (at end (at-location ?ob1 ?l))
   (at end (assign (actions) (+ (actions) 1))))))