;; $VAR1 = {
;;           'Includes' => {
;;                           'BASEKB_WORK1' => {}
;;                         },
;;           'Units' => undef
;;         };

(define
 (domain BASEKB_WORK1)
 (:requirements :typing :derived-predicates)
 (:types)
 (:predicates
  (all-pending-work-accomplished ?p - person ?d - date)
  (ready-for-work ?p - person))
 (:functions
  (hours-worked-on-date ?p - person ?d - date))
 (:derived
  (ready-for-work ?p - person)
  (and
   (presentable ?p)
   (not
    (exhausted ?p))))
 (:durative-action work-fifteen-minutes :parameters
  (?p - person ?c - computer ?o - officeroom ?d - date) :duration
  (= ?duration 0.25) :condition
  (and
   (over all
    (ready-for-work ?p))
   (over all
    (at-location ?p ?o))
   (over all
    (at-location ?c ?o))
   (over all
    (not
     (exhausted ?p)))
   (over all
    (and
     (today ?d)
     (workday ?d)))
   (over all
    (<=
     (hours-worked-on-date ?p ?d) 10))
   (over all
    (<=
     (food-ingested ?p) 0))) :effect
  (and
   (at end (assign (hours-worked-on-date ?p ?d) (+ (hours-worked-on-date ?p ?d) 0.25)))
   (at end (assign (actions) (+ (actions) 1))))))