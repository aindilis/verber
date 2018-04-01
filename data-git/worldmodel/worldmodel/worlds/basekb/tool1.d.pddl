;; $VAR1 = {
;;           'Includes' => {
;;                           'BASEKB_TOOL1' => {}
;;                         },
;;           'Units' => undef
;;         };

(define
 (domain BASEKB_TOOL1)
 (:requirements :derived-predicates :typing)
 (:types tool stuff outlet furniture electric-device container bed - object desk - furniture computer battery-powered-device - electric-device bag - container laptop - battery-powered-device)
 (:predicates
  (is-contained-by ?ob1 - object ?c - container)
  (plugged-in ?b - electric-device)
  (use-is-required ?o - object))
 (:functions
  (charge-level ?r - battery-powered-device)
  (charge-rate ?r - battery-powered-device)
  (discharge-rate ?r - battery-powered-device))
 (:durative-action arm :parameters
  (?p - person ?o - object ?l - location) :duration
  (= ?duration 0) :condition
  (and
   (at start (at-location ?p ?l))
   (at start (at-location ?o ?l))
   (at start (mobile ?o))) :effect
  (and
   (at end (use-is-required ?o))))
 (:durative-action charge-fully :parameters
  (?b - battery-powered-device ?o - outlet ?p - person ?l - location) :duration
  (= ?duration (/ (- 1 (charge-level ?b)) (charge-rate ?b))) :condition
  (and
   (at start (at-location ?p ?l))
   (over all
    (at-location ?o ?l))
   (over all
    (at-location ?b ?l))) :effect
  (and
   (at end (assign (charge-level ?b) 1))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action load :parameters
  (?p - person ?ob - object ?lo - container ?l - location) :duration
  (= ?duration 0.1) :condition
  (and
   (over all
    (mobile ?ob))
   (over all
    (forall
     (?lc - lockable-container)
     (not
      (and
       (= ?lc ?lo)
       (locked-container ?lc)))))
   (at start (at-location ?p ?l))
   (at start (at-location ?ob ?l))
   (at start (at-location ?lo ?l))) :effect
  (and
   (at end (is-contained-by ?ob ?lo))
   (at end (not (at-location ?ob ?l)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action plug-in :parameters
  (?p - person ?b - battery-powered-device ?o - outlet ?l - location) :duration
  (= ?duration 0.1) :condition
  (and
   (over all
    (at-location ?p ?l))
   (over all
    (at-location ?o ?l))
   (over all
    (at-location ?b ?l))
   (over all
    (not
     (exists
      (?co - lockable-container)
      (is-contained-by ?b ?co))))) :effect
  (and
   (at end (plugged-in ?b))))
 (:durative-action unload :parameters
  (?p - person ?ob - object ?lo - lockable-container ?l - location) :duration
  (= ?duration 0.1) :condition
  (and
   (over all
    (mobile ?ob))
   (over all
    (forall
     (?lc - lockable-container)
     (not
      (and
       (= ?lc ?lo)
       (locked-container ?lc)))))
   (at start (is-contained-by ?ob ?lo))
   (at start (at-location ?lo ?l))
   (at start (at-location ?p ?l))) :effect
  (and
   (at end (not (is-contained-by ?ob ?lo)))
   (at end (at-location ?ob ?l))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action unplug :parameters
  (?p - person ?b - battery-powered-device ?o - outlet ?l - location) :duration
  (= ?duration 0.1) :condition
  (and
   (at start (plugged-in ?b))) :effect
  (and
   (at end (not (plugged-in ?b)))))
 (:durative-action use-object :parameters
  (?p - person ?o - object ?l - location) :duration
  (= ?duration 1) :condition
  (and
   (over all
    (at-location ?p ?l))
   (over all
    (at-location ?o ?l))) :effect
  (and
   (at end (not (use-is-required ?o)))
   (at end (assign (actions) (+ (actions) 1))))))