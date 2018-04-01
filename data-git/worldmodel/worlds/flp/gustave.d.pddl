;; $VAR1 = {
;;           'Units' => undef,
;;           'Includes' => {}
;;         };

(define
 (domain gustave)
 (:requirements :typing :fluents :durative-actions :timed-initial-literals :negative-preconditions :derived-predicates)
 (:types purpose product accountHolder - object)
 (:predicates
  (can ?p - purpose)
  (okay)
  (on-time ?p - purpose)
  (paid ?a1 ?a2 - accountHolder ?p - purpose)
  (payment-in-progress ?a1 ?a2 - accountHolder ?p - purpose)
  (unpaid ?a1 ?a2 - accountHolder ?p - purpose))
 (:functions
  (balance ?a - accountHolder)
  (loanRequestFor ?a1 ?a2 - accountHolder ?p - purpose)
  (promiseToPayFor ?a1 ?a2 - accountHolder ?p - purpose)
  (total-actions))
 (:durative-action pay-on-time :parameters
  (?a1 ?a2 - accountHolder ?p - purpose) :duration
  (= ?duration 0.151) :condition
  (and
   (at start (okay))
   (over all
    (can ?p))
   (over all
    (on-time ?p))
   (over all
    (unpaid ?a1 ?a2 ?p))
   (at start (>= (balance ?a1) (promiseToPayFor ?a1 ?a2 ?p)))) :effect
  (and
   (at start (decrease (balance ?a1) (promiseToPayFor ?a1 ?a2 ?p)))
   (at end (increase (balance ?a2) (promiseToPayFor ?a1 ?a2 ?p)))
   (at end (paid ?a1 ?a2 ?p))
   (at end (not (unpaid ?a1 ?a2 ?p)))
   (at end (increase (total-actions) 1)))))