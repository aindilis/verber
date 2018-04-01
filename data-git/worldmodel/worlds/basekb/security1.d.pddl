;; $VAR1 = {
;;           'Includes' => {
;;                           'BASEKB_SECURITY1' => {}
;;                         },
;;           'Units' => undef
;;         };

(define
 (domain BASEKB_SECURITY1)
 (:requirements :typing :derived-predicates)
 (:types locker - lockable-container lockable-container - container)
 (:predicates
  (locked-container ?lo - lockable-container)
  (locked-door ?d - door))
 (:durative-action lock-container :parameters
  (?p - person ?lo - lockable-container ?l - location) :duration
  (= ?duration 0.1) :condition
  (and
   (at start (not (locked-container ?lo)))
   (at start (at-location ?p ?l))
   (at start (at-location ?lo ?l))) :effect
  (and
   (at end (locked-container ?lo))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action lock-door :parameters
  (?p - person ?d - door ?l1 - location ?l2 - location) :duration
  (= ?duration 0.1) :condition
  (and
   (at start (not (locked-door ?d)))
   (at start (closed ?d))
   (at start (at-location ?p ?l1))
   (at start (has-door ?d ?l1 ?l2))) :effect
  (and
   (at end (locked-door ?d))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action unlock-container :parameters
  (?p - person ?lo - lockable-container ?l - location) :duration
  (= ?duration 0.1) :condition
  (and
   (at start (locked-container ?lo))
   (at start (at-location ?p ?l))
   (at start (at-location ?lo ?l))) :effect
  (and
   (at end (not (locked-container ?lo)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action unlock-door :parameters
  (?p - person ?d - door ?l1 - location ?l2 - location) :duration
  (= ?duration 0.1) :condition
  (and
   (at start (locked-door ?d))
   (at start (at-location ?p ?l1))
   (at start (has-door ?d ?l1 ?l2))) :effect
  (and
   (at end (not (locked-door ?d)))
   (at end (assign (actions) (+ (actions) 1))))))